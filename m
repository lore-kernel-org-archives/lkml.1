Return-Path: <linux-kernel-owner+w=401wt.eu-S965337AbXDSVDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965337AbXDSVDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965426AbXDSVDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:03:38 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:49059 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965337AbXDSVDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:03:37 -0400
Subject: Re: AppArmor FAQ
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Wagner <daw-usenet@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f08i81$a11$1@taverner.cs.berkeley.edu>
References: <20070417181016.GA10903@one.firstfloor.org>
	 <Line.LNX.4.64.0704180935100.25495@d.namei> <4626746A.9010701@novell.com>
	 <1177002858.27654.119.camel@moss-spartans.epoch.ncsc.mil>
	 <f08i81$a11$1@taverner.cs.berkeley.edu>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 19 Apr 2007 17:03:35 -0400
Message-Id: <1177016615.27654.293.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 20:08 +0000, David Wagner wrote:
> Stephen Smalley  wrote:
> >Confinement in its traditional sense (e.g. the 1973 Lampson paper, ACM
> >Vol 16 No 10) means information flow control, which you have agreed
> >AppArmor does not and cannot provide.
> 
> Right, that's how I understand it, too.
> 
> However, I think some more caveats are in order.  In all honesty,
> I don't think SELinux solves Lampson's problem, either.
> 
> It is useful to distinguish between "bit-confinement" (confining the
> flow of information, a la Lampson) vs "authority-confinement" (confining
> the flow of privileges and the ability of the untrusted app to cause
> side effects on the rest of the system).
> 
> No Linux system provides bit-confinement, if the confined app is
> malicious.  AppArmor does not provide bit-confinement.  Neither does
> SELinux.  SELinux can stop some kinds of accidental leakage of secrets,
> but it cannot prevent deliberate attempts to leak the secrets that are
> known to malicious apps.  The reason is that, in every system under
> consideration, it is easy for a malicious app to leak any secrets it might
> have to the outside world by using covert channels (e.g., wall-banging).
> In practical terms, Lampson's bit-confinement problem is just not
> solvable.  Oh well, so it goes.
> 
> A good jail needs to provide authority-confinement, but thankfully,
> it doesn't need to provide bit-confinement.  I don't know enough about
> AppArmor to know whether it is able to do a good job of providing
> authority-confinement.  If it cannot, then it deserves criticism on
> those grounds.
> 
> Often the pragmatic solution to the covert channel problem is to ensure
> that untrusted apps are never given access to critical secrets in the
> first place.  They can't leak something they don't know.  This solves the
> confidentiality problem by avoiding any attempt to tackle the unsolvable
> bit-confinement problem.
> 
> Note that the problem of building a good jail is a little different from
> the information flow control problem.

First, I think there is practical value in providing confidentiality
control on the overt channels, even if covert channels remain.  We have
to start somewhere.

Second, information flow is not just a confidentiality issue - see my
other email.  It is quite important as well for integrity, and integrity
corruption in order to assume control over a privileged subject or trick
it into abusing its power can be done solely via a data channel - it
doesn't require explicit flow of authority.

Lastly, if you want to judge AA as a jail mechanism, I think you'll find
it fails there too.  So where does that leave it?  An easy-to-use yet
inadequate solution for MAC or jail.

-- 
Stephen Smalley
National Security Agency

