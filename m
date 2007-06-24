Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbXFXVsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbXFXVsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXFXVsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:48:31 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:55936 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbXFXVsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:48:30 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
Date: Sun, 24 Jun 2007 21:45:34 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f5molu$63t$1@taverner.cs.berkeley.edu>
References: <46732124.80509@novell.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1182721534 6269 128.32.168.222 (24 Jun 2007 21:45:34 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sun, 24 Jun 2007 21:45:34 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris  wrote:
>A. Pathname labeling - applying access control to pathnames to objects, 
>rather than labeling the objects themselves.
>
>Think of this as, say, securing your house by putting a gate in the street 
>in front of the house, regardless of how many other possible paths there 
>are to the house via other streets, adjoining properties etc.
>
>Pathname labeling and mediation is simply mediating a well-known path to 
>the object.  In this analogy, object labeling would instead ensure that 
>all of the accessible doors, windows and other entrances of the house were 
>locked, so that someone trying to break in from the rear alley would 
>not get in simply by bypassing the front gate and opening any door.
>
>What you do with AppArmor, instead of addressing the problem, is just 
>redefine the environment along the lines of "set your house into a rock 
>wall so there is only one path to it".

Harrumph.  Those analogies sound good but aren't a very good guide.

Let's take a concrete example.  Consider the following fragment of a
policy for Mozilla:
    allow ~/.mozilla
    deny ~
Ignore the syntax; the goal is to allow Mozilla to access files under
~/.mozilla but nothing else under my home directory.  This is a perfectly
reasonable policy fragment to want to enforce.  And enforcing it in
the obvious way using pathname-based access control is not a ridiculous
thing to do.

Yes, in theory, there could always be crazy symlinks or hardlinks
from somewhere under ~/.mozilla to elsewhere in my home directory that
would cause this policy to behave in ways different from how I desired.
In theory.  But in practice this is "pretty good": good enough to be
useful in the real world.  In the real world I don't have any symlinks
like that under my ~/.mozilla directory, and I'm not really worried
about unconfined processes accidentally creating a symlink under there
against my wishes.  It'd be good enough for me.

Yes, pathname-based models have limitations and weaknesses, but don't
overplay them.  For some purposes they are a very simple way of specifying
a desired policy and they work well enough to be useful -- a darn site
better than what we've got today.  If your goal is "ease of use" and
"better than what many users are using today", it's not an unreasonable
approach.  Time will tell whether it's the best solution, but it's not
obviously wrong.

And I think that's the criteria: If you want to argue that the very
idea of pathname-based access control so bogus that no approach to
pathname-based security should be merged, then you should have to argue
that it is obviously wrong and obviously not useful to users.  I don't
think that burden has been met.

>B. Pathname access control as a general abstraction for OS security.

This strikes me as a strawman.  Pathname-based access control is an
abstraction for mediating the *filesystem*.  Who says it has to be the
way you mediate the network or IPC?

>To quote from:
>
>http://www.novell.com/linux/security/apparmor/
>
>  "AppArmor gives you network application security via mandatory access 
>   control for programs, protecting against the exploitation of software 
>   flaws and compromised systems. AppArmor includes everything you need to 
>   provide effective containment for programs (including those that run as 
>   root) to thwart attempted exploits and even zero-day attacks."
>
>This is not accurate in any sense of the term containment of mandatory 
>access control that I've previously encountered.

You bet.  The claim you quote is totally bogus.

Bad marketers, no biscuit for you.

>The fact that it doesn't work as expected does not arise simply from 
>missing features or being "different".  It arises from the design of the 
>system, which uses a pathname abstraction, where, even if we agree to 
>ignore issue (1) above, still does not work, because only filesystem 
>interactions are mediated.

Disagree.

>The "simple" policy that users can so effortlessly manipulate is simple 
>because it is wrong, and deliberately so.
>
>The design of the AppArmor is based on _appearing simple_, but at the 
>expense of completeness and thus correctness.

Based on my experience with Janus, my expectation is the policy isn't
going to get that much more complicated when they add mediation of
network and IPC access.  I suspect it will stay almost as simple.
