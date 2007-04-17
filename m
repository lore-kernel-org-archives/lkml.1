Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbXDQI51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbXDQI51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 04:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXDQI51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 04:57:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57330 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXDQI50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 04:57:26 -0400
Date: Tue, 17 Apr 2007 10:57:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Gene Heskett <gene.heskett@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417085703.GA16645@elte.hu>
References: <20070416220715.GA4071@elte.hu> <200704170053.58611.gene.heskett@gmail.com> <20070417061849.GA12385@elte.hu> <Pine.LNX.4.64.0704170053410.30516@alien.or.mcafeemobile.com> <20070417081857.GD20026@wotan.suse.de> <20070417082628.GD5076@elte.hu> <20070417084153.GE20026@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417084153.GE20026@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> >                   list_add_tail(&p->run_list, &current->run_list);
[...]
> > shouldnt the list_add_tail() be list_add(), so that task pickup sees 
> > the child first? [...]
[...]
> I think that it works because the list we're adding to is not the 
> normal runqueue list head, but the parent's list_head on that 
> runqueue. Which adds the child directly ahead of the parent... I 
> think?

yeah, you are right, i was confused: list_add() adds _after_ the head, 
list_add_tail() adds _before_ the head - and in the middle of the list 
if we do a list_add_tail() it adds before that entry. So everything's 
fine and working as expected :)

	Ingo
