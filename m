Return-Path: <linux-kernel-owner+w=401wt.eu-S1764272AbZE0PQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764272AbZE0PQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbZE0PQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:16:09 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:57496 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbZE0PQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:16:09 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/2] eventfd: export eventfd interfaces for module use
To: mst@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org, mtosatti@redhat.com
Date: Wed, 27 May 2009 10:37:01 -0400
Message-ID: <20090527143700.14024.38256.stgit@dev.haskins.net>
In-Reply-To: <20090527143251.14024.89090.stgit@dev.haskins.net>
References: <20090527143251.14024.89090.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to use eventfd from KVM which can be compiled as a module, so
export the interfaces.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
---

 fs/eventfd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 2a701d5..3f0e197 100644
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

