Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbXFGIJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbXFGIJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbXFGIJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:09:25 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38422 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbXFGIJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:09:24 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 7 Jun 2007 04:07:46 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: whacking out the __get_dma_pages() macro.
Message-ID: <Pine.LNX.4.64.0706070404300.3186@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  the following represents the entire set of calls to the
__get_dma_pages() macro that i plan on reverting back to the regular
get_free_pages() macro so __get_dma_pages() can be tossed.  any major
objections?

arch/m68k/atari/stram.c:#define BLOCK_GFP	0x08	/* block allocated with __get_dma_pages() */
arch/m68k/atari/stram.c: *  - If mem_init() already has been called, try with __get_dma_pages().
arch/m68k/atari/stram.c:		/* After mem_init(): can only resort to __get_dma_pages() */
arch/m68k/atari/stram.c:		addr = (void *)__get_dma_pages(GFP_KERNEL, get_order(size));
Documentation/scsi/ChangeLog.1992-1997:	Change memory allocation to work around bugs in __get_dma_pages.
drivers/net/mvme147.c:	lp->ram = __get_dma_pages(GFP_ATOMIC, 3);	/* 16K */
drivers/net/3c505.c:	return __get_dma_pages(GFP_KERNEL, order);
drivers/net/cs89x0.c:			lp->dma_buff = (unsigned char *)__get_dma_pages(GFP_KERNEL,
drivers/net/appletalk/ltpc.c:        return __get_dma_pages(GFP_KERNEL, order);
drivers/block/floppy.c:#define fd_dma_mem_alloc(size) __get_dma_pages(GFP_KERNEL,get_order(size))
drivers/block/xd.c:#define xd_dma_mem_alloc(size) __get_dma_pages(GFP_KERNEL,get_order(size))
drivers/char/esp.c:		dma_buffer = (char *)__get_dma_pages(
drivers/char/mbcs.c:	hostAddr = __get_dma_pages(GFP_KERNEL, get_order(len));
drivers/char/mbcs.c:	hostAddr = __get_dma_pages(GFP_KERNEL, get_order(len));
include/asm-mips/mach-jazz/floppy.h:	mem = __get_dma_pages(GFP_KERNEL, get_order(size));
include/asm-mips/mach-generic/floppy.h:	mem = __get_dma_pages(GFP_KERNEL, get_order(size));
include/asm-parisc/floppy.h:	return __get_dma_pages(GFP_KERNEL, get_order(size));
include/asm-i386/floppy.h:	return __get_dma_pages(GFP_KERNEL,get_order(size));
include/asm-sh/floppy.h:	return __get_dma_pages(GFP_KERNEL,get_order(size));
include/linux/gfp.h:#define __get_dma_pages(gfp_mask, order) \
include/asm-x86_64/floppy.h:	return __get_dma_pages(GFP_KERNEL|__GFP_NORETRY,get_order(size));

  obviously, this was just a mindless grep, but you get the idea.  the
actual macro definition can be left in gfp.h for a while to
accommodate out-of-tree builds for now.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
