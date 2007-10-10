Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbXJJR6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbXJJR6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 13:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbXJJR5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 13:57:53 -0400
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:49081 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755263AbXJJR5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 13:57:52 -0400
X-YMail-OSG: Oh.XBPYVM1k2PfXr9OT8ACVSntRGKhbvhRqQGasqQH7cA.8haFAGo1Y6znB8XLSH8A--
X-RocketYMMF: rancidfat
Date: Wed, 10 Oct 2007 10:57:51 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: Stephen Smalley <sds@tycho.nsa.gov>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1192031144.2687.55.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <438747.71497.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> On Wed, 2007-10-10 at 07:48 -0600, Eric W. Biederman wrote:
> > Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> > 
> > >> My very practical question:  How do I run selinux in one container,
> > >> and SMACK in another?
> > >
> > > In the LSM model you don't because you could have the same container
> > > objects visible in different contains at the same time and subject to
> > > different LSMs. What does it mean to pass an SELinux protected object
> > > over an AppArmour protected unix domain socket into a SMACK protected
> > > container ?
> > 
> > You raise a good point.  My intuitive definition would go something like
> > this.  In the initial LSM space we would have whatever is the primary
> > LSM and it would always be invoked about everything.   However it
> > would view a single container (no matter what user in that container)
> > as having a single set of permissions.  Then the LSM in the container
> > be asked to further validate accesses, but it would distinguish
> > between users in the container.
> 
> SELinux internally has a notion of a type hierarchy, where a type is
> limited to a subset of its parent's permissions, and one can then
> delegate the ability to manage sub-types via a policy daemon.  But this
> is all handled in userspace; the kernel doesn't care about it.
> 
> Ditto for the modular policy support - that's a userspace construct that
> is ultimately turned into a single coherent policy for the kernel to
> enforce.
> 
> > At this point it looks like if I am going to be effective at doing
> > anything I am going to need to step back watch SMACK get merged and
> > then really look at what the LSM modules are implementing.  Then
> > I can refactor the whole mess and move additional functionality into
> > the LSM to help me achieve other things.

I think that you'll want to be careful with that approach.
Smack and SELinux both implement mandatory access control,
with very different mindsets too be sure, but MAC nonetheless.
Smack doesn't use any LSM hooks that SELinux doesn't. You
aren't going to get a very broad view of potential LSMs
comparing these two. AppArmor and TOMOYO are much more likely
to provide interesting alternative viewpoints. If you want to
get carried away factor the audit code in, too.

> > > Really its the same problem as "I'd like to use different file permission
> > > systems on different process identifiers" and it would be very hard to
> > > get right simply because objects can pass between two different security
> > > models.
> > 
> > Yep.  Although the isolation of a container with a completely
> > different set of namespaces is tight enough that except for people
> > debugging a container from processes in the container from outside the
> > container object exchange essentially doesn't happen.
> > 
> > You do raise a very good question here.  Does an LSM implement a
> > different file permission system?  Or does an LSM implement a firewall
> > between processes?
> > 
> > Certainly selinux seems too programmable to be considered just a
> > different file permission system.  
> 
> A LSM implements a security model, where that model may encompass all
> processes and objects.  SELinux (and Smack) in particular implement
> mandatory access control and thus need to enforce consistent policy over
> all processes and objects based on their security labels.

What he said as far as Smack and SELinux go. Other models need not
encompass all processes and objects.


Casey Schaufler
casey@schaufler-ca.com
