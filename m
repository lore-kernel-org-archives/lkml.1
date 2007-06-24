Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbXFXVTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbXFXVTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbXFXVTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:19:09 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:36613 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbXFXVTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:19:08 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
Date: Sun, 24 Jun 2007 21:16:14 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f5mmuu$4d4$1@taverner.cs.berkeley.edu>
References: <46732124.80509@novell.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1182719774 4516 128.32.168.222 (24 Jun 2007 21:16:14 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sun, 24 Jun 2007 21:16:14 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've heard four arguments against merging AA.

Argument 1. SELinux does it better than AA.  (Or: SELinux dominates AA.
Or: SELinux can do everything that AA can.)

Argument 2. Object labeling (or: information flow control) is more secure
than pathname-based access control.

Argument 3. AA isn't complete until it mediates network and IPC.

Argument 4. AA doesn't have buy-in from VFS maintainers.

Let me comment on these one-by-one.

1. I think this is a bogus argument for rejecting AA.  As I remember it,
the whole point of LSM was to allow merging multiple solutions and let
them compete for users on their merit, not to force the Linux maintainers
to figure out which is the best solution.  Let a million flowers bloom.

2. This is argument #1 in a different guise and I find it about as weak.
Pathname-based access control has strengths and weaknesses.  I think
users and Linux distributions are in a better position to evaluate those
tradeoffs than L-K.  Competition is good.

3. This one I agree with.  If you want to sandbox network daemons that
you're concerned might get hacked, then you really want your sandbox to
mediate everything.  Right now the security provided by AA (if that's
what you are using it for) will be limited by its incomplete mediation,
since a knowledgeable motivated attacker who hacks your daemon may be
able to use network or IPC to break out of the sandbox, depending upon
the network and host configuration.  Filesystem mediation alone might be
better than nothing, I suppose, if you're worried about script kiddies,
but it's certainly not a basis for strong security claims.  The state of
the art in sandboxing obviously requires complete mediation, and we've
known that for a decade.

That said, I see filesystem mediation as the hard part.  It's the hardest
part to implement and get right.  It's the hardest part to configure
and the hardest part when it comes to designing usable policy languages.
And I suspect it's the hardest part to get merged into the Linux kernel.
And it often makes sense to start with the hard part.  If AA's approach
to mediating the filesystem is acceptable, I think AA is 2/3rds of the way
to a tool that could be very useful for providing strong security claims.

There's a policy decision here: Do maintainers refuse to merge AA until
it provides complete mediation?  That's a policy matter that's up to the
maintainers.  I have no opinion on it.  However if that is the reason
for rejecting AA it seems like it might be appropriate to come to some
decision now about whether AA's approach to filesystem mediation is
acceptable to Linux developers.  I don't think it would be reasonable
to tell AA developers to go spend a few months developing network and
IPC mediation and then after they do that, to reject the whole thing on
the basis that the approach to filesystem mediation is unacceptable.
That won't encourage development of new and innovative approaches to
security, which doesn't seem like a good thing to me.

4. Way over my head.  I'm not qualified to comment on this aspect.
I suspect this is the argument that ought to be getting the most serious
and thorough discussion, not the irrelevant SELinux-vs-AA faceoff.
