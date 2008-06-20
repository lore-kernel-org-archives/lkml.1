Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbYFTTWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbYFTTWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYFTTVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:21:53 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4138 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbYFTTVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:21:52 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Nishanth Aravamudan <nacc@us.ibm.com>,
       Adam Litke <agl@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>, Andy Whitcroft <apw@shadowen.org>
Subject: [RFC] hugetlb reservations -- MAP_PRIVATE fixes for split vmas
Date: Fri, 20 Jun 2008 20:17:52 +0100
Message-Id: <1213989474-5586-1-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.205.g7ca3a
In-Reply-To: <485A8903.9030808@linux.vnet.ibm.com>
References: <485A8903.9030808@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Adam Litke and Jon Tollefson one of the libhugetlbfs
regression tests triggers a negative overall reservation count.  When
this occurs where there is no dynamic pool enabled tests will fail.

Following this email are two patches to fix this issue:

hugetlb reservations: move region tracking earlier -- simply moves the
  region tracking code earlier so we do not have to supply prototypes, and

hugetlb reservations: fix hugetlb MAP_PRIVATE reservations across vma
  splits -- which moves us to tracking the consumed reservation so that
  we can correctly calculate the remaining reservations at vma close time.

This stack is against the top of v2.6.25-rc6-mm3, should this solution
prove acceptable it would probabally need porting below Nicks multiple
hugepage size patches and those updated; if so I would be happy to do
that too.

Jon could you have a test on this and see if it works out for you.

-apw
