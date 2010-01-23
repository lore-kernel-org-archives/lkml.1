Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446Ab0AWEnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0AWEnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 23:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612Ab0AWEnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 23:43:51 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:47647 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0AWEnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 23:43:50 -0500
From: Himanshu Chauhan <himanshu@symmetricore.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: greg@kroah.com, Himanshu Chauhan <himanshu@symmetricore.com>
Subject: [PATCH] usbip cleanup: Changed current->comm to get_task_comm
Date: Sat, 23 Jan 2010 10:10:41 +0530
Message-Id: <1264221641-26193-1-git-send-email-himanshu@symmetricore.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Himanshu Chauhan <himanshu@symmetricore.com>
---
 drivers/staging/usbip/usbip_common.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 3367a52..30fdf9d 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -443,6 +443,7 @@ int usbip_xmit(int send, struct socket *sock, char *buf,
 	struct msghdr msg;
 	struct kvec iov;
 	int total = 0;
+	char name[sizeof(current->comm)];
 
 	/* for blocks of if (usbip_dbg_flag_xmit) */
 	char *bp = buf;
@@ -456,11 +457,12 @@ int usbip_xmit(int send, struct socket *sock, char *buf,
 		return -EINVAL;
 	}
 
+	get_task_comm(name, current);
 
 	if (usbip_dbg_flag_xmit) {
 		if (send) {
 			if (!in_interrupt())
-				printk(KERN_DEBUG "%-10s:", current->comm);
+				printk(KERN_DEBUG "%-10s:", name);
 			else
 				printk(KERN_DEBUG "interrupt  :");
 
@@ -507,7 +509,7 @@ int usbip_xmit(int send, struct socket *sock, char *buf,
 	if (usbip_dbg_flag_xmit) {
 		if (!send) {
 			if (!in_interrupt())
-				printk(KERN_DEBUG "%-10s:", current->comm);
+				printk(KERN_DEBUG "%-10s:", name);
 			else
 				printk(KERN_DEBUG "interrupt  :");
 
-- 
1.6.3.3

