Return-Path: <linux-kernel-owner+w=401wt.eu-S1761390AbXHWLbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbXHWLbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758721AbXHWLa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:30:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36837 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757709AbXHWLa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:30:56 -0400
Date: Thu, 23 Aug 2007 13:30:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Andreas Schwab <schwab@suse.de>, Alan Modra <alan@linuxcare.com.au>,
       David Mosberger-Tang <davidm@hpl.hp.com>
Subject: Re: sched.c: why -fno-omit-frame-pointer?
Message-ID: <20070823113036.GA29740@elte.hu>
References: <20070819141732.GD32595@stusta.de> <p73r6lz1666.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73r6lz1666.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4106]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Adrian Bunk <bunk@kernel.org> writes:
> > 
> > Is the -fno-omit-frame-pointer still required for some reason, or is 
> > this a relict that could be removed?
> 
> It's needed so that the WCHAN /proc display can backtrace one level up 
> out of schedule()

it's not just one level - we'll back out until we are in scheduler 
functions (up to 16 levels). So it will back out of io_schedule() and 
other functions as well.

	Ingo
