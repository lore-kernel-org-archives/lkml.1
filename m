Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbYGRJKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbYGRJKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYGRJKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:10:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47644 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369AbYGRJKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:10:30 -0400
Date: Fri, 18 Jul 2008 11:09:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison
	overwritten
Message-ID: <20080718090951.GP6875@elte.hu>
References: <20080717214222.GA29449@elte.hu> <20080718054626.GA3338@2ka.mipt.ru> <84144f020807180202l6c703234ic3a2b57e73a1d89a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020807180202l6c703234ic3a2b57e73a1d89a@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Fri, Jul 18, 2008 at 8:46 AM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> > Does SLUB have a debug check at freeing time? If so, how does it work
> > and why didn't it caught use after free there?
> 
> You can't detect use after free before the object is actually free'd 
> ;-)

yeah, we want to check use-after free at the next allocation point - 
i.e. as late as possible to gather all corruptions that happened 
meanwhile.

We could in theory have a SLUB debug mode where a SCHED_IDLE kernel 
thread would periodically check all free objects (of that CPU) in the 
background to ensure their integrity. That would catch corruptions 
sooner, with a possibly still meaningful context to print out. [right 
after the IRQ or process that corrupts them finishes running]

It could also be hooked into ftrace to print out the last few hundred 
kernel function calls executed prior any corruption. ftrace/slub-debug 
plugin perhaps?

	Ingo
