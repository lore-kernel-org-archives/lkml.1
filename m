Return-Path: <linux-kernel-owner+w=401wt.eu-S1764933AbZFLRkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764933AbZFLRkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 13:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbZFLRkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 13:40:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:34251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbZFLRkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 13:40:05 -0400
Date: Fri, 12 Jun 2009 17:39:29 GMT
From: tip-bot for Mike Frysinger <vapier@gentoo.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, vapier@gentoo.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, vapier@gentoo.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1244827063-24046-1-git-send-email-vapier@gentoo.org>
References: <1244827063-24046-1-git-send-email-vapier@gentoo.org>
Subject: [tip:perfcounters/core] perf_counter: Start documenting HAVE_PERF_COUNTERS requirements
Message-ID: <tip-018df72dd01576ab199c6129233cdeaf1409958b@git.kernel.org>
Git-Commit-ID: 018df72dd01576ab199c6129233cdeaf1409958b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 12 Jun 2009 17:39:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  018df72dd01576ab199c6129233cdeaf1409958b
Gitweb:     http://git.kernel.org/tip/018df72dd01576ab199c6129233cdeaf1409958b
Author:     Mike Frysinger <vapier@gentoo.org>
AuthorDate: Fri, 12 Jun 2009 13:17:43 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 12 Jun 2009 19:37:30 +0200

perf_counter: Start documenting HAVE_PERF_COUNTERS requirements

Help out arch porters who want to support perf counters by listing some
basic requirements.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1244827063-24046-1-git-send-email-vapier@gentoo.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 init/Kconfig          |    2 ++
 tools/perf/design.txt |   15 +++++++++++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index c649657..d3a5096 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -936,6 +936,8 @@ config AIO
 
 config HAVE_PERF_COUNTERS
 	bool
+	help
+	  See tools/perf/design.txt for details.
 
 menu "Performance Counters"
 
diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index 860e116..f71e0d2 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -440,3 +440,18 @@ by this process or by another, and doesn't affect any counters that
 this process has created on other processes.  It only enables or
 disables the group leaders, not any other members in the groups.
 
+
+Arch requirements
+-----------------
+
+If your architecture does not have hardware performance metrics, you can
+still use the generic software counters based on hrtimers for sampling.
+
+So to start with, in order to add HAVE_PERF_COUNTERS to your Kconfig, you
+will need at least this:
+	- asm/perf_counter.h - a basic stub will suffice at first
+	- support for atomic64 types (and associated helper functions)
+	- set_perf_counter_pending() implemented
+
+If your architecture does have hardware capabilities, you can override the
+weak stub hw_perf_counter_init() to register hardware counters.
