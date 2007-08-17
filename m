Return-Path: <linux-kernel-owner+w=401wt.eu-S1759791AbXHQJhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791AbXHQJhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 05:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXHQJg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 05:36:59 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:47218 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbXHQJg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 05:36:58 -0400
Message-ID: <46C56A3D.3070103@openvz.org>
Date: Fri, 17 Aug 2007 13:28:29 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Alexey Dobriyan <adobriyan@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH] Fix the return value of sys_set_tid_address()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This call should return the virtual pid to the caller, just like
the sys_getpid()/sys_gettid() do, no the global one.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>

---

 kernel/fork.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 645c614..d7cff48 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -938,7 +938,7 @@ asmlinkage long sys_set_tid_address(int 
 {
 	current->clear_child_tid = tidptr;
 
-	return current->pid;
+	return task_pid_vnr(current);
 }
 
 static inline void rt_mutex_init_task(struct task_struct *p)

