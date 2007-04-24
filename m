Return-Path: <linux-kernel-owner+w=401wt.eu-S1422952AbXDXSAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422952AbXDXSAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 14:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422953AbXDXSAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 14:00:35 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:56196 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422952AbXDXSAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 14:00:34 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: akpm@linux-foundation.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, apw@shadowen.org, y-goto@jp.fujitsu.com,
       kamezawa.hiroyu@jp.fujitsu.com
Message-Id: <20070424180032.22005.82088.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 0/2] Fix two boot problems related to ZONE_MOVABLE sizing
Date: Tue, 24 Apr 2007 19:00:32 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following this mail are two fixes related to a boot problem in relation
to ZONE_MOVABLE. These are fixes for memory partitioning where kernelcore=
is used and is unrelated to grouping pages by mobility.

The first patch moves kernelcore= parsing to common code. This avoids an
infinite loop that can occur when booting on IA64. As a side-effect,
it extends support of kernelcore= to all architectures that use
architecture-independent zone-sizing.

The second patch aligns ZONE_MOVABLE correctly. The bootmem allocator makes
assumptions on the alignment of zones. This can cause pages to be placed
on the freelists for the wrong zone resulting in a BUG() later. Aligning
ZONE_MOVABLE avoids the problem.

They have been successfully boot-tested with and without kernelcore=
specified on x86_64, ppc64 and IA64 (where the bug was first triggered).
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
