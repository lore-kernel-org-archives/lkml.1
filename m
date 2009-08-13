Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbZHMElQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbZHMElQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 00:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZHMElQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 00:41:16 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:59051 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750729AbZHMElP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 00:41:15 -0400
Subject: [PATCH][RT] Fix build errors in rtmutex
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Novell
Date: Wed, 12 Aug 2009 21:41:07 -0700
Message-Id: <1250138467.15796.16.camel@quadrophenia.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Fix up "too few parameters to function" build errors in rtmutex
From: Sven-Thorsten Dietrich <sdietrich@suse.de>

Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>
Index: b/kernel/rtmutex.c
===================================================================
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -1513,7 +1513,8 @@ int rt_mutex_start_proxy_lock(struct rt_
 
 	mark_rt_mutex_waiters(lock);
 
-	if (!rt_mutex_owner(lock) || try_to_steal_lock(lock, task)) {
+	if (!rt_mutex_owner(lock) || 
+	   try_to_steal_lock(lock, task, STEAL_NORMAL)) {
 		/* We got the lock for task. */
 		debug_rt_mutex_lock(lock);
 		rt_mutex_set_owner(lock, task, 0);
@@ -1522,7 +1523,8 @@ int rt_mutex_start_proxy_lock(struct rt_
 		return 1;
 	}
 
-	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock, 
+				     flags);
 
 	if (ret && !waiter->task) {
 		/*
Index: b/kernel/trace/ring_buffer.c
===================================================================
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2522,7 +2522,7 @@ ring_buffer_peek(struct ring_buffer *buf
 	if (event && event->type_len == RINGBUF_TYPE_PADDING)
 		rb_advance_reader(cpu_buffer);
 	if (dolock)
-		atomic_)spin_unlock(&cpu_buffer->reader_lock);
+		atomic_spin_unlock(&cpu_buffer->reader_lock);
 	local_irq_restore(flags);
 
 	if (event && event->type_len == RINGBUF_TYPE_PADDING) {


