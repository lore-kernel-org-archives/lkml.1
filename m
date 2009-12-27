Return-Path: <linux-kernel-owner+w=401wt.eu-S1751258AbZL0U2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbZL0U2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 15:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbZL0U2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 15:28:24 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:33375 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZL0U2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 15:28:24 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: A basic question about the security_* hooks
Date: Sun, 27 Dec 2009 20:28:23 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hh8g17$qlu$1@taverner.cs.berkeley.edu>
References: <20091225055034.GA374@us.ibm.com> <20091227031631.GA17629@hallyn.com> <200912271302.JBH64754.JtLMFQVOSOFFHO@I-love.SAKURA.ne.jp> <22669.1261911374@localhost>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1261945703 27326 128.32.153.193 (27 Dec 2009 20:28:23 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sun, 27 Dec 2009 20:28:23 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Sure, it's *possible* to create a system where you've loaded 2 security systems
>and have it work.  But the general consensus is that if you're running one
>system and want to run a second, it's easier to ask yourself *why* you want to
>run the second, and see if there's some way to get the added functionality
>supported in the first system.

Read the thread, where you can find the answer *why*.  The question has
already been answered.  As far as I can tell, the answer is not what you
are presuming.  As far as I can tell, the answer is, the original poster
wants a simple, fairly high-assurance, easy-to-configure way to disable
network access for certain processes, to facilitate privilege-separated
software architectures.  That's a great goal.  It's a goal that is not
easily supported by, say, SELinux.

So now suppose you are starting with a system that's running SELinux,
and you want to add functionality to meet the original poster's goals.
What do you do?  You've basically got two choices: (a) hardcode it in,
ignoring the LSM hooks; or (b) build a little LSM that enforces this
using the LSM hooks.

If you go with approach (a), Alan Cox gives you a hard time and says
"this ought to be done with a LSM".

If you go with approach (b), you're dead in the water: because people
have a kneejerk reaction against ever allowing composition of LSMs,
there's no way to use your own little LSM on your system (without
turning off SELinux or whatever LSM was already installed -- and
this cure is arguably worse than the disease).

It's a catch-22.  What are you supposed to do?  The poster has asked for
your advice about the best way to accomplish his goals, and is open to
any approach that meets these goals.  So far all I have heard is "No".
I think folks could be more constructive.

I think people have committed a logical fallacy here: they've reasoned
that in the general case, composition is hard to reason about, therefore
all composition must be bad.  The "therefore" does not follow.

>The basic problem is that large complete MAC systems like TOMOYO, SELinux,
>Smack, or AppArmor are complicated.  In addition, they are unable to look at
>each other's policies to detect potential conflicts. As a result, although
>it's probably *possible* to create a system that loads both a TOMOYO and
>an SELinux policy, it's hazardous:

But that's irrelevant.  Re-read the thread.  The poster doesn't want
to compose TOMOYO+SELinux.  He wants to compose SELinux+his little LSM.
Or AppArmor+his little LSM.  Or (whatever LSM was already installed)+his
little LSM.  TOMOYO+SELinux is a strawman.

The fact that composing TOMOYO+SELinux is hazardous says little or nothing
about the merits of composing SELinux+his little LSM.  His little LSM
is, well, little, and as a result likely to be noticeably easier to
reason about.  Sure, there may be tricky corner cases.  Sure, there
could be subtle hazards lurking here.  But don't jump immediately to
the worst case when the worst case isn't what's at issue here.

Yes, composition is hard.  Look, software is hard.  We suck it up
and deal with it.  We make the best of it.  We choose architectures
that minimize the likelihood of breakage.  (And in many ways that is
the kind of thing the original poster has done, and is open to doing.)
But we don't give up and say, oh forget about this software stuff,
it's too hard, let's go to the beach instead.
