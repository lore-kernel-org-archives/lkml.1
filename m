Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbXJAPoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbXJAPoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbXJAPor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:44:47 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:53339 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752261AbXJAPop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:44:45 -0400
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory
	Access Control Kernel
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org>
References: <46FEEBD4.5050401@schaufler-ca.com>
	 <20070930011618.ccb8351b.akpm@linux-foundation.org>
	 <Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au>
	 <alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 01 Oct 2007 11:40:39 -0400
Message-Id: <1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 08:07 -0700, Linus Torvalds wrote:
> 
> On Mon, 1 Oct 2007, James Morris wrote:
> > 
> > Merging Smack, however, would lock the kernel into the LSM API.  
> > Presently, as SELinux is the only in-tree user, LSM can still be removed.
> 
> Hell f*cking NO!
> 
> You security people are insane. I'm tired of this "only my version is 
> correct" crap. The whole and only point of LSM was to get away from that.
> 
> And anybody who claims that there is "consensus" on SELinux is just in 
> denial.
> 
> People are arguing against other peoples security on totally bogus points. 
> First it was AppArmor, now this.
> 
> I guess I have to merge AppArmor and SMACK just to get this *disease* off 
> the table. You're acting like a string theorist, claiming that t here is 
> no other viable theory out there. Stop it. It's been going on for too damn 
> long.

You argued against pluggable schedulers, right?  Why is security
different?

Do you really want to encourage people to roll their own security module
rather than working toward a common security architecture and a single
balanced solution (which doesn't necessarily mean SELinux, mind you, but
certainly could draw from parts of it)?   As with pluggable schedulers,
the LSM approach prevents cross pollination and forces users to make
poor choices.

Some have suggested that security modules are no different than
filesystem implementations, but filesystem implementations at least are
constrained by their need to present a common API and must conform with
and leverage the VFS infrastructure.  Different security modules present
very different interfaces and behaviors from one another and LSM doesn't
provide the same kind of common functionality and well-defined semantics
as the VFS.  The result of merging many wildly different security
modules will be chaos for application developers and users, likely
leading them to ignore everything but the least common denominator.
It almost makes more sense to merge no security modules at all than to
have LSM and many different security modules.

If Smack is mergeable despite likely being nothing more than a strict
subset of SELinux (MAC, label-based, should be easily emulated on top of
SELinux or via fairly simple extension to it to make such emulation
simpler or more optimal), then what isn't mergeable as a separate
security module?

-- 
Stephen Smalley
National Security Agency

