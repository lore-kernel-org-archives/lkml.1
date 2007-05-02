Return-Path: <linux-kernel-owner+w=401wt.eu-S1030901AbXEBGqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030901AbXEBGqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030923AbXEBGqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:46:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40641 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030901AbXEBGqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:46:43 -0400
Date: Wed, 2 May 2007 08:45:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070502064510.GB27210@elte.hu>
References: <20070501212223.GA29867@elte.hu> <1178087834.8640.7.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178087834.8640.7.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > As usual, any sort of feedback, bugreport, fix and suggestion is 
> > more than welcome,
> 
> Greetings,
> 
> I noticed a (harmless) bounds warning triggered by the reduction in 
> size of array->bitmap.  Patchlet below.

thanks, applied! Your patch should also speed up task selection of RT 
tasks a bit. (the patch removes ~40 bytes of code). And on 64-bit we now 
fit into 2x 64-bit bitmap and thus are now down to two Find-First-Set 
instructions. Nice :)

	Ingo
