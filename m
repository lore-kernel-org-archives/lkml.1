Return-Path: <linux-kernel-owner+w=401wt.eu-S1760227AbXEVXAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbXEVXAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbXEVW76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:59:58 -0400
Received: from rwcrmhc12.comcast.net ([216.148.227.152]:44074 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbXEVW76 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:59:58 -0400
Subject: [PATCH] 2.6.21-rt6
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: LKML <Linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: The Big Corporation
Date: Tue, 22 May 2007 15:59:55 -0700
Message-Id: <1179874795.25500.40.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add header and export for rt_write_trylock_irqsave.


Index: linux-2.6.21/include/linux/spinlock.h
===================================================================
--- linux-2.6.21.orig/include/linux/spinlock.h
+++ linux-2.6.21/include/linux/spinlock.h
@@ -294,6 +294,7 @@ do {									\
 extern void __lockfunc rt_write_lock(rwlock_t *rwlock);
 extern void __lockfunc rt_read_lock(rwlock_t *rwlock);
 extern int __lockfunc rt_write_trylock(rwlock_t *rwlock);
+extern int __lockfunc rt_write_trylock_irqsave(rwlock_t *trylock);
 extern int __lockfunc rt_read_trylock(rwlock_t *rwlock);
 extern void __lockfunc rt_write_unlock(rwlock_t *rwlock);
 extern void __lockfunc rt_read_unlock(rwlock_t *rwlock);
Index: linux-2.6.21/kernel/rt.c
===================================================================
--- linux-2.6.21.orig/kernel/rt.c
+++ linux-2.6.21/kernel/rt.c
@@ -178,6 +178,7 @@ int __lockfunc rt_write_trylock_irqsave(
 	*flags = 0;
 	return rt_write_trylock(rwlock);
 }
+EXPORT_SYMBOL(rt_write_trylock_irqsave);
 
 int __lockfunc rt_read_trylock(rwlock_t *rwlock)
 {


