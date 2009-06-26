Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbZFZPYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbZFZPYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbZFZPYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:24:19 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33074 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbZFZPYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:24:18 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Sanchin Sant <sanchinp@in.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] integrity: ima mq_open imbalance msg fix
Date: Fri, 26 Jun 2009 11:24:05 -0400
Message-Id: <1246029845-6810-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an imbalance message as reported by Sanchin Sant.
As we don't need to measure the message queue, just increment the
counters.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 ipc/mqueue.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index e35ba2c..c5e68ad 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -32,6 +32,7 @@
 #include <linux/nsproxy.h>
 #include <linux/pid.h>
 #include <linux/ipc_namespace.h>
+#include <linux/ima.h>
 
 #include <net/sock.h>
 #include "util.h"
@@ -733,6 +734,7 @@ SYSCALL_DEFINE4(mq_open, const char __user *, u_name, int, oflag, mode_t, mode,
 		error = PTR_ERR(filp);
 		goto out_putfd;
 	}
+	ima_counts_get(filp);
 
 	fd_install(fd, filp);
 	goto out_upsem;
-- 
1.6.0.6

