Return-Path: <linux-kernel-owner+w=401wt.eu-S937224AbYD1V4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937224AbYD1V4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935717AbYD1V4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:56:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42571 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935666AbYD1V4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:56:11 -0400
Date: Mon, 28 Apr 2008 23:55:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
Message-ID: <20080428215555.GB16153@elte.hu>
References: <1209327591.14173.74.camel@brick> <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org> <alpine.LFD.1.10.0804281534530.3261@apollo.tec.linutronix.de> <alpine.LFD.1.10.0804280924270.3119@woody.linux-foundation.org> <alpine.LFD.1.10.0804281845250.3261@apollo.tec.linutronix.de> <alpine.LFD.1.10.0804280953570.3119@woody.linux-foundation.org> <alpine.LFD.1.10.0804282038160.3261@apollo.tec.linutronix.de> <alpine.LFD.1.10.0804281233090.3119@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804281233090.3119@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So we do have cases where the inlines are obviously worth it. But in 
> general, I think we should try to move things from the header files 
> into *.c files unless there is a really clear reason for keeping it 
> that way.

there's another benefit, and in asm-x86 we prefer to move inlines to .c 
files even in borderline cases because it simplifies the type 
dependencies: not having to fully define all types at the function 
prototype site avoids include file dependency hell.

Putting things like a task struct dereference into a lowlevel inline 
file easily causes dependency problems that causes people to use macros 
instead - which have their own set of readability and side-effect 
problems.

a third argument is that inlines seldom get smaller. So if they are 
borderline and we move them into a .c, and later on the function gets 
larger, no harm is done. But if we keep the inline in a .h in the 
borderline case and we grow the inline later on, the whole kernel bloats 
in a multiplied way, without any apparent direct feedback to the 
developer that something wrong and harmful just happened.

	Ingo
