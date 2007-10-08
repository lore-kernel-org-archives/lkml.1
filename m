Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbXJHRbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbXJHRbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbXJHRbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:31:31 -0400
Received: from web36611.mail.mud.yahoo.com ([209.191.85.28]:42829 "HELO
	web36611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753713AbXJHRb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:31:29 -0400
X-YMail-OSG: pTIErZcVM1lKd.NTTAhX5Pnvnd3vDoQo0xp8GVnBmad8l4QmW7DG3CB5KoUiGJLtsL2dQCCIPA--
X-RocketYMMF: rancidfat
Date: Mon, 8 Oct 2007 10:31:26 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: "Serge E. Hallyn" <serge@hallyn.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Serge E. Hallyn" <serge@hallyn.com>
In-Reply-To: <20071008161835.GB7106@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <287140.92685.qm@web36611.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Serge E. Hallyn" <serge@hallyn.com> wrote:

> Quoting Casey Schaufler (casey@schaufler-ca.com):
> > ...
> > Good suggestion. In fact, that is exactly how I approached my
> > first two attempts at the problem. What you get if you take that
> > route is an imposing infrastructure that has virually nothing
> > to do and that adds no value to the solution. Programming to the
> > LSM interface, on the other hand, allowed me to drastically reduce
> > the size and complexity of the implementation.
> 
> (tongue-in-cheek)
> 
> No no, everyone knows you don't build simpler things on top of more
> complicated ones, you go the other way around.  So what he was
> suggesting was that selinux be re-written on top of smack.
> 
> :)

I'm not sure how seriously anyone ought to take what I'm about to
outline. Please feel free to treat it with as much or as little
reverence as you choose.

How to implement SELinux starting from Smack.

You'll need to break up the current rwxa accesses into a set
that matches the current SELinux set. Assign each a letter and
a "MAY_ACTION" #define.

You'll need a mapping for domain transitions, something like:

     subject-label program-label new-subject-label

This will require bprm hooks that aren't there now.

Additional hooks will need to be filled out as Smack does not
add access control to things that aren't objects or actions that
aren't accesses. Treat these as if they are accesses to objects
and there shouldn't be too much trouble.

Do something about the linear search for subject/object label pairs.
With the larger label set searching will become an issue.

Audit integration, too. The networking code will require some work
for ipsec. The interfaces are pretty clean, Smack isn't using it
because the CIPSO interface is simpler, not because there's any
real problem with it.

I wouldn't expect the whole thing to be more than a couple week's
work for someone who really wanted to do it.


Casey Schaufler
casey@schaufler-ca.com
