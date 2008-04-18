Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYDRHU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYDRHU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 03:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYDRHUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 03:20:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56942 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbYDRHUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 03:20:11 -0400
Date: Fri, 18 Apr 2008 09:19:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: 2.6.25-mm1: not looking good
Message-ID: <20080418071945.GA18044@elte.hu>
References: <20080417160331.b4729f0c.akpm@linux-foundation.org> <20080417224908.67cec814@laptopd505.fenrus.org> <20080417231038.72363123.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417231038.72363123.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 17 Apr 2008 22:49:08 -0700 Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Thu, 17 Apr 2008 16:03:31 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > 
> > > I repulled all the trees an hour or two ago, installed everything on
> > > an 8-way x86_64 box and:
> > > 
> > > 
> > > stack-protector:
> > > 
> > > Testing -fstack-protector-all feature
> > > No -fstack-protector-stack-frame!
> > > -fstack-protector-all test failed
> > 
> > do you have a stack-protector capable GCC? I guess not.
> > 
> > This is a catch-22. You do not have stack-protector. Should we make that 
> > a silent failure? or do you want to know that you don't have a security
> > feature you thought you had.... complaining seems to be the right thing to do imo.
> 
> A #warning sounds more appropriate.

this warning is telling the user that the security feature that got 
enabled in the .config is completely, 100% not working due to using a
stack-protector-incapable GCC.

it's analogous as if there was a bug in gcc that made SELinux totally 
ineffective in some mitigate-exploit-damage scenarios. No harm done on a 
perfectly bug-free system - but once a bug happens that SELinux should 
have mitigated, the breakage becomes real. Having a prominent warning is 
the _minimum_.

having a build failure would be nice too because this is a build 
environment problem. (not a build warning - warnings can easily be 
missed because on a typical kernel build there's so many false positives 
that get emitted by various other warning mechanisms) Arjan?

	Ingo
