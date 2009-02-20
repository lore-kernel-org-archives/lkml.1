Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbZBTID3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbZBTID3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZBTIDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:03:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbZBTIDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:03:17 -0500
Date: Fri, 20 Feb 2009 09:02:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Huang Ying <ying.huang@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH, v2] x86: use the right protections for split-up
	pagetables
Message-ID: <20090220080246.GA28669@elte.hu>
References: <20090220011316.379904625@goodmis.org> <alpine.LFD.2.00.0902191753240.21686@localhost.localdomain> <alpine.DEB.1.10.0902192107230.31658@gandalf.stny.rr.com> <alpine.LFD.2.00.0902191923300.21686@localhost.localdomain> <20090220072915.GB28085@elte.hu> <20090220073932.GA17648@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220073932.GA17648@elte.hu>
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

> [ Huang Ying also experienced problems in this area when writing
>   the EFI code, but the real bug in split_large_page() was not
>   realized back then. ]

> -	 * On Intel the NX bit of all levels must be cleared to make a
> -	 * page executable. See section 4.13.2 of Intel 64 and IA-32
> -	 * Architectures Software Developer's Manual).

Hm, in hindsight, we should have noticed this bug sooner - when 
the NX comment above was added. There's never any good reason to 
play protection games with higher-level pagetable entries. We 
dont do it to user-space pagetables either - we just populate 
them to _PAGE_TABLE and that's it.

	Ingo
