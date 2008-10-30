Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbYJ3U6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbYJ3U6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYJ3U6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:58:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51586 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbYJ3U6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:58:04 -0400
Date: Thu, 30 Oct 2008 21:57:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH][RFC] x86: add non x86 build configuration
Message-ID: <20081030205712.GC24626@elte.hu>
References: <200810281802.m9SI2fYX030138@hera.kernel.org> <20081029091857.GA4414@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0810292139170.6145@gandalf.stny.rr.com> <20081030195107.GK27407@elte.hu> <alpine.DEB.1.10.0810301602380.19996@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810301602380.19996@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Thu, 30 Oct 2008, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > One important detail: could you please flip around the modality of the 
> > option? Right now it's CONFIG_SIMULATE_NON_X86_CONFIGURATION, and that 
> > will be set by allyesconfig. But it has the exact opposite effect of 
> > an "all yes" config.
> 
> Hmm, I made it a choice, with the "Normal Config" as default, so 
> that allyesconfig will not set it. Does it get set for you when you 
> do an allyesconfig?  I had to do the following:

hm, indeed.

Still ... the Kconfig glue looks a bit weird - it's almost never a 
good idea to put 'NOT' (or any other logic operator) into a config 
name. Why not make this CONFIG_STANDARD_X86_FEATURES and allow it to 
be disabled when CONFIG_EMBEDDED is enabled? This way it's not just a 
debug thing but also a kernel sizing feature.

	Ingo
