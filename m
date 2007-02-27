Return-Path: <linux-kernel-owner+w=401wt.eu-S1752595AbXB0XRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbXB0XRx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbXB0XRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:17:53 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:46605 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbXB0XRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:17:49 -0500
Message-Id: <20070227231659.074701193@szeredi.hu>
References: <20070227231442.627972152@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 28 Feb 2007 00:14:57 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 15/22] add non-owner variant of down_read_trylock()
Content-Disposition: inline; filename=down_read_trylock_non_owner.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Needed by fuse writepage.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/include/linux/rwsem.h
===================================================================
--- linux.orig/include/linux/rwsem.h	2007-02-27 14:40:55.000000000 +0100
+++ linux/include/linux/rwsem.h	2007-02-27 14:41:09.000000000 +0100
@@ -82,11 +82,13 @@ extern void down_write_nested(struct rw_
  *   proper abstraction for this case is completions. ]
  */
 extern void down_read_non_owner(struct rw_semaphore *sem);
+extern int down_read_trylock_non_owner(struct rw_semaphore *sem);
 extern void up_read_non_owner(struct rw_semaphore *sem);
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
 # define down_write_nested(sem, subclass)	down_write(sem)
 # define down_read_non_owner(sem)		down_read(sem)
+# define down_read_trylock_non_owner(sem)	down_read_trylock(sem)
 # define up_read_non_owner(sem)			up_read(sem)
 #endif
 
Index: linux/kernel/rwsem.c
===================================================================
--- linux.orig/kernel/rwsem.c	2007-02-27 14:40:55.000000000 +0100
+++ linux/kernel/rwsem.c	2007-02-27 14:41:09.000000000 +0100
@@ -125,6 +125,13 @@ void down_read_non_owner(struct rw_semap
 
 EXPORT_SYMBOL(down_read_non_owner);
 
+int down_read_trylock_non_owner(struct rw_semaphore *sem)
+{
+	return __down_read_trylock(sem);
+}
+
+EXPORT_SYMBOL(down_read_trylock_non_owner);
+
 void down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	might_sleep();

--
