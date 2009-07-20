Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbZGTLts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbZGTLts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 07:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZGTLts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 07:49:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39728 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbZGTLtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 07:49:47 -0400
Date: Mon, 20 Jul 2009 13:47:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-cris-kernel@axis.com, Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] x86: NX protection for kernel data
Message-ID: <20090720114746.GA29811@elte.hu>
References: <817ecb6f0907191243m33cc7369qa09a24416fad7769@mail.gmail.com> <20090719201330.GA3186@merkur.ravnborg.org> <817ecb6f0907191709u2abc756cm4bce635ee9b4d0d8@mail.gmail.com> <20090720071007.GA6340@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720071007.GA6340@merkur.ravnborg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > >
> > > But here _edata does not cover until page boundary.
> > > And alignmnet is located outside the output section
> > > definition.
> > > It would be better/more consistent to follow the style you use for .text here.
> > 
> > You are correct. _edata should be the last thing in .data, and
> > alignment should be done before it. However, this brings up a
> > question: was there any specific reason to leave .data.init_task
> > beyond the _edata? Should we move _edata into the the last of the
> > .data.* sections to have poper view of kernel layout?
> 
> .data.init_task is loaded into another segment so this is less trivial.
> Jan Beulich has posted a patch some time ago to address this,
> but it failed when forwardported to the unified layout.
> 
> Btw. -tip (the x86 tree) has a patch included that unify the definition
> of _edata for 32 and 64 bit.
> So the best thing you can do is to base your patch on top of
> the -tip tree.

which can be found at:

  http://people.redhat.com/mingo/tip.git/README

When (re-)submitting the patch please point out the dependency.

	Ingo
