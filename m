Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbXGILal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbXGILal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXGILae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:30:34 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:52652 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbXGILad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:30:33 -0400
Date: Mon, 9 Jul 2007 13:30:25 +0200
From: DervishD <lkml@dervishd.net>
To: Douglas Gilbert <dougg@torque.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: cdparanoia not setting count and/or reply_len properly
Message-ID: <20070709113025.GB3015@DervishD>
Mail-Followup-To: Douglas Gilbert <dougg@torque.net>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	linux-scsi@vger.kernel.org
References: <20070708103928.GA20349@DervishD> <4690DA1B.3010901@s5r6.in-berlin.de> <4691ACEA.8000607@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4691ACEA.8000607@torque.net>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Douglas :)

 * Douglas Gilbert <dougg@torque.net> dixit:
> >>     I don't know if cdparanoia should be fixed, but certainly the
> >> warning could be issued only if CONFIG_SCSI_VERBOSE is set. This way you
> >> will have the message if something goes wrong and you want more info,
> >> but in cases where the warning is harmless your log will be clean...
> >>
> >>     Anyway, this message is not for make suggestions, but for asking for
> >> information: why is this warning happening? naugthy cdparanoia? naughty
> >> kernel? I'm a bit confused and I want to use my external DVD drive for
> >> ripping from time to time, to "exercise" it...
> 
> In Fedora 7 I see this:
> 
> # cdparanoia --version
> cdparanoia III release 9.8 (March 23, 2001)
> (C) 2001 Monty <monty@xiph.org> and Xiphophorus

    Same version here.

> So, given that date, lk 2.4.2 was out but it was probably
> a bit early to start using the sg version 3 interface
> which first appeared in lk 2.4.1 . So that "lets annoy
> the user" message was added by someone who got burnt by
> the old sg version 2 interface and decided people needed
> to be warned. The warning comes from this code is sg.c :

    OK, grand. So it's cdparanoia's fault.

>         /*
>          * SG_DXFER_TO_FROM_DEV is functionally equivalent to SG_DXFER_FROM_DEV,
>          * but is is possible that the app intended SG_DXFER_TO_DEV, because the
> re
>          * is a non-zero input_size, so emit a warning.
>          */
>         if (hp->dxfer_direction == SG_DXFER_TO_FROM_DEV)
>                 if (printk_ratelimit())
>                         printk(KERN_WARNING
>                                "sg_write: data in/out %d/%d bytes for SCSI comma
> nd 0x%x--"
>                                "guessing data in;\n" KERN_WARNING "   "
>                                "program %s not setting count and/or reply_len pr
> operly\n",
>                                old_hdr.reply_len - (int)SZ_SG_HEADER,
>                                input_size, (unsigned int) cmnd[0],
>                                current->comm);

    Yes, I did read the code, and I didn't find any reason for it to
exist, but I didn't understand the purpose of SG_DXFER_TO_FROM_DEV.
Thanks for explaining this :))

> It is probably about time that cdparanoia was updated ...

    I think the same, but given that it works, Monty probably doesn't
have much motivation to update it. I don't know if the problem resides
in the cdparanoia program itself (so using the DAE problem from cdrkit
will fix the issue) or in the paranoia library. In this case, the
problem will affect any program using the library.

    Anyway, if you need any testing, just tell :)

    Thanks a lot!

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
