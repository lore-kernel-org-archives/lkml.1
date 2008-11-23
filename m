Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYKWQXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYKWQXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbYKWQXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:23:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42724 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbYKWQXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:23:06 -0500
Date: Sun, 23 Nov 2008 17:22:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86: introduce X86_ assembly names macros to catch
	unbalanced declaration
Message-ID: <20081123162257.GB570@elte.hu>
References: <20081123161455.GE27396@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123161455.GE27396@localhost>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> It's usefull to catch unbalanced or messed declarations of ENTRY and
> KPROBES. These macros would help a bit (at least I hope so).
> 
> For example the following code would compile without problems
> 
> 	X86_ENTRY(mcount)
> 		retq
> 	X86_END(mcount)
> 
> But if you forget and mess the following form
> 
> 	X86_ENTRY(mcount)
> 		retq
> 	END(mcount)
> 
> 	X86_ENTRY(ftrace_caller)
> 
> The assembler will issue the following message:
> Error: X86_ENTRY/KPROBE unbalanced or missed

looks good - a very small detail: i'd suggest ENTRY_X86()/END_X86() - 
because whoever is reading this portion of the code is amply aware of 
the fact that this is the x86 tree - so the more important information 
should come first.

	Ingo
