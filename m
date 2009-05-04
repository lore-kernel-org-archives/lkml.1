Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbZEDSEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbZEDSEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZEDSDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:03:39 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53184 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZEDSDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:03:37 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v4 1/2] eventfd: export eventfd interfaces for module use
To: kvm@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Date: Mon, 04 May 2009 13:57:45 -0400
Message-ID: <20090504175745.26758.94086.stgit@dev.haskins.net>
In-Reply-To: <20090504175657.26758.12503.stgit@dev.haskins.net>
References: <20090504175657.26758.12503.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will re-use eventfd for implmenting irqfd later in the series, and the
irqfd users will potentially live in modules.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 fs/eventfd.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 0de6ebb..2e1c2ff 100644
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
 
 struct file *eventfd_file_create(unsigned int count, int flags)
 {
@@ -225,6 +228,7 @@ struct file *eventfd_file_create(unsigned int count, int flags)
 
 	return file;
 }
+EXPORT_SYMBOL_GPL(eventfd_file_create);
 
 SYSCALL_DEFINE2(eventfd2, unsigned int, count, int, flags)
 {

