Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbXI3RDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbXI3RDH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbXI3RCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:02:55 -0400
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:37283 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755661AbXI3RCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:02:54 -0400
X-YMail-OSG: 1EtbTuQVM1n27ymus66gYDTh4Zp1cl7K6zRKPQNUiD1TpIfwxVxfyjpS.1k4rSLV0WYE0iaR01MyKLseOWInIo3q5KwaoqzI.3LqIMetCSoI0JObgEM-
X-RocketYMMF: rancidfat
Date: Sun, 30 Sep 2007 10:02:53 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
To: Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com
Cc: torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>
In-Reply-To: <20070930011618.ccb8351b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <95254.21609.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sat, 29 Sep 2007 17:20:36 -0700 Casey Schaufler <casey@schaufler-ca.com>
> wrote:
> 
> > 
> > Smack is the Simplified Mandatory Access Control Kernel.
> >
> 
> I don't know enough about security even to be dangerous.  I went back and
> reviewed the August thread from your version 1 submission and the message I
> take away is that the code has been well-received and looks good when
> considered on its own merits, but selinux could probably be configured to
> do something sufficiently similar.
> 
> I'd have trouble declaring that "but" to be a reason to not merge smack.
> I'm more thinking "let's merge it and see if people use it".
> 
> > 
> >  Documentation/Smack.txt       |  104 +
> >  security/Kconfig              |    1 
> >  security/Makefile             |    2 
> >  security/smack/Kconfig        |   10 
> >  security/smack/Makefile       |    9 
> >  security/smack/smack.h        |  207 ++
> >  security/smack/smack_access.c |  345 ++++
> >  security/smack/smack_lsm.c    | 2685 ++++++++++++++++++++++++++++++++
> >  security/smack/smackfs.c      | 1201 ++++++++++++++
> >  9 files changed, 4564 insertions(+)
> 
> And that wonderful diffstat really is key to being able to do this.
> 
> My major non-technical concern is that Casey Schaufler might get hit by a
> bus.  If this happens, we can remove the feature in three minutes (that
> diffstat again), but that may not be feasible if people have come to rely
> upon the feature.
> 
> otoh, if a significant number of people are using smack, presumably someone
> else would step up to maintain smack post-bus.  The risk seems acceptable
> to me.
> 
> My major technical concern is the apparent paucity of documentation.

I've been leading with code, and working on the documentation
less agressively. I will pick up the text pace.

> So with the information which I presently have available to me, I'm
> thinking that this should go into 2.6.24.

That would be OK by me. Thank you.
 
> Is smack useful without a patched ls, sshd and init.d?  What is the status
> of getting those userspace patches merged?  ie: do you know who to send the
> diffs to, and are they likely to take them?

Yes, haven't been pushing, don't know, and haven't a clue.

> What other userspace tools are likely to need patching?

Over time the Smack application changes will fairly
closely follow those for SELinux, e.g. cron, login,
su, the MLS window environment. There won't be a major
set of new applications or libraries as there isn't a
policy compliation step involved.

> Notes on the code:
> 
> 
> - Please run scripts/checkpatch.pl across the diff.  It generates 50-100
>   warnings about minor stylistic matters, and those warnings all look legit
>   to me.  (extern decls in C are my fave peeve).

Will do.

> - Smack.txt and the website seem a bit skimpy.  Is there enough
>   documentation out there for someone to usefully (and, more importantly,
>   safely) start using smack?

Current feedback says they need more work.

> - In his review of version 1, Andi suggested that your ruleset traversal
>   be protected by RCU.  But it seems that this wasn't done.  Were the races
>   which he identified fixed by other means?  If so, what were they?

The ruleset code was completly revised in Version 2.
 
> - hm, netlabels.  Who might be a suitable person to review that code? 
>   Seems that Paul Moore is the man.  Maybe he'd be interested in taking a
>   look over it (please?)

Paul was the first person to whom I sent the patch. I would be
delighted to have him review it again.

> - some parts of the code use the "smack_foo" naming convention and other
>   parts use "smk_foo".  Seems odd.  Deliberate?

The original intent was an "external" vs "internal" distinction,
but it greyed over time. I will look at cleaning this up.

> - According to git-log, you haven't merged any kernel code at all in at
>   least 5.5 years.  This patch makes it look like you've been doing kernel
>   full time for a decade.  That thing in my hand is a hat.

Thank you. The current set of interfaces and practices make
kernel coding much easier than it was back in the Unix days.


Casey Schaufler
casey@schaufler-ca.com
