Return-Path: <linux-kernel-owner+w=401wt.eu-S1765487AbXGVJuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765487AbXGVJuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 05:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbXGVJui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 05:50:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:55620 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbXGVJuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 05:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=YGT+fwZ8NDQqkjFaiK30oRcqh2nKPzWxJqMysd7UPtF632NmwpsTgK9WjwmDzwinW3nTSJvn9ZIF9XYw/yGARPq7ROWaIn0ZU/2/m57Q1fr3T/4zLAkziGKvyEFb5ERJTEyM4TIWAINsw3lcrc12UmqIZxa5r7I+h/KTl2QjjHw=
Date: Sun, 22 Jul 2007 13:50:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove sysctl.h from fs.h
Message-ID: <20070722095033.GA5802@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rrrr, addition of sysctl.h to fs.h was't very smart, because simple
editing of the former will buy you big recompile, where it shouldn't
have to.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -283,7 +283,6 @@ extern int dir_notify_enable;
 #include <linux/init.h>
 #include <linux/pid.h>
 #include <linux/mutex.h>
-#include <linux/sysctl.h>
 #include <linux/capability.h>
 
 #include <asm/atomic.h>
@@ -1953,7 +1952,8 @@ static inline void free_secdata(void *secdata)
 { }
 #endif	/* CONFIG_SECURITY */
 
-int proc_nr_files(ctl_table *table, int write, struct file *filp,
+struct ctl_table;
+int proc_nr_files(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
 
 

