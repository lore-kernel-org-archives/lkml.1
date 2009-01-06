Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731AbZAFJTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbZAFJTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbZAFJTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:19:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37435 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbZAFJTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:19:35 -0500
Date: Tue, 6 Jan 2009 10:19:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: penberg@cs.helsinki.fi, rostedt@goodmis.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemtrace: Remove the relay version of kmemtrace.
Message-ID: <20090106091927.GA29863@elte.hu>
References: <20090105191330.GA1498@elte.hu> <1231186198-15437-1-git-send-email-eduard.munteanu@linux360.ro> <20090106084905.GB29917@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106084905.GB29917@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:
> 
> > kmemtrace now uses ftrace. This patch removes the relay version.
> > 
> > Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> > ---
> >  kernel/trace/Kconfig |    1 -
> >  mm/Makefile          |    1 -
> >  mm/kmemtrace.c       |  333 --------------------------------------------------
> >  3 files changed, 0 insertions(+), 335 deletions(-)
> >  delete mode 100644 mm/kmemtrace.c
> 
> applied to tip/tracing/kmemtrace2, thanks Eduard!

I needed the small fixlet below as well.

	Ingo

-------------->
>From 3e80680208ba6ce9635ca7c21ad0019442ea166a Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 6 Jan 2009 10:16:35 +0100
Subject: [PATCH] kmemtrace: add kmemtrace_init()

Impact: build fix

leftover from the relayfs version - but we want to keep it because
this call is the earliest opportunity when we can start kmemtrace
tracing. (after kmem_cache_init()).

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/kmemtrace.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 2bfdcd3..faaa5ae 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -337,6 +337,11 @@ static struct tracer kmem_tracer __read_mostly = {
 	.flags		= &kmem_tracer_flags
 };
 
+void kmemtrace_init(void)
+{
+	/* earliest opportunity to start kmem tracing */
+}
+
 static int __init init_kmem_tracer(void)
 {
 	return register_tracer(&kmem_tracer);
