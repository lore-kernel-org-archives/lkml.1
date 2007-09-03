Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbXICUWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbXICUWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 16:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbXICUW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 16:22:26 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:5954 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbXICUWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 16:22:25 -0400
Message-ID: <46DC6CFE.7020401@fr.ibm.com>
Date: Mon, 03 Sep 2007 22:22:22 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH -mm] ipc namespace: remove config ipc ns fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Finish the work : kill all #ifdef CONFIG_IPC_NS.

Thanks Robert !

C.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biederman <ebiederm@xmision.com>
Cc: Robert P. J. Day <rpjday@mindspring.com>
---
 ipc/ipc_sysctl.c |    4 ----
 1 file changed, 4 deletions(-)

Index: 2.6.23-rc4-mm1/ipc/ipc_sysctl.c
===================================================================
--- 2.6.23-rc4-mm1.orig/ipc/ipc_sysctl.c
+++ 2.6.23-rc4-mm1/ipc/ipc_sysctl.c
@@ -15,7 +15,6 @@
 #include <linux/sysctl.h>
 #include <linux/uaccess.h>
 
-#ifdef CONFIG_IPC_NS
 static void *get_ipc(ctl_table *table)
 {
 	char *which = table->data;
@@ -23,9 +22,6 @@ static void *get_ipc(ctl_table *table)
 	which = (which - (char *)&init_ipc_ns) + (char *)ipc_ns;
 	return which;
 }
-#else
-#define get_ipc(T) ((T)->data)
-#endif
 
 #ifdef CONFIG_PROC_FS
 static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
