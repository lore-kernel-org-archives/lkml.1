Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbZCAGa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbZCAGa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 01:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbZCAGaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 01:30:14 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:33509 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZCAGaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 01:30:12 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Sun, 01 Mar 2009 11:59:59 +0530
Message-Id: <20090301062959.31557.31079.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/4] Memory controller soft limit patches (v3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Balbir Singh <balbir@linux.vnet.ibm.com>

Changelog v3...v2
1. Implemented several review comments from Kosaki-San and Kamezawa-San
   Please see individual changelogs for changes

Changelog v2...v1
1. Soft limits now support hierarchies
2. Use spinlocks instead of mutexes for synchronization of the RB tree

Here is v3 of the new soft limit implementation. Soft limits is a new feature
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

If there are no major objections to the patches, I would like to get them
included in -mm.

TODOs

1. The current implementation maintains the delta from the soft limit
   and pushes back groups to their soft limits, a ratio of delta/soft_limit
   might be more useful
2. It would be nice to have more targetted reclaim (in terms of pages to
   recalim) interface. So that groups are pushed back, close to their soft
   limits.

Tests
-----

I've run two memory intensive workloads with differing soft limits and
seen that they are pushed back to their soft limit on contention. Their usage
was their soft limit plus additional memory that they were able to grab
on the system. Soft limit can take a while before we see the expected
results.

Please review, comment.

Series
------

memcg-soft-limit-documentation.patch
memcg-add-soft-limit-interface.patch
memcg-organize-over-soft-limit-groups.patch
memcg-soft-limit-reclaim-on-contention.patch



-- 
	Balbir
