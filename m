Return-Path: <linux-kernel-owner+w=401wt.eu-S1758118AbYBSUci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118AbYBSUci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYBSUc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:32:28 -0500
Received: from relay2.sgi.com ([192.48.171.30]:50788 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752395AbYBSUc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:32:27 -0500
Message-Id: <20080219203226.746641000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 12:32:26 -0800
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/2] percpu: Optimize percpu accesses v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the generic (non-x86) changes for zero-based per cpu variables.

This patchset provides the following:

  * Init: Move setup of nr_cpu_ids to as early as possible for usage
    by early boot functions.

  * Generic: Percpu infrastructure to rebase the per cpu area to zero

    This provides for the capability of accessing the percpu variables
    using a local register instead of having to go through a table
    on node 0 to find this cpu specific offsets.  It also would allow
    atomic operations on percpu variables to reduce required locking.

  * Introduces a new DEFINE_PER_CPU_FIRST to locate a percpu variable
    (cpu_pda in this case) at the beginning of the percpu .data section.

Based on git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
v3: * split generic/x86-specific into two patches

v2: * rebased and retested using linux-2.6.git
    * fixed errors reported by checkpatch.pl

-- 
