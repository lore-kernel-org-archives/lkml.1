Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbYLDBBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbYLDBBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 20:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758101AbYLDBAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 20:00:31 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:63852 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758030AbYLDBAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 20:00:30 -0500
Date: Thu, 4 Dec 2008 09:00:26 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: akpm@linux-foundation.org
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] ipc: fix warning of not used variable
Message-ID: <20081204010026.GC17445@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix this warning:
ipc/ipc_sysctl.c:39: warning: ‘ipc_auto_callback’ defined but not used
ipc_auto_callback() just called when CONFIG_PROC_FS was defined.


Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 ipc/ipc_sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 0dfebc5..9e42478 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -35,6 +35,7 @@ static void *get_ipc(ctl_table *table)
  *    add/remove or ipc namespace creation/removal.
  * 1: register back the callback routine.
  */
+#ifdef CONFIG_PROC_FS
 static void ipc_auto_callback(int val)
 {
 	if (!val)
@@ -49,7 +50,6 @@ static void ipc_auto_callback(int val)
 	}
 }
 
-#ifdef CONFIG_PROC_FS
 static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-- 
1.5.6.3

-- 
Jianjun Kong | Happy Hacking
HOMEPAGE: http://kongove.cn/
GTALK: kongjianjun@gmail.com
