Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZIOGEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZIOGEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZIOGEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:04:36 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:54975 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZIOGEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:04:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=E0iA6rR8wPAtJmx9gw3Mn4ssRIr2vqBZ+n/ceo+YEBGwXGbx7TlSYa3vygVSueQwGk
         FxbBdnEIlmSOjtGMzQTza9ufhDa50hZaB5rhf47SICYPjQmTlrF+JjvrAuo15Li/EiiK
         GyD/yHNDLl4sWepCk8TFekuXk+raJsHGrajGs=
MIME-Version: 1.0
In-Reply-To: <1252850453.23599.13.camel@mulgrave.site>
References: <20090913040104.ab1d0b69.const@mimas.ru> <1252850453.23599.13.camel@mulgrave.site>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 15 Sep 2009 15:57:39 +1000
Message-ID: <646765f40909142257t560b314dt74d4158a497f0460@mail.gmail.com>
Subject: Re: [PATCH] hwmon: Driver for SCSI/ATA temperature sensors
To: James Bottomley <James.Bottomley@suse.de>
Cc: Constantin Baranov <const@mimas.ru>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 00:00, James Bottomley <James.Bottomley@suse.de> wrote:
> On Sun, 2009-09-13 at 04:01 +0500, Constantin Baranov wrote:
>> The scsitemp module attaches a device to each SCSI device
>> and registers it in hwmon. Currently the only method of
>> reading temperature is ATA SMART. Adding support of the
>> pure SCSI methods is provided.
>
> The code, as you wrote it looks fine.
>
> The basic problem are the effects.  Right at the moment it tries to send
> an ATA_16 encapsulated SMART command to every SCSI device in the system.
> We simply can't allow this.  A huge number of SCSI presenting USB
> devices are known to lock up when they see either ATA_X encapsulation or
> SMART commands.  It's not really even safe to send ATA_X to SCSI
> devices.  The modern ones should all error out fine, but the older ones
> are likely to be less tolerant.
>
> Finally, this:
>
>> +               if (attr[2] == 194) {
>> +                       *temp = attr[7] * 1000;
>> +                       err = 0;
>> +                       break;
>
> Smart attribute 194 is highly vendor specific ... for instance my new
> SATA drive doesn't implement it (it does implement 190 instead).
>
> So really, given the complexity of just obtaining the data and the
> problem of matching which data to obtain to which device you have, why
> not just use smartctl from userspace for monitoring?  you could even
> just plug into smartd, it seems to have most of the necessary heuristics
> built in already.

There's even a util called hddtemp which handles all this and has a
database of smart attributes to use for most drives.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
