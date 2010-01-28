Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808Ab0A1Gyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0A1Gyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 01:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059Ab0A1Gyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 01:54:44 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:48199 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0A1Gyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 01:54:43 -0500
X-IronPort-AV: E=Sophos;i="4.49,359,1262581200"; 
   d="scan'208";a="10806432"
From: Yi Li <yi.li@analog.com>
To: jkacur@redhat.com
CC: williams@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Yi Li <yi.li@analog.com>
Subject: [PATCH] cyclictest: set "tracing_thresh" optionally (resend)
Date: Thu, 28 Jan 2010 14:50:59 +0800
Message-ID: <1264661459-16850-1-git-send-email-yi.li@analog.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 28 Jan 2010 06:51:05.0810 (UTC) FILETIME=[438D2B20:01CA9FE6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an option "--tracing_thresh=THRESH" to set "tracing_thresh" of
current tracer, so it is not set to "tracelimit" by default.

Signed-off-by: Yi Li <yi.li@analog.com>
---
 src/cyclictest/cyclictest.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/src/cyclictest/cyclictest.c b/src/cyclictest/cyclictest.c
index dc86b49..1d32ec4 100644
--- a/src/cyclictest/cyclictest.c
+++ b/src/cyclictest/cyclictest.c
@@ -146,6 +146,7 @@ struct thread_stat {
 
 static int shutdown;
 static int tracelimit = 0;
+static int tracing_thresh = 0;
 static int ftrace = 0;
 static int kernelversion;
 static int verbose = 0;
@@ -387,8 +388,10 @@ static void setup_tracer(void)
 		char buffer[32];
 		int ret;
 
-		sprintf(buffer, "%d", tracelimit);
-		setkernvar("tracing_thresh", buffer);
+		if (tracing_thresh >= 0 && tracing_thresh <= tracelimit) {
+			sprintf(buffer, "%d", tracing_thresh);
+			setkernvar("tracing_thresh", buffer);
+		}
 
 		/* ftrace_enabled is a sysctl variable */
 		fileprefix = procfileprefix;
@@ -770,6 +773,7 @@ static void display_help(int error)
 	       "                           without -t default = 1\n"
 	       "-T TRACE --tracer=TRACER   set tracing function\n"
 	       "    configured tracers: %s\n"
+	       "--tracing_thresh=THRESH    set tracing_thresh of current tracer to THRESH\n"
 	       "-u       --unbuffered      force unbuffered output for live processing\n"
 	       "-v       --verbose         output values on stdout for statistics\n"
 	       "                           format: n:c:v n=tasknum c=count v=value in us\n"
@@ -903,6 +907,7 @@ static void process_options (int argc, char *argv[])
 			{"help", no_argument, NULL, '?'},
 			{"tracer", required_argument, NULL, 'T'},
 			{"traceopt", required_argument, NULL, 'O'},
+			{"tracing_thresh", required_argument, NULL, 1},
 			{"smp", no_argument, NULL, 'S'},
 			{"numa", no_argument, NULL, 'U'},
 			{NULL, 0, NULL, 0}
@@ -995,6 +1000,7 @@ static void process_options (int argc, char *argv[])
 #endif
 			break;
 		case '?': display_help(0); break;
+		case 1: tracing_thresh = atoi(optarg); break;
 		}
 	}
 
-- 
1.6.0.4

