Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbZFQEFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbZFQEFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbZFQEFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:05:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:41978 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbZFQEFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:05:06 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de
Subject: [GIT PATCH core/percpu] x86,percpu: generalize 4k and lpage allocator
Date: Wed, 17 Jun 2009 13:04:30 +0900
Message-Id: <1245211476-27015-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 04:04:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Upon ack, please pull from the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu-make-allocators-generic

This patchset generalizes 4k and lpage first chunk allocators and
makes x86 call these generic helpers.  This will help converting other
architectures to dynamic percpu and be the basis for further first
chunk allocator improvements by standardizing how the first chunk is
allocated.

This patchset contains the following six patches.

 0001-x86-make-pcpu_chunk_addr_search-matching-stricter.patch
 0002-percpu-drop-unit_size-from-embed-first-chunk-alloc.patch
 0003-x86-percpu-generalize-4k-first-chunk-allocator.patch
 0004-percpu-make-4k-first-chunk-allocator-map-memory.patch
 0005-x86-percpu-generalize-lpage-first-chunk-allocator.patch
 0006-percpu-simplify-pcpu_setup_first_chunk.patch

0001 and 0002 are cleanups which don't make any functional difference.

0003-0004 generalizes 4k allocator and makes its behavior more uniform
with other allocators.  0005 generalizes lpage allocator.

As 0004 makes generic alloc/map handling in pcpu_setup_first_chunk()
unnecessary, 0006 drops it.  This simplification will allow dropping
pcpu_chunk->page[] by later patchset.

This patchset is on top of

linus-2.6#master (300df7dc89cc276377fc020704e34875d5c473b6)
+ [1] tj-percpu-convert-most-archs, take#3
+ [2] x86-percpu-fix-pageattr, take#4

and contains the following changes.

 arch/x86/include/asm/percpu.h  |    9 
 arch/x86/kernel/setup_percpu.c |  247 ++--------------------
 arch/x86/mm/pageattr.c         |    1 
 include/linux/percpu.h         |   44 +++
 mm/percpu.c                    |  455 ++++++++++++++++++++++++++++++++---------
 5 files changed, 433 insertions(+), 323 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel.cross-arch/3818
[2] http://thread.gmane.org/gmane.linux.kernel.cross-arch/3825
