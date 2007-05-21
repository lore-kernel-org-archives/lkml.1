Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbXEUMmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbXEUMmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbXEUMmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:42:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:38871 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbXEUMmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EMudtPxym7i88OIa1ku11+wLwZZnznewknbVbpgfJUDyg22tXPUEgE+scGoSGHp7cIU6satJnAmcvTqw+A3mrhSyqg2PNDYW8+e+GTMqhQhpkasW7bwmUzAZLNQmwhCkQbIiYpbKzFqmDWokep9MbUKhFHRYuSFXHvwyWTwcQYQ=
Message-ID: <465193A5.4080103@gmail.com>
Date: Mon, 21 May 2007 14:42:13 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Alan Cox <alan@redhat.com>
CC: Robert de Rooy <robert.de.rooy@gmail.com>, linux-kernel@vger.kernel.org,
       bzolnier@gmail.com, jgarzik@pobox.com
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com> <464C1575.8070005@gmail.com> <464CB7C9.2080807@gmail.com> <46503192.1040300@gmail.com> <4650B9E3.7070409@gmail.com> <46518798.2020808@gmail.com> <20070521123738.GA30639@devserv.devel.redhat.com>
In-Reply-To: <20070521123738.GA30639@devserv.devel.redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, May 21, 2007 at 01:50:48PM +0200, Tejun Heo wrote:
>>> May 20 23:02:56 localhost kernel: ata3.00: qc timeout (cmd 0xef)
>>> May 20 23:02:56 localhost kernel: ata3.00: failed to set xfermode
>>> (err_mask=0x4)
>> Hmmm... It doesn't like SETXFERMASK either.  Please try the attached patch.
> 
> The CF 1.1 command list is pretty short. Unfortunately the patch you've
> given below won't itself cure the problem as some of the newer CF cards do
> need SETXFERMASK issuing to do higher PIO modes.

Yeap, it's a debug patch.  What I was thinking was adding a HORKAGE for
the device - e.g. ATA_HORKAGE_NO_SETXFERMODE, but product ID "Memory
Card Adapter" doesn't seem too specific.

> The CFA people also didn't put the CFA version in the ident data. What might
> work sanely would be
> 
> 	if (supports_pio == only_pio0 && cfa)

OIC.  I don't really know much about these CFA thingies.  If the above
should work for most devices, no objection from me.

-- 
tejun
