Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbYCSTmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbYCSTmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755284AbYCSTaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:30:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:25828 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269AbYCSTaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="220204536"
Message-Id: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:12 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 00/13] x86: PAT support updated - v3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Follow up on earlier PAT patch series here:
http://lkml.org/lkml/2008/1/10/312

This patch series adds Page Attribute Table (PAT) support on x86. There have
been few changes based on comments for earlier patches and also issues that
was seen while the earlier patchset was in mm. The main changes include:

* Unlike earlier patchset, there are no changes to identity mapping of
  reserved regions.
* Unlike earlier patches, there are no chanegs to early ioremap.
* We look at MTRR setting and PAT request and track the resultant type
  to avoid aliasing.
* UC_MINUS in PAT to provide backward compatibility to /dem/mem mmap users.

In general, we have tried to make patches more simpler and cleaner. Hope is
to cause less disruption along the way. The changes/cleaups that went into
x86/mm (specifically pageattr.c) has helped us along the way.

The patchset is against x86 testing from couple of days back.

The last patch in the series is meant for test-tree only and adds some useful
printks that can help us debug any potential issues.

There are two issues that we are leaving out at the moment to make the patch
simple. We will be addressing them with incremental patches soon:
* FB/DRM drivers using pgprot_val and changing protection on their own
  without using any proper APIs like ioremap. There are few such usages and
  each one will be addressed separately.
* To change attributes from WC to WB in a "perfect way", one has to follow
  certain sequence like make page non-present etc.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

-- 
