Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbXGUSyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbXGUSyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 14:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbXGUSyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 14:54:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45934 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbXGUSyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 14:54:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Latchesar Ionkov <lucho@ionkov.net>, <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] 9p: Don't use binary sysctl numbers.
Date: Sat, 21 Jul 2007 12:53:19 -0600
Message-ID: <m1y7h9wpuo.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The recent 9p commit: bd238fb431f31989898423c8b6496bc8c4204a86
that supposedly only moved files also introduced a new 9p sysctl
interface that did not properly register it's sysctl binary numbers,
and since it was only for debugging clearly did not need a binary fast
path in any case.  So this patch just remove the binary numbers.

See Documentation/sysctl/ctl_unnumbered.txt for more details.

While I was at it I cleaned up the sysctl initializers a little as
well so there is less to read.

Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 net/9p/sysctl.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/net/9p/sysctl.c b/net/9p/sysctl.c
index e7fe706..8b61027 100644
--- a/net/9p/sysctl.c
+++ b/net/9p/sysctl.c
@@ -28,15 +28,10 @@
 #include <linux/init.h>
 #include <net/9p/9p.h>
 
-enum {
-	P9_SYSCTL_NET = 487,
-	P9_SYSCTL_DEBUG = 1,
-};
-
-static ctl_table p9_table[] = {
+static struct ctl_table p9_table[] = {
 #ifdef CONFIG_NET_9P_DEBUG
 	{
-		.ctl_name       = P9_SYSCTL_DEBUG,
+		.ctl_name       = CTL_UNNUMBERED,
 		.procname       = "debug",
 		.data           = &p9_debug_level,
 		.maxlen         = sizeof(int),
@@ -44,21 +39,21 @@ static ctl_table p9_table[] = {
 		.proc_handler   = &proc_dointvec
 	},
 #endif
-	{	.ctl_name	= 0 },
+	{},
 };
 
-static ctl_table p9_net_table[] = {
+static struct ctl_table p9_net_table[] = {
 	{
-		.ctl_name	= P9_SYSCTL_NET,
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "9p",
 		.maxlen		= 0,
 		.mode		= 0555,
 		.child		= p9_table,
 	},
-	{	.ctl_name	= 0 },
+	{},
 };
 
-static ctl_table p9_ctl_table[] = {
+static struct ctl_table p9_ctl_table[] = {
 	{
 		.ctl_name	= CTL_NET,
 		.procname	= "net",
@@ -66,7 +61,7 @@ static ctl_table p9_ctl_table[] = {
 		.mode		= 0555,
 		.child		= p9_net_table,
 	},
-	{	.ctl_name	= 0 },
+	{},
 };
 
 static struct ctl_table_header *p9_table_header;
-- 
1.5.1.1.181.g2de0

