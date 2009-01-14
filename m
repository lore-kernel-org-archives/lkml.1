Return-Path: <linux-kernel-owner+w=401wt.eu-S1760149AbZANNU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149AbZANNU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 08:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbZANNUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 08:20:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:52015 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067AbZANNUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 08:20:11 -0500
Subject: Re: [PATCH 1/2] sched: introduce avg_wakeup
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090114120558.GA5711@elte.hu>
References: <20090114113917.199690328@chello.nl>
	 <20090114114026.969559732@chello.nl> <1231934371.7141.29.camel@twins>
	 <1231934594.7141.30.camel@twins>  <20090114120558.GA5711@elte.hu>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 14:20:08 +0100
Message-Id: <1231939208.14825.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 13:05 +0100, Ingo Molnar wrote:

> mind sending a delta against the first submission? Whenever you are done 
> with the lunch stuff ;-)

Compile fix and cleanup, actually compile tested too :-)

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2415,14 +2415,16 @@ out_activate:
 	 * Only attribute actual wakeups done by this task.
 	 */
 	if (!in_interrupt()) {
+		struct sched_entity *se = &current->se;
 		u64 sample = se->sum_exec_runtime;
+
 		if (se->last_wakeup)
 			sample -= se->last_wakeup;
 		else
 			sample -= se->start_runtime;
 		update_avg(&se->avg_wakeup, sample);
 
-		current->se.last_wakeup = current->se.sum_exec_runtime;
+		se->last_wakeup = se->sum_exec_runtime;
 	}
 
 out_running:


