Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXJJPv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXJJPv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 11:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbXJJPvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 11:51:17 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:64637 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753933AbXJJPvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 11:51:15 -0400
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory
	Access Control Kernel
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <m1abqrt706.fsf@ebiederm.dsl.xmission.com>
References: <alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
	 <4702B1D5.5050502@tmr.com>
	 <alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>
	 <4703126D.70703@tmr.com>
	 <alpine.LFD.0.999.0710022050560.3579@woody.linux-foundation.org>
	 <m17im2pc7x.fsf@ebiederm.dsl.xmission.com>
	 <15E46546-914A-4A1E-BB0B-642FDA17396B@mac.com>
	 <m1zlyymaoy.fsf@ebiederm.dsl.xmission.com>
	 <20071008160611.GA7106@vino.hallyn.com>
	 <m11wc5a5gp.fsf@ebiederm.dsl.xmission.com>
	 <20071008180038.GC7106@vino.hallyn.com>
	 <m1hcl11j31.fsf@ebiederm.dsl.xmission.com>
	 <20071008222058.208c6f32@the-village.bc.nu>
	 <m1abqrt706.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 10 Oct 2007 11:45:44 -0400
Message-Id: <1192031144.2687.55.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-10 at 07:48 -0600, Eric W. Biederman wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> >> My very practical question:  How do I run selinux in one container,
> >> and SMACK in another?
> >
> > In the LSM model you don't because you could have the same container
> > objects visible in different contains at the same time and subject to
> > different LSMs. What does it mean to pass an SELinux protected object
> > over an AppArmour protected unix domain socket into a SMACK protected
> > container ?
> 
> You raise a good point.  My intuitive definition would go something like
> this.  In the initial LSM space we would have whatever is the primary
> LSM and it would always be invoked about everything.   However it
> would view a single container (no matter what user in that container)
> as having a single set of permissions.  Then the LSM in the container
> be asked to further validate accesses, but it would distinguish
> between users in the container.

SELinux internally has a notion of a type hierarchy, where a type is
limited to a subset of its parent's permissions, and one can then
delegate the ability to manage sub-types via a policy daemon.  But this
is all handled in userspace; the kernel doesn't care about it.

Ditto for the modular policy support - that's a userspace construct that
is ultimately turned into a single coherent policy for the kernel to
enforce.

> At this point it looks like if I am going to be effective at doing
> anything I am going to need to step back watch SMACK get merged and
> then really look at what the LSM modules are implementing.  Then
> I can refactor the whole mess and move additional functionality into
> the LSM to help me achieve other things.
> 
> > Really its the same problem as "I'd like to use different file permission
> > systems on different process identifiers" and it would be very hard to
> > get right simply because objects can pass between two different security
> > models.
> 
> Yep.  Although the isolation of a container with a completely
> different set of namespaces is tight enough that except for people
> debugging a container from processes in the container from outside the
> container object exchange essentially doesn't happen.
> 
> You do raise a very good question here.  Does an LSM implement a
> different file permission system?  Or does an LSM implement a firewall
> between processes?
> 
> Certainly selinux seems too programmable to be considered just a
> different file permission system.  

A LSM implements a security model, where that model may encompass all
processes and objects.  SELinux (and Smack) in particular implement
mandatory access control and thus need to enforce consistent policy over
all processes and objects based on their security labels.

-- 
Stephen Smalley
National Security Agency

