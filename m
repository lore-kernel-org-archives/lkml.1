Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbXJHTa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbXJHTa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 15:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbXJHTar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 15:30:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48027 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbXJHTap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 15:30:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
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
Date: Mon, 08 Oct 2007 13:29:53 -0600
In-Reply-To: <20071008180038.GC7106@vino.hallyn.com> (Serge E. Hallyn's
	message of "Mon, 8 Oct 2007 13:00:38 -0500")
Message-ID: <m1tzp12ymm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>
>
> So it's a valid question - do we address these sorts of concerns in
> order to add flexibility, or do we keep things as simple as possible
> and say that it's up to the distro, for instance, or a site local
> security administrator, to define policy, so that flexibility really
> is of very limited use?

I want what we have for the rest of the kernel.  The ability to build
one kernel binary that can do everything and that is configured at
boot time or run time.

My perspective is that if we are going to have an in-kernel labeling
operation running that may be an unconditional function that can
only be enabled or disabled as the system runs.

I'm not after the kind of flexibility that allows us to do things late
in the game, at least not inherently.  I'm after things like being
able to have the checks separated from the labeling, roughly where
are today with iptables.

I'm really after refactoring the problem so that we don't get these
winner take all fights for use of the LSM.  If we can break things
up into small enough factors so that a solution does not all come
from one project then I think we have a chance of getting multiple
security module authors to work together.  Right now we don't seem
to have that kind of cross pollination when using the LSM.

But frankly even the ability to compile in all of the kernel security
modules at compile time and be able to switch between them with a
kernel command line option would be a start.

>> Still while I get the general impression that selinux seems to be
>> very close to a generic solution, and that selinux more or less has
>> the architecture we might want.  I don't get the impression that
>> selinux does this at a level that is open to other people doing
>> interesting things.
>> 
>> So I still ask the question can we move this functionality down to
>> the LSM in a way that will solve the composition problem between
>> multiple security modules?
>
> I've tried :)  At a less semantic and more purely technical level, using
> the stacker module.  After a few years it was finally decided (at
> ksummit 2006) that it simply wasn't useful.
>
> Now perhaps the problem was that I didn't address semantic issues.
> But it does sound to me like what you want is a particular flexible LSM.
> Be it LIDS or SELinux, or something new.

My perspective of the stacker module was that it's problem was it
did not change the problem into a more useable form.  That it didn't
dig deep enough to have useful consequences.  I don't think the goal
was bad.

In one sense what I'm proposing is putting the stacker functionality
into the LSM.  Allowing me to choose after I boot my kernel which of
the compiled in security modules I want to run, and ideally for each
logical kind of security test which order I call the security modules
in if I have more then one. 

>> It really seems to me that the LSM as currently structured creates
>> a large barrier to entry for people who have just this little thing
>> they want to do that is not possible with any existing security
>> module.
>
> Yes and it's been made increasingly so far particularly because of the
> perceived potential for 'abuse'.  So to be curt, allowing people like
> you describe to do something small and interesting is deemed far less
> important than making sure that the small thing they want to do fits
> within the LSM mandate and is not a non-upstream module.
>
> So that is the concern you would need to address before any other.

Communication error.  I can't do small pieces that are useful in an
upstreamable fashion.  That is the problem I see.  I don't care about
out of kernel code.  If we have to compile all of the code into the
kernel and have no exports to modules that is fine with me.

My question is how do we get more interesting functionality into the
kernel.  How do we get the generic kernel support simple and easy to
hack so it can be used by people who have unique unanticipated
problems.

> Still, I do think that selinux policy modules may do just what you want.
> The main obstacle appears to be that the 'base' policy is so huge that
> it's tough to get started to do something small.

Quite likely, or at least I expect that they are close.
I just think we should solve this at the LSM layer if it is at all
possible not in selinux.

> You also might want to check out LIDS, as its rules are set up pretty
> much the way you seem to want.

What is the kernel compile option for that?

Or is LIDS yet another security module that hasn't made it upstream
because the way the problem is currently factored it is nearly
impossible to your code upstream?

Eric
