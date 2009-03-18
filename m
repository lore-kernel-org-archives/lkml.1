Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZCRFD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZCRFD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 01:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZCRFDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 01:03:46 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55813 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZCRFDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 01:03:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18880.31021.850273.736650@drongo.ozlabs.ibm.com>
Date: Wed, 18 Mar 2009 15:31:41 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 09/11] perf_counter: revamp syscall input ABI
In-Reply-To: <20090317220421.336322251@chello.nl>
References: <20090317215606.037073805@chello.nl>
	<20090317220421.336322251@chello.nl>
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> The hardware/software classification in hw_event->type became a little strained
> due to the addition of tracepoint tracing.
> 
> Instead split up the field and provide a type field to explicitly specify the
> counter type, while using the event_id field to specify which event to use.

It would be nice if you didn't reuse the name 'type' but instead
called the field something different ('class', perhaps?) to force a
compile error on code that needs to be updated.  For example, you
missed a spot in arch/powerpc/kernel/perf_counter.c and you need to
add on the patch below.  (Thanks for updating powerpc BTW.)

Paul.

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index efaeecf..88b72eb 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -602,7 +602,7 @@ hw_perf_counter_init(struct perf_counter *counter)
 		return NULL;
 	if ((s64)counter->hw_event.irq_period < 0)
 		return NULL;
-	ev = counter->hw_event.type;
+	ev = counter->hw_event.event_id;
 	if (!counter->hw_event.raw) {
 		if (ev >= ppmu->n_generic ||
 		    ppmu->generic_events[ev] == 0)
