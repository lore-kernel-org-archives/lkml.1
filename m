Return-Path: <linux-kernel-owner+w=401wt.eu-S1751759AbYBKJ7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbYBKJ7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYBKJ64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:58:56 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33972 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYBKJ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:58:55 -0500
Message-Id: <20080211095847.396005856@fr.ibm.com>
References: <20080211095806.585883882@fr.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Feb 2008 10:58:08 +0100
From: clg@fr.ibm.com
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xemul@openvz.org, serue@us.ibm.com,
       Cedric Le Goater <clg@fr.ibm.com>
Subject: [patch 2/3] add do_unshare()
Content-Disposition: inline; filename=clone64-add-do_unshare.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cedric Le Goater <clg@fr.ibm.com>

This patch adds a do_unshare() routine which will be common
to the unshare() and unshare64() syscall.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 kernel/fork.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: 2.6.24-mm1/kernel/fork.c
===================================================================
--- 2.6.24-mm1.orig/kernel/fork.c
+++ 2.6.24-mm1/kernel/fork.c
@@ -1694,7 +1694,7 @@ static int unshare_semundo(u64 unshare_f
  * constructed. Here we are modifying the current, active,
  * task_struct.
  */
-asmlinkage long sys_unshare(unsigned long unshare_flags)
+static long do_unshare(u64 unshare_flags)
 {
 	int err = 0;
 	struct fs_struct *fs, *new_fs = NULL;
@@ -1788,3 +1788,8 @@ bad_unshare_cleanup_thread:
 bad_unshare_out:
 	return err;
 }
+
+asmlinkage long sys_unshare(unsigned long unshare_flags)
+{
+	return do_unshare(unshare_flags);
+}

-- 
