Return-Path: <linux-kernel-owner+w=401wt.eu-S1423030AbXEDXpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423030AbXEDXpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423056AbXEDXog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:44:36 -0400
Received: from 116.sub-75-210-58.myvzw.com ([75.210.58.116]:46311 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423034AbXEDXnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:43:24 -0400
Message-Id: <20070504232051.411946839@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 04 May 2007 16:20:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 00/29] xen: Xen implementation for paravirt_ops
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

This series of patches implements the Xen paravirt-ops interface.
It applies to 2.6.21-git3 + ff patches-2.6.21-git3-070501-1.tar.gz.

Changes since the last posting:
 - reviews of xenbus (me), netfront (hch, rusty, herbert xu) and
   blockfront (hch), with most comments addressed.  Netfront review
   revealed a couple of real bugs, and the code for all three is looking
   cleaner overall.
 - Folded bugfix patches into their main patch
 - Lots of little style and other cleanups

There may be a trivial conflict in xen-hvc-console because of the
lguest console.

These patches are now moderately well tested, with several successful
runs through XenSource's regression test suite, and some amount of
non-me testing.  While I wouldn't go into production with a
xen/paravirt_ops kernel right now, it does seem pretty functional.

This series generally restricts itself to Xen-specific parts of the
tree, though it does make a few small changes elsewhere.

It includes:
 - some helper routines for allocating address space and walking pagetables
 - Xen interface header files
 - Core Xen implementation
 - Efficient late-pinning/early-unpinning pagetable handling
 - Virtualized time, including stolen time
 - SMP support
 - Preemption support
 - Batched pagetable updates
 - Xen console, based on hvc console
 - Xenbus
 - Netfront, the paravirtualized network device
 - Blockfront, the paravirtualized block device

Thanks,
	J
-- 

