Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYDMH7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYDMH7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 03:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYDMH7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 03:59:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46425 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbYDMH7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:59:04 -0400
Date: Sun, 13 Apr 2008 09:58:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai.lu@sun.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [rfc] hw resource debugging checks (was: Re: x86 git tree broken
	(bisected))
Message-ID: <20080413075845.GJ20332@elte.hu>
References: <200804102159.14563.rjw@sisk.pl> <20080410203800.GA14560@elte.hu> <200804110028.22290.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804112126.29455.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > > btw., Xorg works fine here on a comparable AMD system - but i use 
> > > a rather new distro (Fedora 8) which has Xorg 7.2.
> > 
> > My system is an OpenSUSE 10.3 and it has Xorg 7.2 as well.
> > 
> > I think the problem is somehow related to the Radeon.
> 
> The bisection turned up commit 
> ea1441bdf53692c3dc1fd2658addcf1205629661 "x86: use bus conf in NB conf 
> fun1 to get bus range on, on 64-bit" as the one causing problems.

thanks Rafael for bisecting this!

This was a rather nasty problem - and i'm wondering what else we could 
do to harden our hw resource management code. I'm wondering, is there 
any particular reason why clearly broken resource setup is not detected 
somewhere, automatically, and WARN_ON()-ed about?

for example, in the scheduler code we used to have similar bug patterns 
again and again: architecture code set up scheduler domains incorrectly 
and broke the system in subtle ways. So we added sched_domain_debug() 
which is active under CONFIG_SCHED_DEBUG=y and does a few sanity checks 
and complains if something is wrong. This caught quite a few bugs 
whenever the sched-domains code was modified.

	Ingo
