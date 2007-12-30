Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbXL3NdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbXL3NdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbXL3NdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:33:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39068 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbXL3NdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:33:03 -0500
Date: Sun, 30 Dec 2007 14:23:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: kprobes remove fix_riprel #ifdef
Message-ID: <20071230132337.GF16946@elte.hu>
References: <1198466917.6323.15.camel@brick> <47773CAD.7050907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47773CAD.7050907@redhat.com>
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Hello Harvey,
> 
> A similar idea was already nack-ed by Ananth.
> http://sources.redhat.com/ml/systemtap/2007-q4/msg00468.html
> And I agree his thought.
> 
> Especially, "riprel" does not exist on x86_32, so fix_riprel()
> is meaningless on it.
> Thus, I think it would better be ifdef'd in call-site.

but we regularly do this in generic code: we add calls that are NOPs on 
some architectures. For example flush_cache_page() makes no sense on the 
x86 architecture. So i'm inclined to apply Harvey's cleanup - less
#ifdef complexity in higher-level code is very much favored, even
if "riprel" is a NOP concept on 32-bit.

	Ingo
