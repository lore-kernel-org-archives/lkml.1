Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYBAKDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYBAKDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYBAKC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:02:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35378 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYBAKC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:02:56 -0500
Date: Fri, 1 Feb 2008 11:02:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Nick Piggin <npiggin@suse.de>, heiko.carstens@de.ibm.com,
       linux390@de.ibm.com
Subject: Re: x86 arch updates also broke s390
Message-ID: <20080201100235.GA5519@elte.hu>
References: <20080130011550.GA31853@elte.hu> <20080131003310.GW29368@does.not.exist> <1201772094.18221.32.camel@localhost> <20080201094839.GA29836@elte.hu> <1201859653.27899.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201859653.27899.2.camel@localhost>
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


* Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Fri, 2008-02-01 at 10:48 +0100, Ingo Molnar wrote:
> > > Defining GENERIC_LOCKBREAK in arch/s390/Kconfig takes care of it.
> > I'll 
> > > cook up a patch and queue it in git390.
> > 
> > the one below should do the trick.
> 
> Thanks but I already queued a different one (see below). The other 
> architectures that define GENERIC_LOCKBREAK have the "depends on SMP 
> && PREEMPT" line as well. The line does make sense if you look at the 
> way how spin_is_contended is used, no ?

yes, you are right and your fix is the correct one. Currently, if we 
define GENERIC_LOCKBREAK on UP then we get accesses to the non-existing 
lock->need_lockbreak field.

[ btw., this is really a small uncleanliness in the generic code: it
  should be possible for an architecture to just enable
  GENERIC_LOCKBREAK unconditionally, to indicate that it intends to "let
  the generic code do this". Then the generic code, when it does not
  have a field (such as on UP), should just not access it. But this is a
  small detail. ]

	Ingo
