Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYKCVFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYKCVFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYKCVFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:05:09 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:53667 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbYKCVFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:05:08 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18vCShU8KRjncTd8QjDXWhk
Date: Mon, 3 Nov 2008 13:04:59 -0800
From: Tony Lindgren <tony@atomide.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: beagleboard@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [beagleboard] Diff between Linux-2.6.27-omap1-dirty and
	Linux-2.6.27-omap1 ?
Message-ID: <20081103210458.GD28924@atomide.com>
References: <cf70f0210810310608x37f8e3dcu3ab0023891fcb339@mail.gmail.com> <d82e647a0810312125q1e4760c4t6690d69e04b5c7b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0810312125q1e4760c4t6690d69e04b5c7b6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ming Lei <tom.leiming@gmail.com> [081031 21:26]:
> I also have this problem, even git-tree is not dirty.
> Why?

Looks like you've hit the ptebits problem.. See the arm-linux-kernel
mailing list archive or linux-omap list today for an experimental
patch to fix it.

Tony

> 
> Thanks!
> ------------------------------------------------------------
> Texas Instruments X-Loader 1.41
> Starting OS Bootloader...
> 
> 
> U-Boot 1.3.3 (Jul 10 2008 - 16:33:09)
> 
> OMAP3530-GP rev 2, CPU-OPP2 L3-165MHz
> OMAP3 Beagle Board + LPDDR/NAND
> DRAM:  128 MB
> NAND:  256 MiB
> In:    serial
> Out:   serial
> Err:   serial
> Audio Tone on Speakers  ... complete
> Hit any key to stop autoboot:  0
> OMAP3 beagleboard.org #
> OMAP3 beagleboard.org #
> OMAP3 beagleboard.org # printenv
> bootargs=console=ttyS2,115200n8 ramdisk_size=8192 root=/dev/ram0 rw
> rootfstype=ext2 initrd=0x81600000f
> bootcmd=mmcinit;fatload mmc 0 0x80300000 uImage;fatload mmc 0
> 0x81600000 rd-ext2.bin;bootm 0x80300000
> stdin=serial
> stdout=serial
> stderr=serial
> 
> Environment size: 257/131068 bytes
> OMAP3 beagleboard.org # mmcinit;fatload mmc 0 0x80300000 ui3;bootm 0x80300000
> reading ui3
> 
> 1723104 bytes read
> ## Booting kernel from Legacy Image at 80300000 ...
>    Image Name:   Linux-2.6.28-rc2-omap1-05147-g82
>    Image Type:   ARM Linux Kernel Image (uncompressed)
>    Data Size:    1723040 Bytes =  1.6 MB
>    Load Address: 80008000
>    Entry Point:  80008000
>    Verifying Checksum ... OK
>    Loading Kernel Image ... OK
> OK
> 
> Starting kernel ...
> 
> Uncompressing Linux...................................................................................
> 
> 
> 
> 
> 2008/10/31 Shivdas Gujare <shivdas.tech@gmail.com>:
> >
> > Hi All,
> >
> > I am working on testing Linux-2.6.27 omap kernel on beagle board.
> >
> > I cloned kernel from
> > git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
> >
> > and checked out to tag v2.6.27-omap1, I loaded kernel on beagle board,
> > and was able to boot properly like....
> >
> > OMAP3 beagleboard.org # bootm 0x80300000
> > ## Booting kernel from Legacy Image at 80300000 ...
> >   Image Name:   Linux-2.6.27-omap1
> >   Image Type:   ARM Linux Kernel Image (uncompressed)
> >   Data Size:    1614320 Bytes =  1.5 MB
> >   Load Address: 80008000
> >   Entry Point:  80008000
> >   Verifying Checksum ... OK
> >   Loading Kernel Image ... OK
> > OK
> >
> > Now, I done some operations, like checkout to master, checkout to
> > v2.6.26-omap1 and v2.6.25-omap1, loaded corresponding uImages to
> > beagle board
> > and was able to boot board every time.
> >
> > After this, I again checkout to v2.6.27-omap1, compiled and loaded
> > uImage to beagleboard
> > But this time I am not able to boot the board.
> > and Got the message like
> >
> > OMAP3 beagleboard.org # bootm 0x80300000
> > ## Booting kernel from Legacy Image at 80300000 ...
> >   Image Name:   Linux-2.6.27-omap1-dirty
> >   Image Type:   ARM Linux Kernel Image (uncompressed)
> >   Data Size:    1669176 Bytes =  1.6 MB
> >   Load Address: 80008000
> >   Entry Point:  80008000
> >   Verifying Checksum ... OK
> >   Loading Kernel Image ... OK
> > OK
> >
> > Starting kernel ...
> >
> > Uncompressing Linux...........................................................................................................
> > done, booting the kernel.
> >
> > and it, stucks at here..
> >
> > Here, the only difference I observed is "Image Name:
> > Linux-2.6.27-omap1" and "Image Name:   Linux-2.6.27-omap1-dirty",
> > where uImage with second Image name is not booting.
> >
> > I think, I have done something wrong here, while compilation and checkout.
> >
> > I just want to know in what cases "-dirty" is appended to linux kernel
> > Image Names or anything I done wrong?
> >
> > Thanks for your Helps.
> >
> > Regards,
> > Shivdas
> >
> > --~--~---------~--~----~------------~-------~--~----~
> > You received this message because you are subscribed to the Google Groups "Beagle Board" group.
> > To post to this group, send email to discussion@beagleboard.org.
> > To unsubscribe from this group, send email to beagleboard-unsubscribe@beagleboard.org
> > For more options, visit this group at http://groups.google.com/group/beagleboard?hl=en
> > -~----------~----~----~----~------~----~------~--~---
> >
> >
> 
> 
> 
> -- 
> Lei Ming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
