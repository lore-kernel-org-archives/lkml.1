Return-Path: <linux-kernel-owner+w=401wt.eu-S1764937AbXHJIZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764937AbXHJIZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbXHJIYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:24:54 -0400
Received: from ozlabs.org ([203.10.76.45]:41980 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbXHJIYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:24:52 -0400
From: Michael Neuling <mikey@neuling.org>
To: linux-kernel@vger.kernel.org
cc: akpm@osdl.org, Balbir Singh <balbir@linux.vnet.ibm.com>
X-GPG-Fingerprint: 9B25 DC2A C58D 2C8D 47C2  457E 0887 E86F 32E6 BE16
MIME-Version: 1.0
Subject: [PATCH] Documentation: fix getdelays.c example -l option and segv
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Fri, 10 Aug 2007 18:24:45 +1000
Message-ID: <18240.1186734285@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a couple of minor issues with the getdelays.c example code. 

Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 Documentation/accounting/getdelays.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

Index: linux-2.6-ozlabs/Documentation/accounting/getdelays.c
===================================================================
--- linux-2.6-ozlabs.orig/Documentation/accounting/getdelays.c
+++ linux-2.6-ozlabs/Documentation/accounting/getdelays.c
@@ -196,7 +196,7 @@ void print_delayacct(struct taskstats *t
 	       "IO    %15s%15s\n"
 	       "      %15llu%15llu\n"
 	       "MEM   %15s%15s\n"
-	       "      %15llu%15llu\n"
+	       "      %15llu%15llu\n",
 	       "count", "real total", "virtual total", "delay total",
 	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
 	       t->cpu_delay_total,
@@ -335,17 +335,17 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (tid) {
-		rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
-			      cmd_type, &tid, sizeof(__u32));
-		PRINTF("Sent pid/tgid, retval %d\n", rc);
-		if (rc < 0) {
-			fprintf(stderr, "error sending tid/tgid cmd\n");
-			goto done;
+	do {
+		if (tid) {
+			rc = send_cmd(nl_sd, id, mypid, TASKSTATS_CMD_GET,
+				      cmd_type, &tid, sizeof(__u32));
+			PRINTF("Sent pid/tgid, retval %d\n", rc);
+			if (rc < 0) {
+				fprintf(stderr, "error sending tid/tgid cmd\n");
+				goto done;
+			}
 		}
-	}
 
-	do {
 		int i;
 
 		rep_len = recv(nl_sd, &msg, sizeof(msg), 0);
@@ -430,6 +430,7 @@ int main(int argc, char *argv[])
 			}
 			na = (struct nlattr *) (GENLMSG_DATA(&msg) + len);
 		}
+		sleep(2);
 	} while (loop);
 done:
 	if (maskset) {




