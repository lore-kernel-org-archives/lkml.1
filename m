Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbYG2MM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbYG2MM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbYG2MMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:12:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59767 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbYG2MMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:12:19 -0400
Date: Tue, 29 Jul 2008 14:11:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [rfc git pull] cpus4096 fixes, take 2
Message-ID: <20080729121156.GA367@elte.hu>
References: <20080727190601.GA764@elte.hu> <alpine.LFD.1.10.0807281127150.3486@nehalem.linux-foundation.org> <20080728205700.GA3613@elte.hu> <200807291145.20231.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807291145.20231.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Tuesday 29 July 2008 06:57:00 Ingo Molnar wrote:
> > +/*
> > + * In cases where we take the address of the cpumask immediately,
> > + * gcc optimizes it out (it's a constant) and there's no huge stack
> > + * variable created:
> > + */
> > +#define cpumask_of_cpu(cpu) ({ *get_cpu_mask(cpu); })
> 
> Why use a statement expression here?  Isn't (*get_cpu_mask(cpu)) 
> sufficient?

Yeah, it's sufficient - no strong reasons - it felt a slightly bit more 
correct to isolate the read-only data structure. Not that it makes any 
real difference in practice - it's still possible to take the address of 
get_cpu_mask() and abuse that - gcc will only issue a warning.

But gcc 3.4.5 apparently craps out on this valid use of a gcc extension, 
see the report and the fix at:

  http://lkml.org/lkml/2008/7/29/154

	Ingo
