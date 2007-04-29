Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXD2RaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXD2RaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964934AbXD2RaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:30:00 -0400
Received: from gw.goop.org ([64.81.55.164]:58950 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbXD2R36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:29:58 -0400
Message-Id: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:28:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 00/32] xen: Xen implementation for paravirt_ops
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

This series of patches implements the Xen paravirt-ops interface.
It applies to 2.6.21 + 2.6.21-070428-1 + the patches I've posted over
the last couple of days.

Changes since the last posting:
 - update per review comments
   - comment each file
   - comment barrier use
   - use common cpu sibling setup
 - fixed a few minor bugs, specifically a traceirq mismatch warning
 - some xenbus cleanups as a result of my review; more coming
 - split xen-core into more pieces

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

