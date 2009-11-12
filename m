Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZKLRV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZKLRV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 12:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbZKLRVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 12:21:24 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44461 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753795AbZKLRVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 12:21:23 -0500
Message-Id: <20091112172111.784787000@alcatraz.americas.sgi.com>
References: <20091112171934.584037000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 12 Nov 2009 11:19:40 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yhlu.kernel@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] sched: Limit the number of scheduler debug messages
Content-Disposition: inline; filename=limit_sched_debug_messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit number of sched debug messages for MAXSMP systems.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 lib/Kconfig.debug |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux.orig/lib/Kconfig.debug
+++ linux/lib/Kconfig.debug
@@ -235,11 +235,12 @@
 config SCHED_DEBUG
 	bool "Collect scheduler debugging info"
 	depends on DEBUG_KERNEL && PROC_FS
-	default y
+	default !MAXSMP
 	help
 	  If you say Y here, the /proc/sched_debug file will be provided
 	  that can help debug the scheduler. The runtime overhead of this
-	  option is minimal.
+	  option is minimal unless there are a large number of CPUs in
+	  the system.
 
 config SCHEDSTATS
 	bool "Collect scheduler statistics"

-- 
