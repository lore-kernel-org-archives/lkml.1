Return-Path: <linux-kernel-owner+w=401wt.eu-S1765712AbXHJAwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765712AbXHJAwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 20:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbXHJAwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 20:52:23 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40124 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbXHJAwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 20:52:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@openvz.org,
       Alexey Dobriyan <adobriyan@sw.ru>
Subject: [PATCH 02/10] sysct mqueue: Remove the binary sysctl numbers
References: <20070726164518.GB16937@localhost.sw.ru>
	<m13azbulhf.fsf@ebiederm.dsl.xmission.com>
	<20070727145235.GC6924@localhost.sw.ru>
	<20070806124530.GD6634@localhost.sw.ru>
	<m1tzr8a3ms.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps1wa3kf.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hcn8a2rq.fsf_-_@ebiederm.dsl.xmission.com>
	<m1d4xw9psl.fsf_-_@ebiederm.dsl.xmission.com>
Date: Thu, 09 Aug 2007 18:51:24 -0600
In-Reply-To: <m1d4xw9psl.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Thu, 09 Aug 2007 18:49:46 -0600")
Message-ID: <m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Because of a conflict with FS_INODE_NR none of the binary
sysctl numbers use by mqueue, were available to user space.
So just remove them.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 ipc/mqueue.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 145d5a0..13fdf67 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -44,12 +44,6 @@
 #define STATE_PENDING	1
 #define STATE_READY	2
 
-/* used by sysctl */
-#define FS_MQUEUE 	1
-#define CTL_QUEUESMAX 	2
-#define CTL_MSGMAX 	3
-#define CTL_MSGSIZEMAX 	4
-
 /* default values */
 #define DFLT_QUEUESMAX	256	/* max number of message queues */
 #define DFLT_MSGMAX 	10	/* max number of messages in each queue */
@@ -1197,7 +1191,6 @@ static int msg_maxsize_limit_max = INT_MAX;
 
 static ctl_table mq_sysctls[] = {
 	{
-		.ctl_name	= CTL_QUEUESMAX,
 		.procname	= "queues_max",
 		.data		= &queues_max,
 		.maxlen		= sizeof(int),
@@ -1205,7 +1198,6 @@ static ctl_table mq_sysctls[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_MSGMAX,
 		.procname	= "msg_max",
 		.data		= &msg_max,
 		.maxlen		= sizeof(int),
@@ -1215,7 +1207,6 @@ static ctl_table mq_sysctls[] = {
 		.extra2		= &msg_max_limit_max,
 	},
 	{
-		.ctl_name	= CTL_MSGSIZEMAX,
 		.procname	= "msgsize_max",
 		.data		= &msgsize_max,
 		.maxlen		= sizeof(int),
@@ -1229,7 +1220,6 @@ static ctl_table mq_sysctls[] = {
 
 static ctl_table mq_sysctl_dir[] = {
 	{
-		.ctl_name	= FS_MQUEUE,
 		.procname	= "mqueue",
 		.mode		= 0555,
 		.child		= mq_sysctls,
-- 
1.5.1.1.181.g2de0

