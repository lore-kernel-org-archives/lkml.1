Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYHGORP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYHGORP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 10:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbYHGOQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 10:16:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYHGOQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 10:16:58 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080806215244.GA21462@mit.edu>
References: <20080804223249.GA10517@kroah.com>
	 <1217896374.27684.53.camel@localhost.localdomain>
	 <20080805005132.GA3661@kroah.com>
	 <20080805122328.69a37c1d@lxorguk.ukuu.org.uk>
	 <20080805170307.GB9639@kroah.com>
	 <1217962602.27684.144.camel@localhost.localdomain>
	 <20080805203007.GB27489@kroah.com>
	 <1218048597.27684.276.camel@localhost.localdomain>
	 <20080806210202.GA9413@mit.edu>
	 <1218058081.5837.49.camel@localhost.localdomain>
	 <20080806215244.GA21462@mit.edu>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 10:16:43 -0400
Message-Id: <1218118603.5837.101.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 17:52 -0400, Theodore Tso wrote:
> On Wed, Aug 06, 2008 at 05:28:01PM -0400, Eric Paris wrote:
> > > In this scenario, are you positing that you are worried about Windows
> > > malware, or Linux malware?  What OS are the clients running?  I will
> > > note that Windows has such a sucky NFS implementation that nearly all
> > > Widows clients will be running CIFS/SMB, not NFS
> > 
> > I believe I specifically did not make any such claims at all about the
> > client OS and merely claimed the intended target was not the linux NFS
> > server.
> 
> I know you didn't say; that's why I asked.  :-)

We are sort of talking past each other here, but I really am listening.

[snip]

> Given that MacOS and Linux don't have these flaws with respect to
> applications regularly expecting root privileges, will you admit that
> perhaps some of the extreme scanning tactics that were required by
> AntiVirus vendors might be not as necessary for "other desktops"?

Absolutely, I think that our solution needs worry much less about an
actively attacking root process than Windows.  I think everyone on list
would tend to agree that our security model greatly helps in this
regard.  I think the problem quickly becomes intractable as soon as we
talk about a locally running actively attacking root process, which I
believe is what you are discussing.  I think that leaves 4 things

1) fileserver with no active attack on system
2) actively attacking non-root processes (run some process that tries to
screw people)
3) accidentally attacking, non-root process. (open a malicious
openoffice file)
4) accidentally attacking, properly functioning, root processes (my
thought on this would be a properly functioning non-exploited yum
program getting data from a bad repo)

For the purposes of this e-mail discussion can we only discuss #1?  I
think its the easiest problem to look at and is at the heart of stopping
#2, 3 and 4.  If we can keep the files off the disk we greatly reduce
(although clearly don't eliminate) the ability for all of the other
attacks against our system.

> Asking the question is important because if they are spending all of
> their time on Windows virii, then your "elementary threat" is really
> an "elementary strawman".  Or, at the very least, it's a low priority
> effort, since the number of virii out in the field for Linux and MacOS
> desktops is in the noise compared to Windows.  I know that it's
> convenient for AV vendors to claim in their marketing literature that
> this is only because Windows is more popular, but while that might be
> part of it, it is also true that there are significant, structural
> differences between Windows and those other large desktop candidates.

Remember my (contrived to prove a single point, but I think interesting)
goal was not to stop an active attack against any OS, which you appear
to be focusing on.  My goal was to make a Linux fileserver an
inhospitable place for data which may someday attack a system to live.
Our systems have almost infinitely many ingress and egress mechanisms
and I don't think its tractable to attempt to do this at the edge.  At a
minimum while I sit here I can think of smbd, nfs, ftp, http, smtp, ssh,
and rsync which are very likely ingress and egress points of data on a
Linux system.  Trying to move the solution to all of those places gets a
bit large and certainly buggy.  And I think we both agree those aren't
the only possible ingress and egress points for information.

> > Your argument is irrelevant for the threat given and you seem to have
> > contorted the actual point of the statements to fit something else.  But
> > I'm sure you a fan of multiple layers of security that you don't
> > actually believe that "just check on the clients" is the right thing to
> > do.
> 
> Giving up my water bottles and having to take off my shoes at airport
> security has been justified in the name of "multiple layers of
> security".  No, I'm NOT a fan of mindlessly using "defense in depth"
> as an excuse for arbitrary amounts of security and giving up arbitrary
> amounts of my private data.  You need to prove to me that from a cost
> benefit tradeoff it's really worth it.

I guess step one is agreeing that the goal "harden linux to be an
inhospitable host for 'bad' data which may someday be used to attack
another system" is a useful goal.  Maybe you don't agree and if so
please help me understand how that goal is unreasonable.  We aren't
talking about the solution just yet (I'm the first to say that the
patches I posted might be complete shiet for the final solution), just
the goal for a moment.  Maybe the solution will be so unwieldy that we
later find the goal to not be worth it, but this seems the most
simplistic of goals that all AV vendors are going to claim to want to
do.

I believe this to be a reasonable goal as it reduces the attack area for
a number of attacks against linux programs (pdf rendering flaws, jpg
rendering flaws, etc).  Browser downloads bad pdf, evince tries to open
that which the browser just downloaded, BLOCKED.  Obviously the 'right'
thing to do there was update evince so the attack would not work, but
now what stops me, the unsuspecting use who just looked at this pdf and
didn't get hacked from passing it on?  Same thing for openoffice macros?
Sure you update openoffice and you down get p0wnt but that doesn't keep
you from putting it on the NFS server for everyone else in the office
who doesn't know how to keep their system up to date from getting
screwed.

While waiting for AV vendors to see if any of them can make reasonable
claims about goals 2, 3, and 4 I think we can consider #1.  (for all I
know #1 is going to be the ONLY thing that any vendor can make a
reasonable claim about)  Even if they come up with other things I think
that just considering #1 is valuable since it can eliminate some of the
potential solutions.  I don't see myself wasting time going down the
GLIBC path since I believe that making systems inhospitable to 'bad'
data is something that should be done (if reasonably possible) both
client and server side.

-Eric

