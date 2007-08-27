Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbXH0UVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbXH0UVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbXH0UVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:21:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37871 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754491AbXH0UVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:21:36 -0400
Date: Mon, 27 Aug 2007 15:21:33 -0500
From: Cliff Wickman <cpw@sgi.com>
To: akpm@linux-foundation.org, ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       oleg@tv-sign.ru, pj@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] hotplug cpu: documentation addition to downing a cpu
Message-ID: <20070827202133.GA4728@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In answer to Andrew:
> How do we communicate this new design/feature to our users?
> Documentation/cpusets.txt, perhaps?  Documentation/cpu-hotplug.txt?
> git-log?  ;)

Patch "[PATCH 1/1] V4: hotplug cpu: migrate a task within its cpuset" may
warrant an addition to the documentation.  I would propose this note
in cpu-hotplug.txt.

Diffed against 2.6.23-rc3

Signed-off-by: Cliff Wickman <cpw@sgi.com>

---
 Documentation/cpu-hotplug.txt |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linus.070821/Documentation/cpu-hotplug.txt
===================================================================
--- linus.070821.orig/Documentation/cpu-hotplug.txt
+++ linus.070821/Documentation/cpu-hotplug.txt
@@ -220,7 +220,9 @@ A: The following happen, listed in no pa
   CPU_DOWN_PREPARE or CPU_DOWN_PREPARE_FROZEN, depending on whether or not the
   CPU is being offlined while tasks are frozen due to a suspend operation in
   progress
-- All process is migrated away from this outgoing CPU to a new CPU
+- All processes are migrated away from this outgoing CPU to new CPUs.
+  The new CPU is chosen from each process' current cpuset, which may be
+  a subset of all online CPUs.
 - All interrupts targeted to this CPU is migrated to a new CPU
 - timers/bottom half/task lets are also migrated to a new CPU
 - Once all services are migrated, kernel calls an arch specific routine
-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
