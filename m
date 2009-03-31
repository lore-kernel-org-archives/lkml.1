Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbZCaOGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbZCaOGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758551AbZCaOGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:06:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:40277 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbZCaOGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:06:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=FgxodDBWtmp/6oQFmlBa2KgZ6S1Y6+HJQriEWPBEkeEv6P/DrEmPEkl7+Jxx667Iij
         KEOB4mk5kYgGd8ZCdoR46dROl/OGIFjxLmWgvkKidwJybfpceAaXzhUOxi5OZe4l/KDS
         nbgyY45/mCg7+OU61OeRh0XNxqXKy2VLqRA78=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <49D20E1B.7010104@nessie.de>
References: <49CFCB2A.4020505@nessie.de> <49CFEA24.10700@nessie.de>
	 <20090330072713.GA13776@liondog.tnic>
	 <200903302228.54601.bzolnier@gmail.com>
	 <20090331074508.GA16403@liondog.tnic>
	 <20090331122820.167d52e5@the-village.bc.nu>
	 <49D20E1B.7010104@nessie.de>
Date: Tue, 31 Mar 2009 16:06:11 +0200
Message-ID: <9ea470500903310706i23e2225fo42ff17f14c277594@mail.gmail.com>
Subject: Re: Bug in 2.6.29 ide-cd: Kernel freeze: bisected + unacceptable 
	workaround
From: Borislav Petkov <petkovbb@googlemail.com>
To: Michael Roth <mroth@nessie.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 31, 2009 at 2:35 PM, Michael Roth <mroth@nessie.de> wrote:
>>> take it ok. Also, if I remember correctly, the original ide-cd behavior
>>> was to issue the command and _then_ start DMA so we're back to that. I
>>> guess now we should be concerned whether the other ATAPI devices can
>>> handle the reverse situation where you first issue a command and _then_
>>> start DMA.. Hmm...
>>
>> Most devices don't care but you do need to follow the exact ATAPI spec.
>> If you search way back through the archives you'll find long discussions
>> on this during either 2.4 or 2.2 when HP hit problems caused by us
>> turning DMA on too early.
>
> AFAIK, the old bevavior was to start DMA _after_ issuing the command _only_
> for CD-drives and for the remaining ide devices the other way around,
> why not just restore the old behavior and do the DMA after command only
> for CD-drives?

because common atapi code should adhere to the spec, as Alan said, no matter
whether it is a cd or a floppy or [you name it]-drive.

@Alan: I guess you refer to
http://lkml.indiana.edu/hypermail/linux/kernel/0305.1/2241.html, for example.
I think I'll be on the safe side when I turn on DMA _after_
writing the ATAPI command packet into the data register - it is the correct
order of steps according to the ATA spec. So, if there are devices which still
choke on that, then they're simply buggy and those will hopefully be a small
number so that a blacklist with a flag as a workaround would be more or
less ok for them - we do that for other b0rked devices anyway.

-- 
Regards/Gruss,
Boris
