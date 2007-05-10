Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbXEJCJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbXEJCJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 22:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXEJCJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 22:09:31 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:57127 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbXEJCJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 22:09:30 -0400
Message-Id: <20070510015555.973107048@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 May 2007 21:55:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: [patch 00/10] Linux Kernel Markers for 2.6.21-mm2
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 10 May 2007 02:09:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

He is an updated, folded, version of the Linux Kernel Markers. It replaces the
version found in 2.6.21-mm2 at the exact same spot in the series file.

Main changes :
- It renames the MARK() trace_mark(), as suggested by Christoph Hellwig.
- It now defines the structures contained out of the marker section outside of
  the #ifdef __KERNEL__ so the SystemTAP tool can use the header to extract the
  markers from the kernel binary.
- The i386 optimization has been tweaked a bit : the call is now in the else
  branch. It has something to do with the i386 "fast path" being the taken
  branch of a jump, to make loops faster. It seems that the if/else statements
  are also affected : the if () will be faster than the else. Therefore, I put
  the call in the else, to make sure the fastest path is when the marker is
  disabled.
- I added the blktrace port to the markers infrastructure. It makes one in-tree
  markers user.

Please remove :

linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
linux-kernel-markers-non-optimized-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
#
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch


And add, instead :

linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-header-visible-from-userspace.h
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
#
linux-kernel-markers-define-the-linker-macro-extra_rwdata.patch
linux-kernel-markers-use-extra_rwdata-in-architectures.patch
#
linux-kernel-markers-port-blktrace-to-markers.patch


Thanks,

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
