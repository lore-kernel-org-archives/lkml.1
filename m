Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbXJ2RvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbXJ2RvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbXJ2RvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:51:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbXJ2RvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:51:16 -0400
Date: Mon, 29 Oct 2007 13:50:14 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Martin Ebourne <fedora@ebourne.me.uk>, Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: 2.6.23 boot failures on x86-64.
Message-ID: <20071029175014.GH7793@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Martin Ebourne <fedora@ebourne.me.uk>,
	Zou Nan hai <nanhai.zou@intel.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>, Andi Kleen <ak@suse.de>,
	stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We've had a number of people reporting that their x86-64s stopped booting
when they moved to 2.6.23.  It rebooted just after discovering the AGP bridge
as a result of the IOMMU init.

Martin tracked this down to the following commit.


commit 2e1c49db4c640b35df13889b86b9d62215ade4b6
Author: Zou Nan hai <nanhai.zou@intel.com>
Date:   Fri Jun 1 00:46:28 2007 -0700

    x86_64: allocate sparsemem memmap above 4G
    
    On systems with huge amount of physical memory, VFS cache and memory memmap
    may eat all available system memory under 4G, then the system may fail to
    allocate swiotlb bounce buffer.
    
    There was a fix for this issue in arch/x86_64/mm/numa.c, but that fix dose
    not cover sparsemem model.
    
    This patch add fix to sparsemem model by first try to allocate memmap above
    4G.
    
    Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
    Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Cc: Andi Kleen <ak@suse.de>
    Cc: <stable@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


This should be probably be reverted for 2.6.23-stable, and either fixed
properly in .24, or reverted there too.

More info at https://bugzilla.redhat.com/show_bug.cgi?id=249174

	Dave

-- 
http://www.codemonkey.org.uk
