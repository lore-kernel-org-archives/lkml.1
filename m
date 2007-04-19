Return-Path: <linux-kernel-owner+w=401wt.eu-S1161473AbXDSJ1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161473AbXDSJ1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161474AbXDSJ1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:27:45 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:63266 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161473AbXDSJ1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:27:45 -0400
From: Balbir Singh <balbir@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jlan@sgi.com,
       Balbir Singh <balbir@in.ibm.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Date: Thu, 19 Apr 2007 14:56:36 +0530
Message-Id: <20070419092636.24538.20798.sendpatchset@balbir-laptop>
Subject: [PATCH -mm] Taskstats fix getdelays usage information
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Add usage to getdelays.c. This patch was originally posted by Randy Dunlap
http://lkml.org/lkml/2007/3/19/168

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: <balbir@in.ibm.com>
---

 Documentation/accounting/getdelays.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN Documentation/accounting/getdelays.c~fix-getdelays-usage Documentation/accounting/getdelays.c
--- linux-2.6.20/Documentation/accounting/getdelays.c~fix-getdelays-usage	2007-04-19 14:41:45.000000000 +0530
+++ linux-2.6.20-balbir/Documentation/accounting/getdelays.c	2007-04-19 14:42:26.000000000 +0530
@@ -72,6 +72,16 @@ struct msgtemplate {
 
 char cpumask[100+6*MAX_CPUS];
 
+static void usage(void)
+{
+	fprintf(stderr, "getdelays [-dilv] [-w logfile] [-r bufsize] "
+			"[-m cpumask] [-t tgid] [-p pid]\n");
+	fprintf(stderr, "  -d: print delayacct stats\n");
+	fprintf(stderr, "  -i: print IO accounting (works only with -p)\n");
+	fprintf(stderr, "  -l: listen forever\n");
+	fprintf(stderr, "  -v: debug on\n");
+}
+
 /*
  * Create a raw netlink socket and bind
  */
@@ -227,7 +237,7 @@ int main(int argc, char *argv[])
 	struct msgtemplate msg;
 
 	while (1) {
-		c = getopt(argc, argv, "diw:r:m:t:p:v:l");
+		c = getopt(argc, argv, "diw:r:m:t:p:vl");
 		if (c < 0)
 			break;
 
@@ -277,7 +287,7 @@ int main(int argc, char *argv[])
 			loop = 1;
 			break;
 		default:
-			printf("Unknown option %d\n", c);
+			usage();
 			exit(-1);
 		}
 	}
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
