Return-Path: <linux-kernel-owner+w=401wt.eu-S933180AbZLRW2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180AbZLRW2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbZLRW2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:28:00 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:54460 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbZLRW16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:27:58 -0500
Message-Id: <20091218222617.384355422@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Dec 2009 16:26:17 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V8 00/16] Per cpu atomics in core allocators, cleanup and more this_cpu_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leftovers from the earlier patchset rediffed to 2.6.33-rc1.
Mostly applications of per cpu counters to core components.

After this patchset there will be only one user of local_t left: Mathieu's
trace ringbuffer.

I added some patches that define additional this_cpu ops in order to help
Mathieu with making the trace ringbuffer use this_cpu ops. These have barely
been tested (boots fine on 32 and 64 bit but there is no user of these operations).
RFC state.

V7->V8
- Fix issue in slub patch
- Fix issue in modules patch
- Rediff page allocator patch
- Provide new this_cpu ops needed for ringbuffer [RFC state]

V6->V7
- Drop patches merged in 2.6.33 merge cycle
- Drop risky slub patches

V5->V6:
- Drop patches merged by Tejun.
- Drop irqless slub fastpath for now.
- Patches against Tejun percpu for-next branch.

V4->V5:
- Avoid setup_per_cpu_area() modifications and fold the remainder of the
  patch into the page allocator patch.
- Irq disable / per cpu ptr fixes for page allocator patch.

V3->V4:
- Fix various macro definitions.
- Provide experimental percpu based fastpath that does not disable
  interrupts for SLUB.

V2->V3:
- Available via git tree against latest upstream from
	 git://git.kernel.org/pub/scm/linux/kernel/git/christoph/percpu.git linus
- Rework SLUB per cpu operations. Get rid of dynamic DMA slab creation
  for CONFIG_ZONE_DMA
- Create fallback framework so that 64 bit ops on 32 bit platforms
  can fallback to the use of preempt or interrupt disable. 64 bit
  platforms can use 64 bit atomic per cpu ops.

V1->V2:
- Various minor fixes
- Add SLUB conversion
- Add Page allocator conversion
- Patch against the git tree of today


