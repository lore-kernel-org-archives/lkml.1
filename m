Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbZLNWGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbZLNWGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758593AbZLNWE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:04:57 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:59452 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758537AbZLNWEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:04:52 -0500
Message-Id: <20091214220320.665065925@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 14 Dec 2009 16:03:20 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leftovers from the earlier patchset. Mostly applications of per cpu counters
to core components.

After this patchset there will be only one user of local_t left: Mathieu's
trace ringbuffer. Does it really need these ops?

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


