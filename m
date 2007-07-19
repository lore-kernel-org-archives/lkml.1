Return-Path: <linux-kernel-owner+w=401wt.eu-S938578AbXGSKa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938578AbXGSKa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933113AbXGSKBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:01:54 -0400
Received: from ns2.suse.de ([195.135.220.15]:33462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765359AbXGSKBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:01:52 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>, torvalds@osdl.org
Subject: kmalloc zero size changes break i386
Date: Thu, 19 Jul 2007 12:01:35 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191201.35777.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


qemu testing and booting test machines with i386 kernels wasn't very successfull
with recent git kernels. I got either BUGs because of failing sysfs initialization
or oopses in kmalloc, but no user land.

I bisected it down to this commit.

To reproduce: try to boot a 386 defconfig kernel, compiled with gcc 4.1, in qemu

-Andi 

6cb8f91320d3e720351c21741da795fed580b21b is first bad commit
commit 6cb8f91320d3e720351c21741da795fed580b21b
Author: Christoph Lameter <clameter@sgi.com>
Date:   Tue Jul 17 04:03:22 2007 -0700

    Slab allocators: consistent ZERO_SIZE_PTR support and NULL result semantics
    
    Define ZERO_OR_NULL_PTR macro to be able to remove the checks from the
    allocators.  Move ZERO_SIZE_PTR related stuff into slab.h.
    
    Make ZERO_SIZE_PTR work for all slab allocators and get rid of the
    WARN_ON_ONCE(size == 0) that is still remaining in SLAB.
    
    Make slub return NULL like the other allocators if a too large memory segmen
t
    is requested via __kmalloc.
    
    Signed-off-by: Christoph Lameter <clameter@sgi.com>
    Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

