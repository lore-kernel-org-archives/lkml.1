Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZAGJtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZAGJtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZAGJt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:49:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36644 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbZAGJtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:49:25 -0500
Date: Wed, 7 Jan 2009 10:49:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roel Kluin <roel.kluin@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/4] ftrace: important updates
Message-ID: <20090107094905.GB16025@elte.hu>
References: <20090107041605.168020089@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107041605.168020089@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> The first patch is a critical fix that needs to get into 2.6.29.
> 
> The next patch is a rename of tracing_on to writing_enabled since
> tracing_on is confusing, and the file enables or disables writes.
> 
> The last patch is a fix to tip that prevents a memory leak.
> 
> This version I added some clean ups that Andrew Morton suggested.
> I know you did not pull the previous version, because I forgot
> to push the changes to kernel.org ;-)
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Frederic Weisbecker (1):
>       tracing/ftrace: fix a memory leak in stat tracing
> 
> Steven Rostedt (3):
>       ftrace: convert unsigned index to signed
>       trace: clean up funny line breaks in stat_seq_show

pulled most of it, thanks Steve, except this bit:

>       ring-buffer: rename debugfs file tracing_on to writing_enabled

writing_enabled is at least as confusing as tracing_on - if not more so.

The user really does not care about all the deeper machinery that happens 
in ftrace - the difference between a 'light' disabling of a tracer and a 
'heavy' disabling of a tracer (which means it unregisters itself 
completely in essence).

To resolve this, we should probably hide this difference altogether (as i 
have suggested to do many months ago, when this first came up), by 
removing tracing_enabled.

A tracer can still be fully unregistered: by simply switching the current 
tracer to the 'nop' tracer. tracing_on/off remains the lightweight version 
that most users are interested in anyway.

	Ingo
