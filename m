Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbXJEURv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbXJEURv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760974AbXJEURn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:17:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53748 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760761AbXJEURm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:17:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: casey@schaufler-ca.com, Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
References: <63003.78064.qm@web36613.mail.mud.yahoo.com>
	<1191609774.891.123.camel@moss-spartans.epoch.ncsc.mil>
Date: Fri, 05 Oct 2007 14:11:26 -0600
In-Reply-To: <1191609774.891.123.camel@moss-spartans.epoch.ncsc.mil> (Stephen
	Smalley's message of "Fri, 05 Oct 2007 14:42:54 -0400")
Message-ID: <m1ir5liaoh.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley <sds@tycho.nsa.gov> writes:

> On Fri, 2007-10-05 at 09:27 -0700, Casey Schaufler wrote:
>> --- Kyle Moffett <mrmacman_g4@mac.com> wrote:
>> 
>> > On Oct 05, 2007, at 00:45:17, Eric W. Biederman wrote:
>> > > Kyle Moffett <mrmacman_g4@mac.com> writes:
>> > >
>> > >> On Oct 04, 2007, at 21:44:02, Eric W. Biederman wrote:

>> > > Yes. Currently with containers we are taking that one step farther  
>> > > as that solves a wider set of problems.

>> > So containers are exclusive subsets of "the system" while LSM should  
>> > be about non-exclusive information restriction.
>> 
>> Yes. Isolation is a much simpler problem than access control.

Yes.  Simple isolation is a different and simpler problem that can be
solved with the LSM hooks today.  I brought it up for the contrast in
what the LSM hooks can be useful for.  Hopefully allowing the LSM
hooks to be perceived as something other then just hacks for selinux.

Using a security module for isolation is currently uninteresting
because it would preclude use of a security module like selinux or
smack, because we can have at most one security module at a time
loaded.

I have seen several other places where a custom LSM would have
been a good solution but because we don't allow composition solving
a little problem with the LSm is not interesting enough to allow
the code to be merged.

So I see the current structure of the LSM hooks as hindering
development.

>> > >
>> > > I think it is firmly established that selling SElinux to everyone  
>> > > is politically untenable.  However enhancing the LSM (even if it is  
>> > > mostly selinux code movement down a layer) I think can be sold.
>> 
>> That would be silly. Smack uses a significantly smaller set of hooks
>> than SELinux requires and still does interesting things. We went through
>> the "replace LSM with the SELinux interface" exercise a couple years
>> ago, I would hate to have to regurgitate all those discussions.
>
> I don't think Eric is proposing replacing LSM with the SELinux interface
> as it exists today, but rather making LSM more Netfilter-like and
> radically refactoring SELinux (and any other security module) to consist
> of a chain of smaller modules that are more general and reusable, and
> that can be composed and applied in interesting ways via an
> iptables-like interface.  I'm not sure what that would look like
> exactly, but it seems reasonable to explore.

Exactly refactoring security modules into small simple reusable chunks
to allow reuse.  It might look something like selinux chains or it
might not.  Inherently it needs to expose what you can do at the
existing hook points, and it needs to allow usage by different modules
that are compiled in at the same time.

It is certainly the case that you would not need to use all of the
existing hooks to get something done.

> One of the things left unresolved with LSM is userland API, and it does
> involve more than just returning EPERM or EACCES to applications.  You
> already have patched ls and sshd programs, and have acknowledged the
> need for more userland modifications to ultimately achieve your own
> goals.  If LSM is going to succeed in the kernel, then ultimately you
> need some common API for userland so that you don't need separate
> versions of ls, ps, sshd, etc for Smack vs SELinux vs. whatever.

Likely.  Until we have a generalized LSM interface with 1000 config
options like netfilter I don't expect we will have grounds to talk
or agree to a common user space interface.  Although I could be
wrong.

Eric
