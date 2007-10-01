Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbXJAKkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbXJAKkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXJAKkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:40:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39326 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbXJAKkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:40:07 -0400
Date: Mon, 1 Oct 2007 12:39:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@qumranet.com>, Andy Whitcroft <apw@shadowen.org>,
       linux-kernel@vger.kernel.org
Subject: Re: checkpatch and kernel/sched.c
Message-ID: <20071001103958.GB15488@elte.hu>
References: <20070928105345.GC18163@shadowen.org> <20071001064448.GA4239@elte.hu> <20071001003007.4e90143b.akpm@linux-foundation.org> <4700A649.9020700@qumranet.com> <20071001003949.d5c9563e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001003949.d5c9563e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 01 Oct 2007 09:48:25 +0200 Avi Kivity <avi@qumranet.com> wrote:
> 
> > Andrew Morton wrote:
> > >> this is actually a false positive - as the debug code constructs a 
> > >> printk output _without_ \n. So the script should check whether there's 
> > >> any \n in the printk string - if there is none, do not emit a warning. 
> > >> (if you implement that then i think it can remain a warning and does not 
> > >> need to move to CHECK.)
> > >>     
> > >
> > > Yeah, it does that sometimes.  I don't think it's fixable within the scope
> > > of checkpatch.  It needs to check whether some preceding printk which might
> > > not even be in the patch has a \n:
> > >
> > > 	printk(KERN_ERR "foo");
> > > 	<100 lines of whatever>
> > > +	printk("bar\n");
> > >
> > > we're screwed...
> > >
> > >   
> > 
> > Isn't that broken on SMP (or with preemption) anyway?
> 
> Yep.  Or with interrupts...

not if it's a boot-time only debug check before SMP bringup. (as it is 
in sched.c) We could make this intention explicit via a simple 
raw_printk() wrapper to printk, which could be used without KERN_.

	Ingo
