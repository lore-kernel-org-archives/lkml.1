Return-Path: <linux-kernel-owner+w=401wt.eu-S935281AbXGLQfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935281AbXGLQfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765305AbXGLQfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:35:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36246 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763981AbXGLQfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:35:12 -0400
Date: Thu, 12 Jul 2007 18:33:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: jim.houston@ccur.com, joe.korty@ccur.com, rostedt@goodmis.org,
       tglx@linutronix.de, dwalker@mvista.com, David Bahi <DBahi@novell.com>,
       Moiz Kohari <MKohari@novell.com>, Sven Dietrich <SDietrich@novell.com>,
       dsaxena@plexity.net, williams@redhat.com, abogani@texware.it,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22
	available
Message-ID: <20070712163341.GA9622@elte.hu>
References: <46961E080200005A000276AE@mcclure.wal.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46961E080200005A000276AE@mcclure.wal.novell.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

>   For the most part, it seems you guys have resolved most of the 
> issues that we ran into as well (e.g. early-flush-tlb, relocated 
> die-notifier, etc, come to mind).  I found one patch that was missing 
> that allows debug configurations to build properly.  Heres that patch:
> 
> --- linux-2.6.21.orig/kernel/latency_trace.c
> +++ linux-2.6.21/kernel/latency_trace.c
> @@ -24,6 +24,7 @@
>  #include <linux/utsrelease.h>
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> +#include <asm/asm-offsets.h>

i think this breaks PPC (which has no asm-offsets.h file). In any case i 
saw this build breakage too and the fix is in -rt2.

> We did find a regression.  I was mistaken earlier when I mentioned our 
> T60p laptops couldn't boot.  It turns out that issue was resolved 
> somewhere along the way and our published patches based on 21.5-rt19 
> do allow the laptop to boot event with acpi=on.  With 22.1-rt1 the 
> laptop crashes unless acpi=off.  Now that we have your queue we will 
> bisect this and post that fix as well.

ok. Make sure you check rt2 as well - and note that it's not fully 
bisectable with PREEMPT_RT enabled (but should probably be fully 
bisectable with PREEMPT_RT disabled). So check out first whether the 
problem still persists with PREEMPT_RT disabled.

	Ingo
