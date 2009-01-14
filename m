Return-Path: <linux-kernel-owner+w=401wt.eu-S1762154AbZANMEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154AbZANMEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbZANMEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:04:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:35205 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288AbZANMEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:04:39 -0500
Subject: Re: [PATCH 1/2] sched: introduce avg_wakeup
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1231934594.7141.30.camel@twins>
References: <20090114113917.199690328@chello.nl>
	 <20090114114026.969559732@chello.nl>  <1231934371.7141.29.camel@twins>
	 <1231934594.7141.30.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Jan 2009 13:04:39 +0100
Message-Id: <1231934679.7141.31.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 13:03 +0100, Peter Zijlstra wrote:
> On Wed, 2009-01-14 at 12:59 +0100, Peter Zijlstra wrote:
> > +       /*
> > +        * Only attribute actual wakeups done by this task.
> > +        */
> > +       if (!in_interrupt()) {
> > +               struct sched_entity *se = &current->se;
> > +               u64 sample = se->sum_exec_runtime;
> > +
> > +               if (se->last_wakeup)
> > +                       sample -= se->last_wakeup;
> > +               else
> > +                       sample -= se->start_runtime;
> > +               update_avg(&se->avg_wakeup, sample);
> > +
> > +               current->se.last_wakeup = current->se.sum_exec_runtime;
> > +       }
> 
> time for lunch apparently...

D'oh

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2424,7 +2424,7 @@ out_activate:
 			sample -= se->start_runtime;
 		update_avg(&se->avg_wakeup, sample);
 
-		current->se.last_wakeup = current->se.sum_exec_runtime;
+		se->last_wakeup = se->sum_exec_runtime;
 	}
 
 out_running:

