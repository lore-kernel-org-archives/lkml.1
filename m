Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYB1SJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYB1SJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbYB1SJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:09:51 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:18090 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYB1SJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:09:51 -0500
Message-ID: <47C6F8EB.4050507@fr.ibm.com>
Date: Thu, 28 Feb 2008 19:09:47 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] try to fix false positives reports of checkpatch.pl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cedric Le Goater <clg@fr.ibm.com>

This is an humble attempt to fix these reports that seem to be false positives. 
aren't they ? If so, you should triple check the fix because I got lost in the 
'elsif' and I took the first shortcut I found :)

Thanks for maintaining checkpatch.pl. it's a great tool.

C.

ERROR: need consistent spacing around '*' (ctx:WxV)
#139: FILE: ipc/mq_sysctl.c:17:
+static void *get_mq(ctl_table *table)
                               ^

ERROR: need consistent spacing around '*' (ctx:WxV)
#148: FILE: ipc/mq_sysctl.c:26:
+static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
                                       ^

ERROR: need consistent spacing around '*' (ctx:WxV)
#158: FILE: ipc/mq_sysctl.c:36:
+static int proc_mq_dointvec_minmax(ctl_table *table, int write,
                                              ^

ERROR: need consistent spacing around '*' (ctx:WxV)
#169: FILE: ipc/mq_sysctl.c:47:
+static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
                                       ^

ERROR: need consistent spacing around '*' (ctx:WxV)
#175: FILE: ipc/mq_sysctl.c:53:
+static int proc_mq_dointvec_minmax(ctl_table *table, int write,
                                              ^

total: 5 errors, 0 warnings, 216 lines checked

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>

---
 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.25-rc2-mm1/scripts/checkpatch.pl
===================================================================
--- 2.6.25-rc2-mm1.orig/scripts/checkpatch.pl
+++ 2.6.25-rc2-mm1/scripts/checkpatch.pl
@@ -1387,7 +1387,7 @@ sub process {
 					 $op eq '*' or $op eq '/' or
 					 $op eq '%')
 				{
-					if ($ctx !~ /VxV|WxW|VxE|WxE|VxO/) {
+					if ($ctx !~ /VxV|WxW|VxE|WxE|VxO|WxV/) {
 						ERROR("need consistent spacing around '$op' $at\n" .
 							$hereptr);
 					}
