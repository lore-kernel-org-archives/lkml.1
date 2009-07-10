Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZGJNAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZGJNAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 09:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZGJNAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 09:00:06 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:53339 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZGJNAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 09:00:03 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 10 Jul 2009 18:29:50 +0530
Message-Id: <20090710125950.5610.99139.sendpatchset@balbir-laptop>
Subject: [RFC][PATCH 0/5] Memory controller soft limit patches (v9)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Balbir Singh <balbir@linux.vnet.ibm.com>

New Feature: Soft limits for memory resource controller.

Here is v9 of the new soft limit implementation. Soft limits is a new feature
for the memory resource controller, something similar has existed in the
group scheduler in the form of shares. The CPU controllers interpretation
of shares is very different though. 

Soft limits are the most useful feature to have for environments where
the administrator wants to overcommit the system, such that only on memory
contention do the limits become active. The current soft limits implementation
provides a soft_limit_in_bytes interface for the memory controller and not
for memory+swap controller. The implementation maintains an RB-Tree of groups
that exceed their soft limit and starts reclaiming from the group that
exceeds this limit by the maximum amount.

v9 attempts to address several review comments for v8 by Kamezawa, including
moving over to an event based approach for soft limit rb tree management,
simplification of data structure names and many others. Comments not
addressed have been answered via email or I've added comments in the code.

TODOs

1. The current implementation maintains the delta from the soft limit
   and pushes back groups to their soft limits, a ratio of delta/soft_limit
   might be more useful

Tests
-----

I've run two memory intensive workloads with differing soft limits and
seen that they are pushed back to their soft limit on contention. Their usage
was their soft limit plus additional memory that they were able to grab
on the system. Soft limit can take a while before we see the expected
results.

I ran overhead tests (reaim) and found no significant overhead as a result
of these patches.

Please review, comment.

Series
------

memcg-soft-limits-documentation.patch
memcg-soft-limits-interface.patch
memcg-soft-limits-organize.patch
memcg-soft-limits-refactor-reclaim-bits
memcg-soft-limits-reclaim-on-contention.patch


-- 
	Balbir
