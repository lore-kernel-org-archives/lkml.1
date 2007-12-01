Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbXLAHlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbXLAHlY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 02:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbXLAHlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 02:41:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37820 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbXLAHlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 02:41:16 -0500
Date: Sat, 1 Dec 2007 08:40:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: Andi Kleen <ak@suse.de>, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>, markus.t.metzger@gmail.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 0/2] x86, ptrace:  support for branch trace store(BTS)
Message-ID: <20071201074044.GA13974@elte.hu>
References: <029E5BE7F699594398CA44E3DDF5544401024075@swsmsx413.ger.corp.intel.com> <20071129155940.7df70ac2.akpm@linux-foundation.org> <029E5BE7F699594398CA44E3DDF5544401051EEF@swsmsx413.ger.corp.intel.com> <200711301134.04719.ak@suse.de> <029E5BE7F699594398CA44E3DDF554440105236A@swsmsx413.ger.corp.intel.com> <20071130170655.GA10868@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071130170655.GA10868@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Our debugger team has a prototype implementation for their debugger. 
> > But that will not be available for some time.
> > 
> > I hope that we get gdb support, soon, but that would take a while if 
> > I had to do it.
> 
> i'm wondering what the main use-case would be then, and what the gdb 
> folks think about the current API. (Roland?)

here's a forwarded mail from Roland about the patch and APIs. (and i 
hope that now i can stop playing the middleman, with everyone Cc:-ed :)

------------>
From: Roland McGrath <roland@redhat.com>
Subject: Re: [patch][v2] x86, ptrace: support for branch trace store(BTS)]

Cool.  It's been on my list to look into exposing those features 
somehow. I hadn't planned on doing it until after the utrace stuff 
settles and there is a more coherent interface context in which to do 
it.

If they are tackling the MSR hacking and context switch and so forth, 
I'd like to see them start out by just adding block-step 
(debugctlmsr.btf) with the PTRACE_SINGLEBLOCK interface as ia64 has.  
That should lay some of the same groundwork needed here, but is much 
simpler.

I am not really in favor of this new ptrace interface.  I think they 
should look around across arch's and think about sane general-purpose 
interfaces for features of this kind that might be built with some 
commonality across machines.  Also do it in a layered way from 
low-level, with something usable for kernel-mode too.  The discussion 
Alan Stern and I had on LKML that started as kwatch and became 
hw_breakpoint is an example of how I would go at this set of features 
too.
