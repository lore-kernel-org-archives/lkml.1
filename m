Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753186AbYLRUB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYLRUB5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYLRUBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:01:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:49348 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYLRUBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:01:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,244,1228118400"; 
   d="scan'208";a="372070381"
Message-Id: <20081218194126.963894000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Dec 2008 11:41:26 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
        jeremy@goop.org, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 0/7] x86 PAT: track pfnmap mappings with remap_pfn_range vm_insert_pfn - v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3: Patches updated based on Andrew's comments on the earlier version.

Drivers use mmap followed by pgprot_* and remap_pfn_range or vm_insert_pfn,
in order to export reserved memory to userspace. Currently, such mappings are
not tracked and hence not kept consistent with other mappings (/dev/mem,
pci resource, ioremap) for the sme memory, that may exist in the system.

The following patchset adds x86 PAT attribute tracking and untracking for
pfnmap related APIs.

First three patches in the patchset are changing the generic mm code to fit
in this tracking. Last four patches are x86 specific to make things work
with x86 PAT code. The patchset aso introduces pgprot_writecombine interface,
which gives writecombine mapping when enabled, falling back to
pgprot_noncached otherwise.

-- 

