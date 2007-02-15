Return-Path: <linux-kernel-owner+w=401wt.eu-S965731AbXBOMR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965731AbXBOMR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 07:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965909AbXBOMR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 07:17:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:38852 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965731AbXBOMR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 07:17:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HBXsICTA9XhKsgkqhDT6dXXcvFxm8paYXQyGrMJ0+o+xwtIQtWM5rsYmOzg9Sz8hED+6z1Yo67XP01qPDZhSZ8LxINylwhBUQr7/cjG3bDe8F6jHRBpN642sB5KG5J995rr+O+mBQV8Db9SwBCjnynWCryT7P9QskXOxCyufW/I=
Message-ID: <e13597370702150417o3888b71dtcc42e38156b46918@mail.gmail.com>
Date: Thu, 15 Feb 2007 15:17:23 +0300
From: "Eugene Ilkov" <e.ilkov@gmail.com>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Subject: Re: 2.6.20 mmc: problem with highspeed SD card
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D3F41C.3020600@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e13597370702131746q6a5d8e79i2341f5eb9c59bf6e@mail.gmail.com>
	 <45D3F41C.3020600@drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> Eugene Ilkov wrote:
> > I have I/O errors with Transcend SD highspeed card 2GB/150x when it's
> > mounted in r/w mode (cardreader on sharp sl-c1000)
> > It works well  if I reverse mmcv4 patch commited to 2.6.19-git2
> > (http://lkml.org/lkml/2006/10/4/27)
>
> That patch is not the same as you are referencing in the rest of your mail.

I geuss changes was started from that patch, I mean changes that comes
with that:
http://www.linuxhq.com/kernel/v2.6/19-git2/drivers/mmc/mmc.c

I found another related patch
http://mailman.laptop.org/pipermail/commits-kernel/2007-January/000554.html
so i guess i'm not alone


>
> > I'm not experienced in mmc, but I figured out that problem is
> > somewhere in mmc_read_switch_caps() and when i change cmd.arg value
> > from 0x80FFFFF1 to 0x00FFFFF1 it works fine too
> > What argument should have SD_SWITCH opcode?
> >
>
> The argument is correct, so I'm guessing that your controller might be a bit
> flaky and not handle the new timing.

> Can you enable MMC_DEBUG and send over the
> dmesg?

mmc debug output is too noisy
and i can give you only this:

mmc0: starting CMD18 arg 30007e00 flags 00000035
PXAMCI: irq 00000004 stat 00002140
PXAMCI: irq 00000005 stat 00002940
PXAMCI: irq 00000007 stat 00003940
mmc0: req done (CMD18): 0/0/0: 00000900 5f5a83d5 2db7ffbf 96800012
mmc0: starting CMD18 arg 0000ae00 flags 00000035
PXAMCI: irq 00000004 stat 00002140
PXAMCI: irq 00000005 stat 00002940
PXAMCI: irq 00000007 stat 00003940
mmc0: req done (CMD18): 0/0/0: 00000900 5f5a83d5 2db7ffbf 96800012
mmc0: starting CMD18 arg 0ab49e00 flags 00000035
PXAMCI: irq 00000004 stat 00002140
PXAMCI: irq 00000005 stat 00002940
PXAMCI: irq 00000007 stat 00003940
mmc0: req done (CMD18): 0/0/0: 00000900 5f5a83d5 2db7ffbf 96800012
mmc0: starting CMD18 arg 0ab4ae00 flags 00000035
PXAMCI: irq 00000004 stat 00002140
PXAMCI: irq 00000005 stat 00002940
PXAMCI: irq 00000007 stat 00003940
mmc0: req done (CMD18): 0/0/0: 00000900 5f5a83d5 2db7ffbf 96800012

with desabled mmc debug :

Linux version 2.6.20-rc1-mm1-z2 (root@fly) (gcc version 4.1.1 (Gentoo 4.1.1-r3))
 #58 PREEMPT Thu Feb 15 13:49:39 MSK 2007
CPU: XScale-PXA270 [69054117] revision 7 (ARMv5TE), cr=0000397f
Machine: SHARP Akita

[..skipped..]

mmcblk0: mmc0:b368 SDC   2009600KiB
 mmcblk0: p1
mmcblk0: error 2 transferring data
mmcblk0: error 2 transferring data
kjournald starting.  Commit interval 5 seconds
mmcblk0: error 2 transferring data
EXT3 FS on mmcblk0p1, internal journal
EXT3-fs: recovery complete.
mmcblk0: error 2 transferring data
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem).
Freeing init memory: 72K
mmcblk0: error 2 transferring data
mmcblk0: error 2 transferring data
mmcblk0: error 2 transferring data
mmcblk0: error 2 transferring data
mmcblk0: error 2 transferring data
mmcblk0: error 2 transferring data
mmcblk0: error 2 transferring data


i boot into root fs on SD, and it just hangs on remounting to rw, so
it's not easy to get full dmesg output with i/o error and mmc debug
info, but i'll try if it helps
