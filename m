Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbXGGVpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbXGGVpd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 17:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXGGVp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 17:45:26 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59386 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbXGGVpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 17:45:25 -0400
Message-ID: <4690096A.4020602@zytor.com>
Date: Sat, 07 Jul 2007 14:45:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <468DA42D.7050309@zytor.com> <Pine.LNX.4.64.0707072030230.1536@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.58.0707072255260.3562@be1.lrz> <Pine.LNX.4.64.0707072335160.1536@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707072335160.1536@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
> Come to speak of it, I think you can have it much easier by having the kernel
> exporting the cpio image as a virtual file inside rootfs, so that you could
> re-extract it inside a tmpfs. In other words:
> 
> mount -t tmpfs tmpfs /mnt;
> cd /mnt;
> cpio -diuv </initramfs.cpio;
> #
> # switch_root nukes rootfs, pivot_roots and execs some init
> klibc_switch_root .; # or something like that
> 
> Of course this needs double the memory than directly mounting tmpfs as 
> rootfs, but it's an idea too.
> 

Well, we're doing exactly this for non-initramfs initrd, however, it
would definitely be cleaner just to overmount rootfs with a tmpfs before
extraction -- it's an absolutely trivial amount of code; the biggest
complexity would be spotting the kernel command line option to invoke it.

Yet another variant, which works on existing kernels, is to have a
nested cpio, where your rootfs consists of a trivial /init which mounts
tmpfs and extracts another tar- or cpioball.

	-hpa

