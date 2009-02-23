Return-Path: <linux-kernel-owner+w=401wt.eu-S1753233AbZBWJD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbZBWJD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 04:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZBWJDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 04:03:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47283 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbZBWJDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:03:13 -0500
Date: Mon, 23 Feb 2009 10:02:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for
	conversions
Message-ID: <20090223090213.GG9582@elte.hu>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org> <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com> <20090223023332.GA5430@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223023332.GA5430@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Can you provide numbers to indicate why it's required to be so 
> intrusive in the kernel mappings while doing these 
> modifications ? I think opening such time window where 
> standard code mapping is writeable globally in config RO_DATA 
> kernels could open the door to unexpected side-effects, so 
> ideally going through the "backdoor" page mapped by text_poke 
> seems safer. Given similar performance, I would tend to use a 
> text_poke-like approach.

It's not really an issue - this code is only called during 
normal operation if the admin does it.

As far as scare mongering goes a "backdoor" page is in fact more 
attackable because it's at a more predictable position and due 
to text-poke's slowness the window of vulnerability is longer.

Anyway, this is all pretty theoretical and irrelevant. The 
purpose of RODATA is mainly to protect against benign/unintended 
sources of kernel text corruption. An attacker, if he can modify 
arbitrary kernel text address can already modify other critical 
data structures to gain access.

	Ingo
