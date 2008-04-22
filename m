Return-Path: <linux-kernel-owner+w=401wt.eu-S1763620AbYDVOUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763620AbYDVOUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYDVOT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:19:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41978 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbYDVOT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:19:57 -0400
Date: Tue, 22 Apr 2008 16:19:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix x86_64 page fault scheduler race
Message-ID: <20080422141909.GE24966@elte.hu>
References: <20080422132151.GA32120@Krystal> <20080422132614.GC7311@elte.hu> <20080422140636.GA1683@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422140636.GA1683@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> > the scheduler disables interrupts around __switch_to(). (x86 does 
> > not set __ARCH_WANT_INTERRUPTS_ON_CTXSW)
> 
> Ok, so I guess it's only useful to NMIs then. However, it makes me 
> wonder why this comment was there in the first place on x86_32 
> vmalloc_fault() and why it uses read_cr3() :
> 
>         * Do _not_ use "current" here. We might be inside
>         * an interrupt in the middle of a task switch..

hm, i guess it's still useful to keep the 
__ARCH_WANT_INTERRUPTS_ON_CTXSW case working too. On -rt we used to 
enable it to squeeze a tiny bit more latency out of the system.

	Ingo
