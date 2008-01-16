Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYAPAJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYAPAJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbYAPAJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:09:11 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:38929 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbYAPAJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:09:10 -0500
Date: Tue, 15 Jan 2008 16:05:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: jlan@sgi.com, balbir@linux.vnet.ibm.com, nagar@watson.ibm.com,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] getdelays: fix gcc warnings
Message-Id: <20080115160506.b1360614.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix gcc warnings in getdelays.c:

Documentation/accounting/getdelays.c: In function 'task_context_switch_counts':
Documentation/accounting/getdelays.c:214: warning: format '%15lu' expects type 'long unsigned int', but argument 4 has type '__u64'
Documentation/accounting/getdelays.c:214: warning: format '%15lu' expects type 'long unsigned int', but argument 5 has type '__u64'
Documentation/accounting/getdelays.c: In function 'main':
Documentation/accounting/getdelays.c:402: warning: format '%d' expects type 'int', but argument 2 has type 'long unsigned int'
Documentation/accounting/getdelays.c: In function 'get_family_id':
Documentation/accounting/getdelays.c:171: warning: 'id' may be used uninitialized in this function

One warning is not a problem and can be dismissed:
Documentation/accounting/getdelays.c: In function 'main':
Documentation/accounting/getdelays.c:236: warning: 'cmd_type' may be used uninitialized in this function

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/accounting/getdelays.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-rc7.orig/Documentation/accounting/getdelays.c
+++ linux-2.6.24-rc7/Documentation/accounting/getdelays.c
@@ -168,7 +168,7 @@ int get_family_id(int sd)
 		char buf[256];
 	} ans;
 
-	int id, rc;
+	int id = 0, rc;
 	struct nlattr *na;
 	int rep_len;
 
@@ -209,7 +209,7 @@ void print_delayacct(struct taskstats *t
 void task_context_switch_counts(struct taskstats *t)
 {
 	printf("\n\nTask   %15s%15s\n"
-	       "       %15lu%15lu\n",
+	       "       %15llu%15llu\n",
 	       "voluntary", "nonvoluntary",
 	       t->nvcsw, t->nivcsw);
 }
@@ -399,7 +399,7 @@ int main(int argc, char *argv[])
 			goto done;
 		}
 
-		PRINTF("nlmsghdr size=%d, nlmsg_len=%d, rep_len=%d\n",
+		PRINTF("nlmsghdr size=%zu, nlmsg_len=%d, rep_len=%d\n",
 		       sizeof(struct nlmsghdr), msg.n.nlmsg_len, rep_len);
 
 
