Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbYKHJK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbYKHJK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 04:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbYKHJKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 04:10:32 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:37977 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYKHJKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 04:10:24 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: linux-mm@kvack.org
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Sat, 08 Nov 2008 14:40:09 +0530
Message-Id: <20081108091009.32236.26177.sendpatchset@localhost.localdomain>
Subject: [RFC][mm][PATCH 0/4] Memory cgroup hierarchy introduction (v2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch follows several iterations of the memory controller hierarchy
patches. The hardwall approach by Kamezawa-San[1]. Version 1 of this patchset
at [2].

The current approach is based on [2] and has the following properties

1. Hierarchies are very natural in a filesystem like the cgroup filesystem.
   A multi-tree hierarchy has been supported for a long time in filesystems.
   When the feature is turned on, we honor hierarchies such that the root
   accounts for resource usage of all children and limits can be set at
   any point in the hierarchy. Any memory cgroup is limited by limits
   along the hierarchy. The total usage of all children of a node cannot
   exceed the limit of the node.
2. The hierarchy feature is selectable and off by default
3. Hierarchies are expensive and the trade off is depth versus performance.
   Hierarchies can also be completely turned off.

The patches are against 2.6.28-rc2-mm1 and were tested in a KVM instance
with SMP and swap turned on.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

v2..v1
======
1. The hierarchy is now selectable per-subtree
2. The features file has been renamed to use_hierarchy
3. Reclaim now holds cgroup lock and the reclaim does recursive walk and reclaim

Series
------

memcg-hierarchy-documentation.patch
resource-counters-hierarchy-support.patch
memcg-hierarchical-reclaim.patch
memcg-add-hierarchy-selector.patch

Reviews? Comments?

References

1. http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-06/msg05417.html
2. http://kerneltrap.org/mailarchive/linux-kernel/2008/4/19/1513644/thread

-- 
	Balbir
