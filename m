Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZFGN40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZFGN40 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZFGN4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:56:19 -0400
Received: from mail-qy0-f177.google.com ([209.85.221.177]:39616 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZFGN4S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:56:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YW6ON9ombBW9tcZ5edD2DySKsrvVCtI8e34hD8if29Du/vs5+bNt17p5DFate3zIoh
         UQxxeT4n3UBdfmN5JHLhAEJeu/+90/RJxEY/HMMh+Zzv3kK6XDGuVwTBV+n453GGDpNS
         bUcd3gmVgsy9Vu9Nl3L+Ec7h6QLjyO5O9F4Lw=
MIME-Version: 1.0
In-Reply-To: <4A2B80F9.9070103@gmail.com>
References: <20090606230137.17029.51286.stgit@t61.ukuu.org.uk>
	 <4A2B80F9.9070103@gmail.com>
Date: Sun, 7 Jun 2009 09:56:20 -0400
Message-ID: <9599edfc0906070656u161be30tab0966469a1c9cb1@mail.gmail.com>
Subject: Re: [PATCH] dmi: sanity check BIOS tables
From: Jeff Mitchell <jeffrey.mitchell@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 7, 2009 at 4:57 AM, Jiri Slaby<jirislaby@gmail.com> wrote:
> On 06/07/2009 01:01 AM, Alan Cox wrote:
>> @@ -260,6 +276,11 @@ static void __init dmi_save_ipmi_device(const struct dmi_header *dm)
>>       struct dmi_device *dev;
>>       void * data;
>>
>> +     if (((u8 *)dm) + dm->length > dmi_end) {
>
> I think this should be >= too.
>
>> +             printk(KERN_ERR "dmi_save_ipmi_device: table overrun.\n");
>> +             return;
>> +     }
>> +

I've tried this patch, both with Jiri's suggestion and without.
Neither makes a difference, except for slightly changing the output (
new output at http://tinypic.com/r/2di4mlg/5 )

Let me know if I can provide anything more to help debug.

Thanks,
Jeff
