Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbYGXGL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbYGXGL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 02:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYGXGLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 02:11:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56062 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbYGXGLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 02:11:47 -0400
Date: Thu, 24 Jul 2008 08:11:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ftrace: eh?
Message-ID: <20080724061129.GA15772@elte.hu>
References: <4887B07D.4080000@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4887B07D.4080000@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> kernel/trace/trace.c:s_next():
>
> 	if (last_ent && !ent)
> 		seq_puts(m, "\n\nvim:ft=help\n");
>
> eh?

uhm, yes, that was me, years ago when i wrote the original version of 
the latency tracer. If you look at such traces via vim then portions of 
the trace will be color highlighted automatically with that tag in 
place.

Thanks for the reminder, i've removed it via the patch below.

	Ingo

------------>
commit 1986b0cb1671ea39178b4e2b00461109728fc935
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Jul 24 08:10:02 2008 +0200

    ftrace: remove latency-tracer leftover
    
    remove the :vim=ft=help tag from trace files.
    
    I used them years ago to syntax-highlight traces and forgot about this hack.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 868e121..fc20e09 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1203,9 +1203,6 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 
 	iter->pos = *pos;
 
-	if (last_ent && !ent)
-		seq_puts(m, "\n\nvim:ft=help\n");
-
 	return ent;
 }
 
