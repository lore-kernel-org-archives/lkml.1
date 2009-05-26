Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbZEZTPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbZEZTPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756640AbZEZTPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:15:35 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:57243 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbZEZTPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:15:32 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v4 1/3] eventfd: export eventfd interfaces for module use
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davide@xmailserver.org,
       mtosatti@redhat.com
Date: Tue, 26 May 2009 15:15:29 -0400
Message-ID: <20090526191528.20860.67700.stgit@dev.haskins.net>
In-Reply-To: <20090526191010.20860.75372.stgit@dev.haskins.net>
References: <20090526191010.20860.75372.stgit@dev.haskins.net>
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

