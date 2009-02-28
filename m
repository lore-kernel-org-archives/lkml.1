Return-Path: <linux-kernel-owner+w=401wt.eu-S1757154AbZB1Eqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbZB1Eqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 23:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbZB1Eqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 23:46:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45536 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbZB1Eqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 23:46:32 -0500
Date: Sat, 28 Feb 2009 05:46:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
Message-ID: <20090228044614.GA17082@elte.hu>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com> <20090228030413.5B915FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902271932520.3111@localhost.localdomain> <alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902271948570.3111@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 27 Feb 2009, Linus Torvalds wrote:
> > 
> > Ok, please explain this madness.
> > 
> > The whole crazy IS_COMPAT_TASK dance seems to be too messy 
> > for words. Why? What's going on?
> 
> Ok, I can see what's going on. And it's disgusting.
> 
> Just make everybody do that "is_compat_task()" thing. parisc 
> already did, and you just made x86-64 do so too. The only 
> remaining TIF_32BIT users are powerpc and sparc. So instead of 
> having this insane crud, please just add the trivial 
> definitions to the two remaining places, and we don't have to 
> have this insane mess. Ok?
> 
> It is clear that TIF_32BIT is _not_ a generic flag for 
> 32/64-bit system calls, so let's stop pretending it is, and 
> then having ugly special cases for when it's not.

Seconded.

	Ingo
