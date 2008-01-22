Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbYAVTuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbYAVTuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYAVTt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:49:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:1079 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYAVTt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:49:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=jw/iiCmZqHI5Cv1mfNbbDu0JWCYwyjGY3Bjc5EX8mPMuD96N6zkk/WtoUFBGvHzVV1Ld85mefcgSYYcq6x4FnZY+Yqf4LSTsj8sSB4/5kPmWgF9CnVC8LIzYSGeGF64uPP2WkXYcNsnPNUVKHOOP+ovLur7aBCjwg1lRTriuKPA=
Date: Tue, 22 Jan 2008 22:49:43 +0300
To: akpm@osdl.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Detach sched.h and futex.h
Message-ID: <20080122194943.GA1975@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/futex.h |    6 +++++-
 include/linux/sched.h |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -1,8 +1,12 @@
 #ifndef _LINUX_FUTEX_H
 #define _LINUX_FUTEX_H
 
-#include <linux/sched.h>
+#include <linux/compiler.h>
+#include <linux/types.h>
 
+struct inode;
+struct mm_struct;
+struct task_struct;
 union ktime;
 
 /* Second argument to futex syscall */
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -78,7 +78,6 @@ struct sched_param {
 #include <linux/proportions.h>
 #include <linux/seccomp.h>
 #include <linux/rcupdate.h>
-#include <linux/futex.h>
 #include <linux/rtmutex.h>
 
 #include <linux/time.h>
@@ -93,6 +92,7 @@ struct sched_param {
 
 struct exec_domain;
 struct futex_pi_state;
+struct robust_list_head;
 struct bio;
 
 /*
