Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbYAJTO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbYAJTO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYAJTOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:14:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:2081 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbYAJTOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:14:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="363696677"
Message-Id: <20080110184840.927409000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jan 2008 10:48:40 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: [patch 00/11] PAT x86: PAT support for x86
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is heavily derived from the PAT patchset by Eric Biederman and
Andi Kleen.
http://www.firstfloor.org/pub/ak/x86_64/pat/

This patchset is a followup of "PAT support for X86_64"
http://www.ussg.iu.edu/hypermail/linux/kernel/0712.1/2268.html

Things changed from the above (Dec 13 2007) version:
* PAT mappings now used are - (0,WB) (1,WT) (2,WC) (3,UC).
* Covers both i386 and x86_64.
* Resolve the /sysfs issue by exporting wc and uc interfaces.
* Piggyback PAT initialization on existing MTRR initialization as they
  have same setup rules.
* Avoid early table allocation problem for x86_64 by doing the reserved
  region pruning later in the boot. Handle both memory identity mapping and
  kernel test mapping.
* Handle fork() and /dev/mem mapping and unmapping cases.

Patchset is against Ingo's x86 branch from 2 days ago. Will need some merging
effort with Andi's CPA changes and few other changes like pgtable.h unification.

Not mapping reserved region in identity map is a sort of big change that can
potentially have side-effects on drivers (especially on x86_64), that
assume entire address range is mapped in identity map and use __va to
access reserved regions instead of ioremap/early_ioremap. We have
changed few such common cases, but there can be more in /drivers land.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

-- 
