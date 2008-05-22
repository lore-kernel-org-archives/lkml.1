Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbYEVSS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbYEVSS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbYEVSST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:18:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64616 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYEVSSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:18:18 -0400
Date: Thu, 22 May 2008 14:18:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, paulus@samba.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH] rcupreempt: remove export of rcu_batches_completed_bh
Message-ID: <Pine.LNX.4.58.0805221415330.14724@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In rcupreempt, rcu_batches_completed_bh is defined as a static inline in
the header file. This does not need to be exported, and not only that,
this breaks my PPC build.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/rcupreempt.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-tip.git/kernel/rcupreempt.c
===================================================================
--- linux-tip.git.orig/kernel/rcupreempt.c	2008-05-22 11:12:30.000000000 -0700
+++ linux-tip.git/kernel/rcupreempt.c	2008-05-22 11:12:33.000000000 -0700
@@ -217,8 +217,6 @@ long rcu_batches_completed(void)
 }
 EXPORT_SYMBOL_GPL(rcu_batches_completed);

-EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
-
 void __rcu_read_lock(void)
 {
 	int idx;

