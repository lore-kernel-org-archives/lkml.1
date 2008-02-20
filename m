Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbYBTKQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbYBTKQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYBTKQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:16:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41696 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbYBTKQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:16:17 -0500
Date: Wed, 20 Feb 2008 11:15:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: Pavel Machek <pavel@ucw.cz>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] suspend/resume self-test
Message-ID: <20080220101542.GC3881@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz> <20080219101116.GA2202@elf.ucw.cz> <20080219144328.GD21176@elte.hu> <200802191112.57616.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802191112.57616.david-b@pacbell.net>
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


* David Brownell <david-b@pacbell.net> wrote:

> > nowhere did i suggest that it should be default-enabled ...
> 
> The patch you asked to be merged *DID* have it be default-enabled! So 
> you did more than just "suggest"... if that option is enabled in 
> Kconfig, this test is always forced on and it will cause failures on 
> systems where STR has never worked.

i think you dont understand what "default enabled" means in this 
context. Default enabled means the Kconfig entry has a "default y" line 
- which it did not have in the patch i sent.

if a tester enables the .config option then it is very much expected to 
be triggered, just like the other .config debug options. Of course, the 
tester specifically enabled it, so that's what we want to happen. Not 
some other "yes_i_really_meant_it" boot option ... There can also be 
_another_ .config option that turns off the 'run by default' property - 
but if someone selects the _default off_ feature and enables it, just 
like i did, then the feature is very much expected to run.

you really seem to have deep misunderstandings about how testers use 
Linux, what it takes to build up a proper debug infrastructure and how 
to utilize all these things to make Linux better. You come from the 
embedded world where everything is configured together specifically, 
where people know what they are using and were every feature is well 
accounted for. But you seem to have little insight into how 
distributions utilize kernel features and what it takes to accept the 
help of testers who dont know the field that well but still want to help 
out - as long as we let them.

These are well-established practices we use in all other debug features 
that help Linux today, and what you are asking for is weird, unusual and 
wrong. Please take a look at how all the other debug stuff works. Rule
#1: testers dont have to beg the kernel for 1 hour and have to write 2
patches to let the test code be run finally ... ;-) This isnt even about 
any nuances where reasonable people might disagree, this is really basic 
testing-101 stuff.

	Ingo
