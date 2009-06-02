Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZFBQl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZFBQl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 12:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZFBQlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 12:41:49 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:34426 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZFBQls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 12:41:48 -0400
X-IronPort-AV: E=Sophos;i="4.41,291,1241395200"; 
   d="scan'208";a="5546727"
Message-ID: <4A25564A.70608@eu.citrix.com>
Date: Tue, 02 Jun 2009 17:41:46 +0100
From: George Dunlap <george.dunlap@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Xen is a feature
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jun 2009 16:41:46.0691 (UTC) FILETIME=[04D27130:01C9E3A1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Exactly that's the point. Adding dom0 makes life easier for a group of
> users who decided to use Xen some time ago, but what Ingo wants is
> technical improvement of the kernel.
>
> There are many features which have been wildly used in the distro
> world where developers tried to push support into the kernel with the
> same line of arguments.
>
> The kernel policy always was and still is to accept only those
> features which have a technical benefit to the code base.
>   
I can appreciate the idea of resisting the pushing of random features.  
Still, your definition of "improving Linux" is still lacking.  Obviously 
a new scheduler is taking something that's existing and improving it.  
But adding a new filesystem, a new driver, or adding a new feature, such 
as notifications, AIO, a new hardware architecture, or even KVM: How do 
those classify as "technical improvement to the kernel" or "features 
which have technical benefit to the code base" in a way that Xen does not?

If you mean "increases Linux's technical capability", and define Xen as 
outside of Linux, then I think the definition is too small.  After all, 
allowing Linux to run on an ARM processor isn't increasing Linux' 
technical capability, it's just allowing a new group of people (people 
with ARM chips) to use Linux.  It's the same with Xen.

No one disputes the idea that changes shouldn't be ugly; no one disputes 
the idea that changes shouldn't introduce performance regressions.  But 
there are patchqueues that are ready, signed-off by other maintainers, 
and which Ingo admits that he has no technical objections to, but 
refuses to merge. 

(His most recent "objection" is that he claims the currently existing 
pv_ops infrastructure (which KVM and others benefit from as well as Xen) 
introduces almost a 1% overhead on native in an mm-heavy 
microbenchmark.  So he refuses to merge feature Y (dom0 support) until 
the Xen community helps technically unrelated existing feature X 
(pv_ops) meets some criteria.  So it has nothing to do with the quality 
of the patches themselves.)

[Not qualified to speak to the specific technical objections.]
> I really have a hard time to see why dom0 support makes Linux more
> useful to people who do not use it. It does not improve the Linux
> experience of Joe User at all.
>   
If Joe User uses Amazon, he benefits.  If Joe User downloads an Ubuntu 
or Debian distro, and the hosting providers were more secure and had to 
do less work because dom0 was inlined, then he benefits because of the 
lower cost / resources freed to do other things.

But what I was actually talking about is the number of people who don't 
use it now but would use it if it were merged in.  There hundreds of 
thousands of instances running now, and more people are chosing to use 
it at the moment, even though those who use it have the devil's choice 
between doing patching or using a 3-year old kernel.  How many more 
would use it if it were in mainline?
> In fact it could be harmful to the average user, if it's merged in a
> crappy way that increases overhead, has a performance cost and draws
> away development and maintenance resources from other areas of the
> kernel.
>   
No one is asking for something to be merged in a crappy way, or with 
unacceptable performance cost.  There are a number of patchqueues that 
Ingo has no technical objections to, but which he still refuses to merge.

"Drawing away development and maintenance resources" is a cost/benefits 
question, and Jeremy's main point was that there is a *high* benefit for 
dom0 being merged into mainline.  The same could be said of almost 
anything: are you suggesting not accepting any more KVM code because it 
might "draw away development and maintenance resources from other areas 
of the kernel"?
> Aside of that it can also hinder the development of a properly
> designed hypervisor in Linux: 'why bother with that new stuff, it
> might be cleaner and nicer, but we have this Xen dom0 stuff
> already?'.
>   
This argument doesn't make any sense.  Would you advocate only having 
one filesystem for fear that people would somehow be discouraged from 
working on a new filesystem?

Even if that were a valid argument, it wouldn't apply in this situation. 
KVM has plenty of mind-share, and the support of RedHat.  Also, I'd 
wager that it's a lot easier for a Linux kernel developer to get 
involved in KVM than in Xen, because they're already familiar with 
Linux.  I don't think anyone working on KVM will be tempted to give up 
just because Xen is also available, unless it becomes clear that 
linux-as-hypervisor isn't the best technical solution; in which case, 
moving to Xen would be the right thing to do anyway.  Merging dom0 Xen 
will in no way interfere with the development of KVM or other 
linux-as-hypervisor projects.

The main point of Jeremy's e-mail was NOT to say, "Lots of people use 
this so you should merge it."  He's was responding to Xen being treated 
like it had no benefit.  It does have a benefit; it is a feature.

 -George
