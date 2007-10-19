Return-Path: <linux-kernel-owner+w=401wt.eu-S935545AbXJSR5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935545AbXJSR5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbXJSR5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:57:07 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:51199 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbXJSR5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:57:06 -0400
Date: Fri, 19 Oct 2007 13:53:40 -0400
Message-Id: <200710191753.l9JHreeS012064@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [BLOCK2MTD] WARNING: at kernel/lockdep.c:2331 lockdep_init_map()
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been having this problem for some time with mtd, which I use to mount
jffs2 images (for unionfs testing).  I've seen it in several recent major
kernels, including 2.6.24.  Here's the sequence of ops I perform:

# cp jffs2-empty.img /tmp/foo
# losetup /dev/loop0 /tmp/foo
# modprobe mtdblock
# modprobe block2mtd block2mtd=/dev/loop0,128ki
# mount -t jffs2 /dev/mtdblock0 /n/lower/b0

The jffs2-empty.img is a small jffs2 image, of an empty directory, created
w/ the jffs2 utils.  At the point I modprobe block2mtd, I get the following
lockdep warning and a "BUG" message:

BUG: key f88e1340 not in .data!
WARNING: at kernel/lockdep.c:2331 lockdep_init_map()
 [<c0102bc2>] show_trace_log_lvl+0x1a/0x2f
 [<c0103692>] show_trace+0x12/0x14
 [<c01037b2>] dump_stack+0x15/0x17
 [<c0125432>] lockdep_init_map+0x94/0x3e4
 [<c0125001>] debug_mutex_init+0x2c/0x3c
 [<c01210d4>] __mutex_init+0x38/0x40
 [<f88e01d3>] 0xf88e01d3
 [<c011dda7>] parse_args+0x123/0x200
 [<c012b725>] sys_init_module+0xdd0/0x122c
 [<c0102586>] sysenter_past_esp+0x5f/0x91
 =======================
block2mtd: mtd0: [d: /dev/loop0] erase_size = 128KiB [131072]
block2mtd: version $Revision: 1.30 $

However, everything seems to work afterwards: jffs2 mounts, and all my
unionfs+jffs2 tests succeed.

So, what is this "key xxx not in .data" message and should I worry?  Is the
lockdep warning a problem?  (It might be a problem if lockdep warnings are
turned off afterwards, so lockdep won't complain about future warnings.)
Heck, am I using mtd/jffs correctly?

Thanks,
Erez.
