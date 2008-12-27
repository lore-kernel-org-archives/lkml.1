Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYL0FR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYL0FR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 00:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYL0FRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 00:17:21 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:48821 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYL0FRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 00:17:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X9lO2+uG0k0gUuUwKCmdD/DJ6dT9xZd2nTcq0kIdVBQSTtaDr9atVoRfjFZic37tls
         qOYJtFbLHbPOsgUbPTOArxCzQGJc93rDxnFsmT9UQzh1z03UEJ71N1O+u3H8mA1SUWO/
         Tqjse2k8I3qElD1pUH897IndBJur0YrvdOhC4=
Date: Sat, 27 Dec 2008 14:17:12 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/4] convert task_struct allocator macros to inline
	functions
Message-ID: <20081227051710.GB3295@localhost.localdomain>
References: <20081227051606.GA3295@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20081227051606.GA3295@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usually inline function is better than function-like macro.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 kernel/fork.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: 2.6/kernel/fork.c
===================================================================
--- 2.6.orig/kernel/fork.c
+++ 2.6/kernel/fork.c
@@ -92,9 +92,19 @@ int nr_processes(void)
 }
 
 #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
-# define alloc_task_struct()	kmem_cache_alloc(task_struct_cachep, GFP_KERNEL)
-# define free_task_struct(tsk)	kmem_cache_free(task_struct_cachep, (tsk))
+
 static struct kmem_cache *task_struct_cachep;
+
+static inline struct task_struct *alloc_task_struct(void)
+{
+	return kmem_cache_alloc(task_struct_cachep, GFP_KERNEL);
+}
+
+static inline void free_task_struct(struct task_struct *tsk)
+{
+	kmem_cache_free(task_struct_cachep, tsk);
+}
+
 #endif
 
 #ifndef __HAVE_ARCH_THREAD_INFO_ALLOCATOR
