Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbYFILnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbYFILnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758771AbYFILni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:43:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53470 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758520AbYFILni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:43:38 -0400
Date: Mon, 9 Jun 2008 13:43:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: Q: down_killable() is racy? or schedule() is not right?
Message-ID: <20080609114316.GB5028@elte.hu>
References: <20080603123309.GA472@tv-sign.ru> <b647ffbd0806040409i77dc70bci6a26251ccf76d906@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0806040409i77dc70bci6a26251ccf76d906@mail.gmail.com>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> > This looks racy. If SIGKILL comes in the WINDOW above, the event is 
> > lost. The task will wait for up() or timeout with the fatal signal 
> > pending, and it is not possible to wakeup it via kill() again.
> >
> > This is easy to fix, but I wonder if we should change schedule() 
> > instead.
> 
> [ for what it's worth ] I think, you are definitely right here.
> 
> The schedule() would be the right place to fix it. At the very least, 
> because otherwise callers are obliged to always check for 
> fatal_signal_pending(task) before scheduling with state == 
> TASK_KILLABLE. e.g. schedule_timeout_killable().
> 
> Not very nice, IMHO.

i guess we should fix this in schedule() - is there a patch i could try?

	Ingo
