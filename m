Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbZEWTEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbZEWTEW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 15:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbZEWTEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 15:04:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:51460 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZEWTEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 15:04:13 -0400
Subject: Re: [PATCH 6/7] perf_counter: change pctrl() behaviour
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
In-Reply-To: <20090523163012.916937244@chello.nl>
References: <20090523162854.599719825@chello.nl>
	 <20090523163012.916937244@chello.nl>
Content-Type: text/plain
Date: Sat, 23 May 2009 21:04:08 +0200
Message-Id: <1243105448.6582.1559.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-23 at 18:29 +0200, Peter Zijlstra wrote:
> plain text document attachment (perf_counter-ctrl-all.patch)
> Instead of en/dis-abling all counters acting on a particular task, en/dis-
> able all counters we created.
> 
> LKML-Reference: <new-submission>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---

Please fold in the below so as to avoid an explosion on first
sys_perf_counter_open().

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -3446,6 +3446,9 @@ void perf_counter_init_task(struct task_
 
 	child->perf_counter_ctxp = NULL;
 
+	mutex_init(&child->perf_counter_mutex);
+	INIT_LIST_HEAD(&child->perf_counter_list);
+
 	/*
 	 * This is executed from the parent task context, so inherit
 	 * counters that have been marked for cloning.



