Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZDXEZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZDXEZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754186AbZDXEZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:25:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54383 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbZDXEZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:25:30 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [KVM PATCH v2 1/2] eventfd: export fget and signal interfaces for
	module use
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, davidel@xmailserver.org
Date: Fri, 24 Apr 2009 00:25:13 -0400
Message-ID: <20090424042513.1796.97490.stgit@dev.haskins.net>
In-Reply-To: <20090424042142.1796.60756.stgit@dev.haskins.net>
References: <20090424042142.1796.60756.stgit@dev.haskins.net>
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

