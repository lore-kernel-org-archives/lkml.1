Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbXGBTcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbXGBTcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbXGBTbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:31:52 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:37287 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753718AbXGBTbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:31:50 -0400
X-YMail-OSG: Whm74nAVM1kgiuUgE8k9xFPBIU79YRsPVSAgmXDGqwY2jnGR90scgG5JdFvFCOjfni5WuK7QTA--
X-RocketYMMF: rancidfat
Date: Mon, 2 Jul 2007 12:31:49 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 00/44] AppArmor security module overview
To: "Eric W. Biederman" <ebiederm@xmission.com>, Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <m1sl86iwkq.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <997814.45234.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Eric W. Biederman" <ebiederm@xmission.com> wrote:



> A couple of random thoughts to mix up this discussion.
> 
> From what I have been able to observer the LSM is roughly firewalls
> rules for in box operations.  All it can do is increase the chances
> you will get -EPERM.

More likely -EACCES, but otherwise not so terribly far off.

> Not being able to take path names into consideration is a current
> deficiency of the LSM.

It's a deficiency of the file system semantics invented by
Kernighan, Thompson, et. al. in the later 1970's, favoring
speed and size of implementation over a pristine namespace.
The LSM is reasonably faithfull in presenting both the good
and the bad of the file system semantics.

> Being exported to modules is another deficiency of the current LSM
> as it seems no serious user of the LSM can exist simply as a kernel
> module.

While that is true of SELinux and AppArmor I would suggest that
is an artifact of the design goals of those two sophisticated
security schemes, not an attribute of the LSM.

> Not being able to mix code from different projects is also a very
> serious limitation of the LSM.  Currently I don't think we can
> build a kernel that supports selinux and any other LSM at the same
> time.  Which horribly limits what we can do with the LSM.

Weeeelllll ... Module stacking has been a contentious issue from
day one of the LSM. Now that SELiunx is proposing to take over
capability processing for it's own purposes it's easy to think
that while other schemes may be up to stacking SELinux ain't gonna.

> So it seems clear that if we are aiming at an ideal solution.  We
> first need to enhance the LSM.

I don't think so. I see much greater social/political problems
than I see technical ones.

> Then merge in the AppArmor
> functionality.  Doing it all in one patch series looks to overwhelming
> for a decent code review.

It's true that the code review for AppArmor has proven difficult.
That's going to be true of any change to the vfs layer, for any
reason. Have someone who was there tell you about the original XFS
proposals some time. Again, it's not LSM's fault.

> That said is anyone interested in making the LSM more like iptables
> with a generic table based rules structure?

That's pretty close to what you get with SELinux, and one reason
why that crowd has advocated that LSM be dumped in favor of SELinux
as the sole interface.

> That way we could fix
> the one true LSM problem and concentrate on simpler pieces that give
> specific bits of interesting functionality.

Sort of. While the SELinux kernel code isn't much, less than 20k lines,
the reference policy it requires is 200k lines, and the smallest policy
I've ever heard anyone claim runs is 600. Yes, you get interesting
functionality, but I don't recall there being many claims that policy
development is simple of late.

> Or at the very least
> be able to compile in multiple different bits of functionality into
> the kernel simultaneously.

The LSM stacking problem, to my mind, is waiting on two modules that
really want to work together and enough thick skin to get past those
who don't want LSM to get better in hopes it will go away.

> I'm really not familiar with the security issues the LSM addresses

It addresses none, it is a tool put in place so that Linus doesn't
have to listen to security people argue over which scheme is better.

> but I do know, it encourages huge incompatible mega solutions,

That's the security marketplace, not LSM.

> and
> it tends to break when I fix real security problems in the kernel.

Please, examples.

> So at this point I am convinced that the LSM is deficient, has very
> limited usability, and seems to be a very fragile firewall structure
> to me.

The "additional" architecture of the LSM, as opposed to the originally
proposed "authoritative" model is responsible for a good deal of the
limited deficiency and uasability, but was considered necessary to
prevent kernel "highjacking". If it's fragile, it's mostly due to the
organic growth of security implementation in the kernel. It is under
utilized, and there are a number of reasons for that, but recent events
are encouraging.


Casey Schaufler
casey@schaufler-ca.com
