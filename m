Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbYJ0Lwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbYJ0Lwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYJ0LwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:52:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57742 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYJ0LwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:52:22 -0400
Date: Mon, 27 Oct 2008 12:51:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, lethal@linux-sh.org,
       paulus@samba.org, benh@kernel.crashing.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: [GIT PULL] s390 updates for 2.6.28-rc1
Message-ID: <20081027115146.GE5631@elte.hu>
References: <20081024105049.GC4620@osiris.boeblingen.de.ibm.com> <20081024113724.GA21375@elte.hu> <1225045593.14057.11.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225045593.14057.11.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Fri, 2008-10-24 at 13:37 +0200, Ingo Molnar wrote:
> > * Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > 
> > > The s390 vdso preparation patch "arch_setup_additional_pages argument" 
> > > touches other architectures (x86, sh and powerpc):
> > > 
> > > arch_setup_additional_pages currently gets two arguments, the binary 
> > > format descripton and an indication if the process uses an executable 
> > > stack or not. The second argument is not used by anybody, it could be 
> > > removed without replacement.
> > 
> > hm, this is the first time i've seen this change,
> 
> The code is relatively new and I planned it for the merge window for 
> 2.6.29. I still have to nag our performance team to do some tests 
> with it.

okay, then i'm confused, the subject line says v2.6.28:

    [GIT PULL] s390 updates for 2.6.28-rc1

(i have still no objections to those small x86 bits.)

> >  #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
> >  extern int arch_setup_additional_pages(struct linux_binprm *bprm,
> > -                                      int executable_stack);
> > +                                      int uses_interp);
> > 
> > why didnt you just add a new uses_interp argument?
> 
> I could have but I noticed at the same time that executable_stack is 
> unused. If somebody finds a need for the executable_stack argument 
> it can easily re-added but I can't think of a use for it. Ergo I 
> removed it.
> 
> > executable_stack is passed in to potentially enable architectures 
> > to be aware of how conservative/legacy the address-space of the 
> > binary is - whether to randomize the vdso, etc. exec-shield used 
> > to take advantage of that.
> 
> What has address space layout / randomization to do with 
> executable_stack? You lost me there.

it's just a historic/quirky connection (non-executable stack was the 
first and biggest step towards a more flexible address space layout) - 
you were correct to have it cleaned up.

	Ingo
