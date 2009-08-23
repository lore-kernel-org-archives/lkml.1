Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZHWIsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZHWIsH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 04:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZHWIsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 04:48:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45133 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbZHWIsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 04:48:04 -0400
Date: Sun, 23 Aug 2009 10:47:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, dwalker@fifo99.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] timekeeping: Increase granularity of
	read_persistent_clock()
Message-ID: <20090823084740.GA7651@elte.hu>
References: <20090814134811.013873340@de.ibm.com> <tip-d4f587c67fc39e0030ddd718675e252e208da4d7@git.kernel.org> <20090822103252.GA32369@elte.hu> <20090822171540.1220f50d@skybase> <20090822153346.GA3313@elte.hu> <19088.47213.327897.703458@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19088.47213.327897.703458@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > > I overlooked a case in the powerpc version of read_persistent_lock.
> > > New patch:
> > 
> > the patches are already committed and this patch doesnt apply - 
> > mind sending a delta fix against tip:master:
> 
> Is that going to leave us with a bisection breakage on powerpc 
> once this stuff goes upstream?  If so please fold the fix into the 
> original patch.

Do you ask Linus to rebase the upstream kernel as well, if the 
powerpc or x86 build happens to break? There's more than a dozen 
such cases per development cycle triggering on my tests alone. If 
not, why not?

The thing is, we'll probably redo this portion of the timer tree as 
i found other problems in testing, but generally the disadvantages 
of a build breakage with a very small non-bisectability window has 
to be weighed against the disadvantages of a rebase (which are 
significant).

The equation does not automatically flip in favor of a rebase as you 
seem to suggest - in fact it generally goes _against_ a rebase.

	Ingo
