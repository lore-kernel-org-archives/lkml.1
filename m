Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbXJIN5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbXJIN5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 09:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbXJIN5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 09:57:21 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:55908 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752137AbXJIN5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 09:57:20 -0400
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory
	Access Control Kernel
From: Stephen Smalley <sds@tycho.nsa.gov>
To: casey@schaufler-ca.com
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <287140.92685.qm@web36611.mail.mud.yahoo.com>
References: <287140.92685.qm@web36611.mail.mud.yahoo.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 09 Oct 2007 09:52:06 -0400
Message-Id: <1191937926.24970.69.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-08 at 10:31 -0700, Casey Schaufler wrote:
> --- "Serge E. Hallyn" <serge@hallyn.com> wrote:
> 
> > Quoting Casey Schaufler (casey@schaufler-ca.com):
> > > ...
> > > Good suggestion. In fact, that is exactly how I approached my
> > > first two attempts at the problem. What you get if you take that
> > > route is an imposing infrastructure that has virually nothing
> > > to do and that adds no value to the solution. Programming to the
> > > LSM interface, on the other hand, allowed me to drastically reduce
> > > the size and complexity of the implementation.
> > 
> > (tongue-in-cheek)
> > 
> > No no, everyone knows you don't build simpler things on top of more
> > complicated ones, you go the other way around.  So what he was
> > suggesting was that selinux be re-written on top of smack.
> > 
> > :)
> 
> I'm not sure how seriously anyone ought to take what I'm about to
> outline. Please feel free to treat it with as much or as little
> reverence as you choose.
> 
> How to implement SELinux starting from Smack.
> 
> You'll need to break up the current rwxa accesses into a set
> that matches the current SELinux set. Assign each a letter and
> a "MAY_ACTION" #define.
> 
> You'll need a mapping for domain transitions, something like:
> 
>      subject-label program-label new-subject-label
> 
> This will require bprm hooks that aren't there now.
> 
> Additional hooks will need to be filled out as Smack does not
> add access control to things that aren't objects or actions that
> aren't accesses. Treat these as if they are accesses to objects
> and there shouldn't be too much trouble.
> 
> Do something about the linear search for subject/object label pairs.
> With the larger label set searching will become an issue.
> 
> Audit integration, too. The networking code will require some work
> for ipsec. The interfaces are pretty clean, Smack isn't using it
> because the CIPSO interface is simpler, not because there's any
> real problem with it.
> 
> I wouldn't expect the whole thing to be more than a couple week's
> work for someone who really wanted to do it.

Note that Serge said "SELinux re-written on top of Smack", not "rewrite
Smack to be more like SELinux".  I don't believe the former is even
possible, given that Smack is strictly less expressive and granular by
design.  Rewriting Smack to be more like SELinux should be possible, but
seems like more work than emulating Smack on SELinux via policy, and to
what end?

-- 
Stephen Smalley
National Security Agency

