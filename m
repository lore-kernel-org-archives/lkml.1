Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYJ3Tv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYJ3Tv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYJ3Tvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:51:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32881 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbYJ3Tvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:51:49 -0400
Date: Thu, 30 Oct 2008 20:51:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH][RFC] x86: add non x86 build configuration
Message-ID: <20081030195107.GK27407@elte.hu>
References: <200810281802.m9SI2fYX030138@hera.kernel.org> <20081029091857.GA4414@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0810292139170.6145@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810292139170.6145@gandalf.stny.rr.com>
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

> A lot of developers develop on x86 architectures, and do things that 
> sometimes breaks non x86 archs. This patch adds a debug option to 
> turn off all the CONFIG_HAVE_ options that x86 sets. This allows 
> developers to easily test their code to make sure that it compiles 
> without a lot of the assumptions that x86 makes.
> 
> Note: Recently the ftrace code had an issue where a depend was set
>   by the wrong select, but that select was not set by all archs.
>   This patch catches that issue when compiling on x86.

cool, very nice - thanks Steve!

testing this way scales _far_ better than maintaining a farm of 
cross-compilers.

One important detail: could you please flip around the modality of the 
option? Right now it's CONFIG_SIMULATE_NON_X86_CONFIGURATION, and that 
will be set by allyesconfig. But it has the exact opposite effect of 
an "all yes" config.

So please name it something like CONFIG_STANDARD_X86_FEATURES, and 
also make it depend on CONFIG_EMBEDDED (only allow it to be turned off 
when EMBEDDED is enabled).

ok?

	Ingo
