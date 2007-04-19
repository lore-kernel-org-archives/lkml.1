Return-Path: <linux-kernel-owner+w=401wt.eu-S1767026AbXDSUPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767026AbXDSUPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767025AbXDSUPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:15:50 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:46829 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767024AbXDSUPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:15:49 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: AppArmor FAQ
Date: Thu, 19 Apr 2007 20:08:33 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f08i81$a11$1@taverner.cs.berkeley.edu>
References: <20070417181016.GA10903@one.firstfloor.org> <Line.LNX.4.64.0704180935100.25495@d.namei> <4626746A.9010701@novell.com> <1177002858.27654.119.camel@moss-spartans.epoch.ncsc.mil>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1177013313 10273 128.32.168.222 (19 Apr 2007 20:08:33 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 19 Apr 2007 20:08:33 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley  wrote:
>Confinement in its traditional sense (e.g. the 1973 Lampson paper, ACM
>Vol 16 No 10) means information flow control, which you have agreed
>AppArmor does not and cannot provide.

Right, that's how I understand it, too.

However, I think some more caveats are in order.  In all honesty,
I don't think SELinux solves Lampson's problem, either.

It is useful to distinguish between "bit-confinement" (confining the
flow of information, a la Lampson) vs "authority-confinement" (confining
the flow of privileges and the ability of the untrusted app to cause
side effects on the rest of the system).

No Linux system provides bit-confinement, if the confined app is
malicious.  AppArmor does not provide bit-confinement.  Neither does
SELinux.  SELinux can stop some kinds of accidental leakage of secrets,
but it cannot prevent deliberate attempts to leak the secrets that are
known to malicious apps.  The reason is that, in every system under
consideration, it is easy for a malicious app to leak any secrets it might
have to the outside world by using covert channels (e.g., wall-banging).
In practical terms, Lampson's bit-confinement problem is just not
solvable.  Oh well, so it goes.

A good jail needs to provide authority-confinement, but thankfully,
it doesn't need to provide bit-confinement.  I don't know enough about
AppArmor to know whether it is able to do a good job of providing
authority-confinement.  If it cannot, then it deserves criticism on
those grounds.

Often the pragmatic solution to the covert channel problem is to ensure
that untrusted apps are never given access to critical secrets in the
first place.  They can't leak something they don't know.  This solves the
confidentiality problem by avoiding any attempt to tackle the unsolvable
bit-confinement problem.

Note that the problem of building a good jail is a little different from
the information flow control problem.
