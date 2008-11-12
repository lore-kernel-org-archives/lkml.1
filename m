Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYKLXVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYKLXVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbYKLXUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:20:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:57286 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604AbYKLXUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:20:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,592,1220252400"; 
   d="scan'208";a="638539043"
Message-Id: <20081112212647.259698000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 13:26:47 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@veritas.com>, Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 0/8] x86 PAT: track pfnmap mappings with remap_pfn_range and vm_insert_pfn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry about the duplicates. Resending as the original mails did not make it to
 the list due to some errors in my email header)

Drivers use mmap followed by pgprot_* and remap_pfn_range or vm_insert_pfn,
in order to export reserved memory to userspace. Currently, such mappings are
not tracked and hence not kept consistent with other mappings (/dev/mem,
pci resource, ioremap) for the sme memory, that may exist in the system.

The following patchset adds x86 PAT attribute tracking and untracking for
pfnmap related APIs.

First four patches in the patchset are changing the generic mm code to fit
in this tracking. Last four patches are x86 specific to make things work
with x86 PAT code. The patchset aso introduces pgprot_writecombine interface,
which gives writecombine mapping when enabled, falling back to
pgprot_noncached otherwise.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

-- 

