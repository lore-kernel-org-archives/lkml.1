Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532Ab0AKNjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab0AKNjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 08:39:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334Ab0AKNjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 08:39:05 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:40353 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab0AKNjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 08:39:04 -0500
Date: Tue, 12 Jan 2010 00:39:03 +1100
From: Simon Horman <horms@verge.net.au>
To: David Wagner <daw-news@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Message-ID: <20100111133903.GD5198@verge.net.au>
References: <alpine.LRH.2.00.1001110811350.25601@tundra.namei.org>
 <20100110215848.GA26609@elf.ucw.cz>
 <hiduu7$7cg$2@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hiduu7$7cg$2@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 01:29:43AM +0000, David Wagner wrote:
> Pavel Machek  wrote:
> >Scenario 2:
> >
> >Mallory calls disablenetwork, calls sendmail as the first user after
> >boot; sendmail can't deliver anything (its network is disabled), but
> >starts forking and taking requests for other users, DoSing the mail
> >delivery.
> 
> On my system, sendmail is started by trusted boot scripts before
> a "Mallory" would have a chance to do that, so the premise does not
> apply.  I cannot guarantee this is the case on every system, but I'm
> not familiar with any important exceptions.
> 
> >Scenario 3:
> >
> >Mallory calls disablenetwork, then keeps hammering on su, knowing that
> >su can no longer send data to audit subsystem and so he will not get caught.
> 
> And then what?  I don't see how this gets Mallory very far.
> She can keep hammering on su and keep getting denied access to
> root, and it's not going to help her much.

I wondered about that too. But IIRC the stated scenario was that there
was a PAM module involved that spawned a daemon on-demand that communicated
over the network. And if Mallory's invocation of su caused that daemon to
be spawned then it would be inherit disablenetwork. And that would affect
subsequent authentication through that module.

Furthermore the scenario had su access being logged over the network,
so Mallory's maliciousness would not be logged.

> (Note: If root's password is guessable, then there's a fair chance you're
> screwed even without disablenetwork.  If root has a guessable password,
> then Mallory can keep trying until she guesses right, then when she
> gets it right, go and retroactively edit the logs to eliminate the
> log entries if necessary -- if those log entries are ever looked at,
> which is often dubious.  It's very difficult to build a secure system
> if the root password is guessable.  So in my opinion, the root password
> must be unguessable if you want to have a secure system, and we should
> analyze disablenetwork under the assumption that sysadmins have done so.
> And if the system administrators do choose an unguessable password,
> then your Scenario 3 doesn't seem to help Mallory.)
> 
> The impact here seems pretty minor.

I don't think guessable passwords were part of the scenario.

> >You can trivialy make disablenetwork disable setuid exec, too. That
> >will introduce better isolation facilities, but not introduce any new
> >security problems.
> 
> Yup, this is probably the compromise that must be made, for political
> reasons, to get this into the kernel.
> 
> But I just want to document that it's not clear to me that this decision
> is well justified on technical grounds.
