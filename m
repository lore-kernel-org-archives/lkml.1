Return-Path: <linux-kernel-owner+w=401wt.eu-S1946632AbXBIQiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946632AbXBIQiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946633AbXBIQiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:38:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51656 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946632AbXBIQiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:38:01 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] hidp __user annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYl6-0006jq-KK@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:38:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/bluetooth/hidp/hidp.h |    2 +-
 net/bluetooth/hidp/sock.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hidp/hidp.h b/net/bluetooth/hidp/hidp.h
index c2775f5..c8dfacd 100644
--- a/net/bluetooth/hidp/hidp.h
+++ b/net/bluetooth/hidp/hidp.h
@@ -86,7 +86,7 @@ struct hidp_connadd_req {
 	int   intr_sock;	// Connteted interrupt socket
 	__u16 parser;
 	__u16 rd_size;
-	__u8 *rd_data;
+	__u8 __user *rd_data;
 	__u8  country;
 	__u8  subclass;
 	__u16 vendor;
diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index 407fba4..93cf9e5 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -189,7 +189,7 @@ static int hidp_sock_compat_ioctl(struct socket *sock, unsigned int cmd, unsigne
 
 		uca = compat_alloc_user_space(sizeof(*uca));
 
-		if (copy_from_user(&ca, (void *) arg, sizeof(ca)))
+		if (copy_from_user(&ca, (void __user *) arg, sizeof(ca)))
 			return -EFAULT;
 
 		if (put_user(ca.ctrl_sock, &uca->ctrl_sock) ||
-- 
1.5.0-rc2.GIT


