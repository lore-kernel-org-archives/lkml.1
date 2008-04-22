Return-Path: <linux-kernel-owner+w=401wt.eu-S1764886AbYDVTNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764886AbYDVTNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762625AbYDVTM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:12:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53446 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761712AbYDVTM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:12:57 -0400
Date: Tue, 22 Apr 2008 21:12:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       npiggin@suse.de, peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function
	calls
Message-ID: <20080422191213.GA6370@elte.hu>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-3-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804221157220.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804221157220.2779@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> [ Ingo added to cc, since this is x86-specific ]
> 
> On Tue, 22 Apr 2008, Jens Axboe wrote:
> > +++ b/arch/x86/kernel/apic_32.c
> > @@ -1357,6 +1357,10 @@ void __init smp_intr_init(void)
> >  
> >  	/* IPI for generic function call */
> >  	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
> > +
> > +	/* IPI for single call function */
> > +	set_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
> > +				call_function_single_interrupt);
> 
> Ok, one more comment..
> 
> Why bother with separate vectors for this?

this was my first question a month ago when Jens/Nick first submitted it
:)

> Or is it just a performance optimization? [...]

yes and i gave in - Nick and Jens wants to do some crazy stuff and they 
had the numbers. Here's the previous discussion:

  http://lkml.org/lkml/2008/2/27/125

	Ingo
