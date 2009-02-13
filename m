Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbZBMNF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbZBMNF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZBMNFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:05:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55677 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZBMNFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:05:16 -0500
Date: Fri, 13 Feb 2009 14:04:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, akpm <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: irq-disabled vs vmap vs text_poke
Message-ID: <20090213130450.GB9346@elte.hu>
References: <1234529407.6519.28.camel@twins> <20090213125505.GE18462@wotan.suse.de> <1234530138.6519.38.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234530138.6519.38.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> > I think I got a mostly working patch cobbled together sitting here
> > somewhere. I was waiting for some _really_ good use case before spending
> > more time on it. I would prefer if at all possible to do vmap operations
> > in sleepable, process context.
> 
> Agreed, I think we want to fix text_poke() and make the vmap/vunmap()
> ops yell louder at violations of these rules.
> 
> I'm just totally clueless wrt text_poke() hence this email ;-)

also, this started triggering yesterday for the first time - and never
saw it before. Has some commit caused this side-effect?

It triggers during kprobes self-test - has that been improved recently?

Maybe these:

f24659d: kprobes: support probing module __init function
0deddf4: module: add MODULE_STATE_LIVE notify
49ad2fd: kprobes: remove called_from argument
e8386a0: kprobes: support probing module __exit function
017c39b: kprobes: add __kprobes to kprobe internal functions
1294156: kprobes: add kprobe_insn_mutex and cleanup arch_remove_kprobe()
a06f621: module: add within_module_core() and within_module_init()
12da3b8: kprobes: add tests for register_kprobes
8e11440: kprobes: indirectly call kprobe_target
bc2f701: kprobes: bugfix: try_module_get even if calling_mod is NULL

exposed this (long-lived) bug?

	Ingo
