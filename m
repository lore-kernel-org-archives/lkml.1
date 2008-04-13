Return-Path: <linux-kernel-owner+w=401wt.eu-S1758304AbYDMJUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304AbYDMJUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758195AbYDMJT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:19:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43212 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159AbYDMJTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:19:55 -0400
Date: Sun, 13 Apr 2008 11:19:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [rfc] hw resource debugging checks (was: Re: x86 git tree
	broken (bisected))
Message-ID: <20080413091921.GD28693@elte.hu>
References: <200804102159.14563.rjw@sisk.pl> <20080410203800.GA14560@elte.hu> <200804110028.22290.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl> <20080413075845.GJ20332@elte.hu> <86802c440804130118n669db8d1rf37551550955a084@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804130118n669db8d1rf37551550955a084@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> =====> just sent out one patch to work around that

yep, just applied that one.

> also BIOS is sick to allocate overlapping MMIO to the same link..
> 
> node 0 link 0: io port [1000, ffffff]
> TOM: 0000000080000000 aka 2048M
> node 0 link 0: mmio [e0000000, efffffff]
> node 0 link 0: mmio [a0000, bffff]
> node 0 link 0: mmio [80000000, ffffffff]
> bus: [00,ff] on node 0 link 0
> 
> never thought that BIOS could be so sick.
>  ===> already have one work around, need more test next week.

great!

basically any and all sickness should be assumed both by the hardware 
and by the BIOS, _and_ by Linux architecture code as well as it passes 
stuff to the generic driver layers. So as resources get set up we should 
have resilience all the way and should be on the lookout for signs of 
bugs - because breakages are so hard to track down in this area if they 
go unnoticed during setup.

	Ingo
