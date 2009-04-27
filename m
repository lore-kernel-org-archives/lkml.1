Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbZD0Sd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbZD0Sd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758497AbZD0Sdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:33:45 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54882 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099AbZD0Sdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:33:44 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v3 1/2] eventfd: export fget and signal interfaces for
	module use
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org
Date: Mon, 27 Apr 2009 14:33:29 -0400
Message-ID: <20090427183329.6646.15703.stgit@dev.haskins.net>
In-Reply-To: <20090427182540.6646.96740.stgit@dev.haskins.net>
References: <20090427182540.6646.96740.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will use this later in the series

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 fs/eventfd.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 2a701d5..faf9e60 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -16,6 +16,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/eventfd.h>
 #include <linux/syscalls.h>
+#include <linux/module.h>
 
 struct eventfd_ctx {
 	wait_queue_head_t wqh;
@@ -56,6 +57,7 @@ int eventfd_signal(struct file *file, int n)
 
 	return n;
 }
+EXPORT_SYMBOL_GPL(eventfd_signal);
 
 static int eventfd_release(struct inode *inode, struct file *file)
 {
@@ -197,6 +199,7 @@ struct file *eventfd_fget(int fd)
 
 	return file;
 }
+EXPORT_SYMBOL_GPL(eventfd_fget);
 
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {
@@ -228,6 +231,7 @@ SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 		kfree(ctx);
 	return fd;
 }
+EXPORT_SYMBOL_GPL(sys_eventfd2);
 
 SYSCALL_DEFINE1(eventfd, unsigned int, count)
 {

