Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYFFOKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYFFOKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbYFFOKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:10:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50228 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbYFFOKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:10:09 -0400
Date: Fri, 6 Jun 2008 16:09:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: make generic arch support NUMAQ v2
Message-ID: <20080606140947.GA29104@elte.hu>
References: <200806050309.11197.yhlu.kernel@gmail.com> <200806051714.54932.yhlu.kernel@gmail.com> <86802c440806051754l5c921437o15ab12882f42a25d@mail.gmail.com> <20080606061744.GA6399@uranus.ravnborg.org> <86802c440806052327v14428d4dhf54e13874c1f0a5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806052327v14428d4dhf54e13874c1f0a5a@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > It is my understanding that special support for NUMAQ should die, so 
> > the only remaning usage of CONFIG_NUMAQ is if set to select 
> > GENERICARCH. In other words that you should not use CONFIG_NUMAQ 
> > anywhere in the code but solely rely on GENERICARCH and then do 
> > runtime detection of the other things.
> 
> in case someone don't want to build that special numaq code in.
> 
> I think we should make ES7000, Summit depend to GENERICARCH too.

correct. If someone wants more restricted support, pure CONFIG_X86_PC 
should do that fine.

also, even GENERICARCH should have as little Kconfig implications as 
possible. I.e. before your cleanups the subarch code was used to 
implement something very non-PC, and it was done build-time - which is a 
PITA in terms of testing and in terms of general complexity. We want to 
remove those complications and eventually we want to remove the subarch 
code altogether. (without narrowing hw support of course)

	Ingo
