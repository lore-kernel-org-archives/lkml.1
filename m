Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab0BJVeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 16:34:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:47188 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab0BJVeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 16:34:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,446,1262592000"; 
   d="scan'208";a="242711600"
Message-Id: <20100210195704.434039000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 10 Feb 2010 11:57:04 -0800
From: venkatesh.pallipadi@intel.com
To: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Wolfram Strepp <wstrepp@gmx.de>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: [patch 0/3] x86: Use interval tree to keep track of PAT reserve/free
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reserve and free ranges of IO region has to be kept track of in x86 PAT, as
the same region should not be mapped with conflicting types by multiple users.
These reserve and free requests can be of varying sizes and can overlap in
various ways. As in
uncached-minus @ 0xfbf00000-0xfbf04000
uncached-minus @ 0xfbf02000-0xfbf03000
or
uncached-minus @ 0xfbf00000-0xfbf04000
uncached-minus @ 0xfbf03000-0xfbf05000
etc.
depending on driver usage model.

And PAT code has to have efficient conflict lookup (while adding a new
region), exact region lookup (to free currently reserved region) and type
lookup (to lookup the memtype of any particular address).

Currently this is done by using a linked-list and rbtree hybrid model,
where linked list is sorted in increasing start address of these ranges.

But, the optimal way to deal with this is to use interval tree
(augmented rbtree). The patchset adds support for augmented rbtree in
generic rbtree code and uses that in x86 PAT, there by
cleaning up and simplifying the current PAT reserve-free backend.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

-- 

