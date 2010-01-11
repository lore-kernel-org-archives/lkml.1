Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043Ab0AKBVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab0AKBVL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920Ab0AKBVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:21:10 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:56970 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab0AKBVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:21:09 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Date: Mon, 11 Jan 2010 01:21:08 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hidue4$7cg$1@taverner.cs.berkeley.edu>
References: <alpine.LRH.2.00.1001110811350.25601@tundra.namei.org> <20100110215409.GA3705@heat>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1263172868 7568 128.32.153.193 (11 Jan 2010 01:21:08 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 11 Jan 2010 01:21:08 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Stone  wrote:
>Pavel's position is that disablenetwork is likely to permit some attacker
>somewhere to deny network access to some setuid app some day in a way that
>violates some security policy.
>
>He has mentioned specific concern over scenarios like:
>
>   Alice configures PAM auth to 'fail open' by checking login credentials
>   against a restrictive LDAP server and, if the server is unavailable, against
>   a very permissive files database.
>
>   Alice updates her kernel to a version with disablenetwork.
>
>   Mallory calls disablenetwork, calls su -, and vanquishes all.
>
>My position is that better isolation facilities like disablenetwork will
>prevent far more grievous security faults than they (theoretically) cause.
>
>What is your perspective on the matter?

I agree with you.  As I've mentioned before, I think it's an unconvincing
objection.  If Alice sets such a poorly thought-out security policy,
then there are probably many other ways to attack the system, even if
you don't introduce disablenetwork.  (Example atttack #1: Use rlimit
to set the number of file descriptors that can be opened very low, then
call su -.  Example attack #2: DOS the LDAP server, and then call su -.
There are probably many more.)

But it's also true that it's possible to achieve many of the benefits
of disablenetwork in a way that avoids introducing the potential risks
that Pavel is concerned about.  If that's the political compromise
that it takes to get disablenetwork into the kernel, that's still a
step forward.  It'd be better than what we have today.
