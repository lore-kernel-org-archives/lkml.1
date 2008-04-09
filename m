Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYDIWfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYDIWfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 18:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYDIWfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 18:35:25 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37436 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbYDIWfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:35:24 -0400
Date: Wed, 9 Apr 2008 15:34:06 -0700
From: sukadev@us.ibm.com
To: Andrew Morton <akpm@osdl.org>
Cc: clg@fr.ibm.com, serue@us.ibm.com, "David C. Hansen" <haveblue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] add do_unshare()
Message-ID: <20080409223406.GB28267@us.ibm.com>
References: <20080409222611.GA28087@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409222611.GA28087@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Subject: [PATCH 2/3] add do_unshare()

This patch adds a do_unshare() routine which will be common
to the unshare() and unshare64() syscall.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
---
 kernel/fork.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: 2.6.25-rc2-mm1/kernel/fork.c
===================================================================
--- 2.6.25-rc2-mm1.orig/kernel/fork.c
+++ 2.6.25-rc2-mm1/kernel/fork.c
@@ -1696,7 +1696,7 @@ static int unshare_semundo(u64 unshare_f
  * constructed. Here we are modifying the current, active,
  * task_struct.
  */
-asmlinkage long sys_unshare(unsigned long unshare_flags)
+static long do_unshare(u64 unshare_flags)
 {
 	int err = 0;
 	struct fs_struct *fs, *new_fs = NULL;
@@ -1790,3 +1790,8 @@ bad_unshare_cleanup_thread:
 bad_unshare_out:
 	return err;
 }
+
+asmlinkage long sys_unshare(unsigned long unshare_flags)
+{
+	return do_unshare(unshare_flags);
+}

-- 

--~--~---------~--~----~------------~-------~--~----~
You received this message because you are subscribed to the Google Groups "lxc-dev" group.
To post to this group, send email to lxc-dev@googlegroups.com
To unsubscribe from this group, send email to lxc-dev-unsubscribe@googlegroups.com
For more options, visit this group at http://groups.google.com/group/lxc-dev?hl=en
-~----------~----~----~----~------~----~------~--~---

