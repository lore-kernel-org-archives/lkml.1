Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbYL0KVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbYL0KVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYL0KVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:21:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60261 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbYL0KVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:21:24 -0500
Date: Sat, 27 Dec 2008 11:20:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       randy.dunlap@oracle.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Eliminate atleast 10684 sparse warnings
Message-ID: <20081227102038.GC14639@elte.hu>
References: <1230371496.3276.4.camel@jaswinder.satnam> <20081227020734.3592507e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227020734.3592507e.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 27 Dec 2008 15:21:36 +0530 Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:
> 
> >  #ifdef CONFIG_ILLEGAL_POINTER_VALUE
> > -# define POISON_POINTER_DELTA CONFIG_ILLEGAL_POINTER_VALUE
> > +# define POISON_POINTER_DELTA _AC(CONFIG_ILLEGAL_POINTER_VALUE, UL)
> >  #else
> >  # define POISON_POINTER_DELTA 0
> >  #endif
> 
> So now
> 
> commit 948f984df52511bb0efa5c026813b0c34de43aa0
> Author:     Avi Kivity <avi@qumranet.com>
> AuthorDate: Tue May 20 14:39:25 2008 +0300
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue May 20 13:42:31 2008 +0200
> 
>     core, x86: make LIST_POISON less deadly
> 
> gets splattered across three commits (at least).  Sigh.

Can rebase, although that would hide the (deserved) credit that 
Jaswinder's patch deserves. And it does not appear to be a must-rebase 
example to me - it's not like one does sparse builds during bisection.

> (how come that patch is 7 moonths old and still unmerged, btw?)

Linus had reservations about the first version (which got fixed but which 
prevented it from going upstream in the first cycle) - and it's not an 
exactly critical change and other stuff interfered. All our previous merge 
windows were fully filled ;)

	Ingo
