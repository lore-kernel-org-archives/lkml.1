Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbYCYUP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbYCYUP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 16:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYCYUPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 16:15:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47608 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035AbYCYUPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 16:15:21 -0400
Date: Tue, 25 Mar 2008 21:15:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 019/148] include/asm-x86/cpufeature.h: checkpatch
	cleanups - formatting only
Message-ID: <20080325201509.GE15330@elte.hu>
References: <1206259443-13210-1-git-send-email-joe@perches.com> <1206259443-13210-20-git-send-email-joe@perches.com> <20080325153053.GB20898@elte.hu> <1206469633.4845.94.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206469633.4845.94.camel@localhost>
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


* Joe Perches <joe@perches.com> wrote:

> On Tue, 2008-03-25 at 16:30 +0100, Ingo Molnar wrote:
> > > +#define X86_FEATURE_REP_GOOD     _CF(3, 16) /* rep microcode works well
> > > +					     * on this CPU */
> > that is crap too ...
> 
> the _CF or the newly line-broken comment?

both :) Line-breaking in macros isnt done like that. And the _CF thing:

 +#if defined _CF
 +#undef _CF
 +#endif
 +#define _CF(word, bit) ((word) * 32 + (bit))

looks quite ugly - either we have such a macro in which case it should 
be a generic define somewhere that doesnt override anything else, or we 
shouldnt do it.

I also had to fix some other typos that broke the 64-bit build. I ended 
up skipping the whole cpufeatures.h patch - could you please re-do and 
re-send it?

	Ingo
