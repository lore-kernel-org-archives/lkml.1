Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbXJ3TYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbXJ3TYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757739AbXJ3TVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:21:50 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54012 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784AbXJ3TVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:21:49 -0400
Message-Id: <20071030191557.947156623@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 30 Oct 2007 15:15:57 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, matthew@wil.cx,
       linux-arch@vger.kernel.org, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       Christoph Lameter <clameter@sgi.com>
Subject: [patch 00/28] cmpxchg_local standardization across architectures
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 30 Oct 2007 19:21:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the patchset that performs cmpxchg_local and cmpxchg64_local
standardization across architectures. It uses interrupt save/restore to emulate
the atomic operation on architectures lacking such atomic op.

We have seen interesing performance gain in slub on architectures where the
local cmpxchg is faster than interrupt disable, namely x86 and amd64. It becomes
less interesting on architectures lacking atomic ops and where the only cmpxchg
primitive available is almost as fast as irq disable/enable (ia64); a small
performance hit can be expected, mostly due to the additionnal memory barriers
it adds to the code (and the fact that it is faster to disable interrupts once
for a longer time rather than multiple times).

It applies in this order on 2.6.23-mm1 :

add-cmpxchg-local-to-generic-for-up.patch
i386-cmpxchg64-80386-80486-fallback.patch
add-cmpxchg64-to-alpha.patch
add-cmpxchg64-to-mips.patch
add-cmpxchg64-to-powerpc.patch
add-cmpxchg64-to-x86_64.patch
#
add-cmpxchg-local-to-arm.patch
add-cmpxchg-local-to-avr32.patch
add-cmpxchg-local-to-blackfin.patch
add-cmpxchg-local-to-cris.patch
add-cmpxchg-local-to-frv.patch
add-cmpxchg-local-to-h8300.patch
add-cmpxchg-local-to-ia64.patch
add-cmpxchg-local-to-m32r.patch
fix-m32r-__xchg.patch
fix-m32r-include-sched-h-in-smpboot.patch
local_t_m32r_optimized.patch
add-cmpxchg-local-to-m68k.patch
add-cmpxchg-local-to-m68knommu.patch
add-cmpxchg-local-to-parisc.patch
add-cmpxchg-local-to-ppc.patch
add-cmpxchg-local-to-s390.patch
add-cmpxchg-local-to-sh.patch
add-cmpxchg-local-to-sh64.patch
add-cmpxchg-local-to-sparc.patch
add-cmpxchg-local-to-sparc64.patch
add-cmpxchg-local-to-v850.patch
add-cmpxchg-local-to-xtensa.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
