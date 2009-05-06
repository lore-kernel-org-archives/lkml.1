Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbZEFMXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbZEFMXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759839AbZEFMXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:23:09 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:51402 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759035AbZEFMXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:23:07 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v5 1/2] eventfd: export eventfd interfaces for module use
To: kvm@vger.kernel.org
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, avi@redhat.com,
       davidel@xmailserver.org
Date: Wed, 06 May 2009 08:23:00 -0400
Message-ID: <20090506122300.31350.22097.stgit@dev.haskins.net>
In-Reply-To: <20090506121333.31350.39889.stgit@dev.haskins.net>
References: <20090506121333.31350.39889.stgit@dev.haskins.net>
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

