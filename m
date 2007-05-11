Return-Path: <linux-kernel-owner+w=401wt.eu-S1762826AbXEKTJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826AbXEKTJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758798AbXEKTJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:09:30 -0400
Received: from 161.sub-75-209-96.myvzw.com ([75.209.96.161]:60044 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758775AbXEKTJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:09:29 -0400
X-Greylist: delayed 804 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 May 2007 15:09:29 EDT
Message-Id: <20070511000643.025196000@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 10 May 2007 17:06:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [patch 00/28]xen: Xen implementation for paravirt_ops
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

This series of patches implements the Xen paravirt-ops interface.  It
applies to 2.6.21-git13 + patches-2.6.21-git7-070507-1.tar.gz (I think
"unwinder" is the only patch which doesn't apply to git13, and the
sched-clock patches are the only ones which this series actually
needs).

Changes since the last posting:
 - More netfront review and cleanup
 - Added ability to cleanly halt/reboot guests from outside the domain.
 - Folded bugfix patches into their main patch
 - Lots of little style and other cleanups

These patches are now moderately well tested, with several successful
runs through XenSource's regression test suite, and some amount of
non-me testing.  While I wouldn't go into production with a
xen/paravirt_ops kernel right now, it does seem pretty functional.

This series generally restricts itself to Xen-specific parts of the
tree, though it does make a few small changes elsewhere.

It includes:
 - some helper routines for allocating address space and walking pagetables
 - Xen interface header files
 - Core Xen implementation (boot, mmu, events, time)
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

