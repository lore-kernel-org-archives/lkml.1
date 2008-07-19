Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbYGSA1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbYGSA1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 20:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYGSA11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 20:27:27 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22362 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYGSA10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 20:27:26 -0400
Date: Fri, 18 Jul 2008 17:26:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] sysctl: fix build when SYSCTL=y, SYSCTL_SYSCALL=n
Message-Id: <20080718172630.a0b385e9.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

The stub needs to be provided when CONFIG_SYSCTL=n, not when
CONFIG_SYSCTL_SYSCALL=n.

linux-next-20080718/kernel/sysctl.c:2970: error: redefinition of 'setup_sysctl_set'
linux-next-20080718/kernel/sysctl.c:1963: error: previous definition of 'setup_sysctl_set' was here

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/sysctl.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-next-20080718.orig/kernel/sysctl.c
+++ linux-next-20080718/kernel/sysctl.c
@@ -1982,6 +1982,12 @@ void unregister_sysctl_table(struct ctl_
 {
 }
 
+void setup_sysctl_set(struct ctl_table_set *p,
+	struct ctl_table_set *parent,
+	int (*is_seen)(struct ctl_table_set *))
+{
+}
+
 #endif /* CONFIG_SYSCTL */
 
 /*
@@ -2964,12 +2970,6 @@ int sysctl_ms_jiffies(struct ctl_table *
 	return -ENOSYS;
 }
 
-void setup_sysctl_set(struct ctl_table_set *p,
-	struct ctl_table_set *parent,
-	int (*is_seen)(struct ctl_table_set *))
-{
-}
-
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
 static int deprecated_sysctl_warning(struct __sysctl_args *args)


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
