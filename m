Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbZGCA2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbZGCA2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757073AbZGCA1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:27:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:1797 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbZGCA1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:27:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,337,1243839600"; 
   d="scan'208";a="161121939"
Message-Id: <20090703000923.959178000@intel.com>
References: <20090703000829.735976000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Jul 2009 17:08:31 -0700
From: venkatesh.pallipadi@intel.com
To: "Dave Jones" <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       kernel-testers@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Dave Young" <hidave.darkstar@gmail.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Thomas Renninger" <trenn@suse.de>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
Subject: [patch 2/4] cpufreq: Mark policy_rwsem as going static in cpufreq.c wont be exported
Content-Disposition: inline; filename=0002-cpufreq-Mark-policy_rwsem-as-going-static-in-cpufre.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lock_policy_rwsem_* and unlock_policy_rwsem_* routines in cpufreq.c are
currently exported to drivers. Improper use of those locks can
result in deadlocks and it is better to keep the locks localized.
Two previous in-kernel users of these interfaces (ondemand and conservative),
do not use this interfaces any more. Schedule them for removal. 

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index f8cd450..09e031c 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -458,3 +458,13 @@ Why:	Remove the old legacy 32bit machine check code. This has been
 	but the old version has been kept around for easier testing. Note this
 	doesn't impact the old P5 and WinChip machine check handlers.
 Who:	Andi Kleen <andi@firstfloor.org>
+
+----------------------------
+
+What:	lock_policy_rwsem_* and unlock_policy_rwsem_* will not be
+	exported interface anymore.
+When:	2.6.33
+Why:	cpu_policy_rwsem has a new cleaner definition making it local to
+	cpufreq core and contained inside cpufreq.c. Other dependent
+	drivers should not use it in order to safely avoid lockdep issues.
+Who:	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
-- 
1.6.0.6

-- 

