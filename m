Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbXJHVFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbXJHVFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXJHVFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:05:32 -0400
Received: from web36605.mail.mud.yahoo.com ([209.191.85.22]:45500 "HELO
	web36605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752789AbXJHVFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:05:30 -0400
X-YMail-OSG: 52Oj13EVM1k9Ff6u7SBxNu1CsMNgvmyfI2MOEmCmkphmCYZAayWzym8dZIQL0dqPrXHrQL33HQ--
X-RocketYMMF: rancidfat
Date: Mon, 8 Oct 2007 14:05:29 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: "Eric W. Biederman" <ebiederm@xmission.com>, casey@schaufler-ca.com
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serge@hallyn.com>
In-Reply-To: <m1bqb978a8.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <518247.68095.qm@web36605.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Eric W. Biederman" <ebiederm@xmission.com> wrote:

> Casey Schaufler <casey@schaufler-ca.com> writes:
> 
> > --- "Eric W. Biederman" <ebiederm@xmission.com> wrote:
> >
> >
> >> Likely.  Until we have a generalized LSM interface with 1000 config
> >> options like netfilter I don't expect we will have grounds to talk
> >> or agree to a common user space interface.  Although I could be
> >> wrong.
> >
> > Gulp. I know that many of you are granularity advocates, but I
> > have to say that security derived by tweeking 1000 knobs so that
> > they are all just right seems a little far fetched to me. I see
> > it as poopooing the 3rd and most important part of the reference
> > monitor concept, "small enough to analyze". Sure, you can analyse
> > the 1000 individual checks, but you'll never be able to describe
> > the system behavior as a whole.
> 
> Agreed.  I wasn't thinking 1000 individual checks but 1000 different
> capabilities, could be either checks or actions, basically fundamental
> different capabilities.  Things like CIPSO, or the ability to store a
> security label on a file.  I would not expect most security policies
> to use most of them.  Neither do I expect Orange book security to
> necessarily be what people want to achieve with the LSM.   But I
> haven't looked at it enough detail to know how things should be
> factored, in this case I was simply extrapolating from the iptables
> experience where  we do have a very large number of options.

You start getting into some pretty serious mindset battles on
this particular road. For starters, the "hooks" have to be
authoritative if you want them properly switchable, and I'm not
going to show you the scars I got the last time I proposed
authoritative hooks. Next you'll have to deal with defining what is
security behavior and what isn't. You wouldn't believe the debates
over the security implications, or lack thereof, of disk quotas.
Unless you're willing to take the approach that every conditional
in the kernel is a potential security checkpoint you are going to
miss someone's requirement and if you're willing to propose that,
well, let's just say that Linus was right about security people.

> The real point being is that I would be surprised if we could come
> to an agreement of a common user space API when we can't agree on how
> to compile all of the security modules into the kernel and have them
> play nice with each other. 

The API issue cannot be solved if LSMs are going to implement
different behaviors. A reasonable subset can be addressed using
the POSIX P1003.1e/2c MAC definition plus the TSIG APIs. It is
unfortunate that SELinux has gone in a completely different
direction.

> Assuming we can achieve security modules playing nice with each other
> using a mechanism similar to iptables, then what needs to be evaluated
> is the specific table configuration we are using on the system, not
> the full general set of possibilities.  Further I expect that for the
> truly security paranoid we want the option to disable further table
> changes after the tables have been configured.

A specific table configuration sounds an awful lot like a
specific SELinux Policy. Either way, your configuration is
going to be large and may not implement anything rational.

> On another side personally I don't see where the idea comes from that
> you can describe system behavior as a whole without analyzing the
> entire kernel.  Has there been work on a sparse like tool that I'm
> not aware of to ensure the we always perform the appropriate security
> checks on the user/kernel interface boundary?

In addition to tools, there's the labor and money intensive Common
Criteria Evaluation Process.


Casey Schaufler
casey@schaufler-ca.com
