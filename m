Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYDHQ0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYDHQ0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYDHQ0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:26:23 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38462 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751739AbYDHQ0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:26:23 -0400
Date: Tue, 8 Apr 2008 11:26:19 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 2 of 9] Core of mmu notifiers
Message-ID: <20080408162619.GP11364@sgi.com>
References: <patchbomb.1207669443@duo.random> <baceb322b45ed4328065.1207669445@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <baceb322b45ed4328065.1207669445@duo.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one does not build on ia64.  I get the following:

[holt@attica mmu_v12_xpmem_v003_v1]$ make compressed
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  CC      mm/mmu_notifier.o
In file included from include/linux/mmu_notifier.h:6,
                 from mm/mmu_notifier.c:12:
include/linux/mm_types.h:200: error: expected specifier-qualifier-list before ‘cpumask_t’
In file included from mm/mmu_notifier.c:12:
include/linux/mmu_notifier.h: In function ‘mm_has_notifiers’:
include/linux/mmu_notifier.h:62: error: ‘struct mm_struct’ has no member named ‘mmu_notifier_list’
include/linux/mmu_notifier.h: In function ‘mmu_notifier_mm_init’:
include/linux/mmu_notifier.h:117: error: ‘struct mm_struct’ has no member named ‘mmu_notifier_list’
In file included from include/asm/pgtable.h:155,
                 from include/linux/mm.h:39,
                 from mm/mmu_notifier.c:14:
include/asm/mmu_context.h: In function ‘get_mmu_context’:
include/asm/mmu_context.h:81: error: ‘struct mm_struct’ has no member named ‘context’
include/asm/mmu_context.h:88: error: ‘struct mm_struct’ has no member named ‘context’
include/asm/mmu_context.h:90: error: ‘struct mm_struct’ has no member named ‘cpu_vm_mask’
include/asm/mmu_context.h:99: error: ‘struct mm_struct’ has no member named ‘context’
include/asm/mmu_context.h: In function ‘init_new_context’:
include/asm/mmu_context.h:120: error: ‘struct mm_struct’ has no member named ‘context’
include/asm/mmu_context.h: In function ‘activate_context’:
include/asm/mmu_context.h:173: error: ‘struct mm_struct’ has no member named ‘cpu_vm_mask’
include/asm/mmu_context.h:174: error: ‘struct mm_struct’ has no member named ‘cpu_vm_mask’
include/asm/mmu_context.h:180: error: ‘struct mm_struct’ has no member named ‘context’
mm/mmu_notifier.c: In function ‘__mmu_notifier_release’:
mm/mmu_notifier.c:25: error: ‘struct mm_struct’ has no member named ‘mmu_notifier_list’
mm/mmu_notifier.c:26: error: ‘struct mm_struct’ has no member named ‘mmu_notifier_list’
mm/mmu_notifier.c: In function ‘__mmu_notifier_clear_flush_young’:
mm/mmu_notifier.c:47: error: ‘struct mm_struct’ has no member named ‘mmu_notifier_list’
mm/mmu_notifier.c: In function ‘__mmu_notifier_invalidate_page’:
mm/mmu_notifier.c:61: error: ‘struct mm_struct’ has no member named ‘mmu_notifier_list’
mm/mmu_notifier.c: In function ‘__mmu_notifier_invalidate_range_start’:
mm/mmu_notifier.c:73: error: ‘struct mm_struct’ has no member named ‘mmu_notifier_list’
mm/mmu_notifier.c: In function ‘__mmu_notifier_invalidate_range_end’:
mm/mmu_notifier.c:85: error: ‘struct mm_struct’ has no member named ‘mmu_notifier_list’
mm/mmu_notifier.c: In function ‘mmu_notifier_register’:
mm/mmu_notifier.c:102: error: ‘struct mm_struct’ has no member named ‘mmu_notifier_list’
make[1]: *** [mm/mmu_notifier.o] Error 1
make: *** [mm] Error 2

