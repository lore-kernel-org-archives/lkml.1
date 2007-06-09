Return-Path: <linux-kernel-owner+w=401wt.eu-S1760877AbXFIIi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877AbXFIIi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbXFIIiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:38:18 -0400
Received: from bay0-omc3-s9.bay0.hotmail.com ([65.54.246.209]:65360 "EHLO
	bay0-omc3-s9.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828AbXFIIiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:38:17 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Sat, 9 Jun 2007 04:37:23 -0400
From: Sean <seanlkml@sympatico.ca>
To: david@lang.hm
Cc: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and
 manipulation,pathname matching
Message-Id: <20070609043723.2df9c827.seanlkml@sympatico.ca>
In-Reply-To: <Pine.LNX.4.64.0706090030470.6675@asgard.lang.hm>
References: <200706042303.28785.agruen@suse.de>
	<1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil>
	<200706090003.57722.agruen@suse.de>
	<20070609001703.GA17644@kroah.com>
	<Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
	<200706091101.JAB31303.PTNNSGtM@I-love.SAKURA.ne.jp>
	<20070608232531.d68de09f.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082138360.6675@asgard.lang.hm>
	<20070609011022.ac332fc7.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082224370.6675@asgard.lang.hm>
	<20070609014454.2f1f2f91.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706082356220.6675@asgard.lang.hm>
	<20070609032822.bc420a84.seanlkml@sympatico.ca>
	<Pine.LNX.4.64.0706090030470.6675@asgard.lang.hm>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2007 08:38:27.0146 (UTC) FILETIME=[8CAC0AA0:01C7AA71]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007 01:03:15 -0700 (PDT)
david@lang.hm wrote:


> becouse the SELinux people don't want to have this in their code for one 
> thing.

Tuff nuggies to the SELinux people.. Show them code good enough they'd be
embarrassed to reject.

> you seem to be ignoring the SELinux people who say that pathnames are 
> fundamentally different from labels, labels stay with the data if the file 
> is renamed, path names do not. multiple hard-links to the same file will 
> always have the same label for SELinux, but could have very different 
> permissions with AA
>
> labels are part of policy, policy is not supposed to be decided by the 
> kernel.

Not sure why you're rehashing this.  We all know that not everyone
agrees with AA.  The point is users should have a choice.. choice is
good.  But that's not a justification for bloating the kernel with
a bunch of code that isn't needed and can be refactored into a
small extension of what already exists.

> SELinux treats all files with the same label the same. to have the same 
> ability to treat every file differntly that AA has SELinux would have to 
> give every file a different label.

I'm not convinced in practice you really need a unique label for every
file.  Large swathes of the system would have a shared label etc..  So
let's not get caught up on theoretical arguments that don't really play
in practice.  Has anyone on the AA team actually _tried_ to extend
SELinux instead of reinventing the wheel?
 
> how will you know how many labels you need to put into your policy that 
> you load into the kernel?
> 
> how will the kernel figure out what label to use for a file

The AA extension will have a path-to-label mapping.  Conceptually that's
exactly what its doing now.  Look at the arguments by AA proponents that
the only difference between the AA method and SELinux is _when_ those
labels are created...  Sorry i don't have a link handy, but i can dig one
up if you dispute that this argument has been made by the AA folks.

> and the userspace code that converts the policy needs to know the names 
> when it feeds the policy into the kernel.
> and you still need to implement the new LSM hooks that AA is asking for to 
> figure out what the path to a file is.

True, but so what?

> the policy mechanism is supposed to be the LSM hooks, and AA is trying to 
> re-use them.

Who says that's what is "supposed" to be in all situations?   It makes more
sense to target the best API that lets you implement the features you want.

> after you change SELinux to be able to do everything that AA does then you 
> can tell SELinux to act like AA, true but irrelavent.

BS.  All we're talking about is an extension that allows SELinux to
generate labels on the fly.   That goes most the way towards giving
you all the functionality you're after and should be a much smaller patch
in the end, reusing code that already exists in the kernel.

> first off, and for the record, it's not _my_ implementation. I have 
> nothing to do with writing AA.
> 
> I am just someone who manages hundreds of servers for which AA would be a 
> good fit. In the past I've gone to a lot of effort to get less security 
> then AA would provide to implement seperate services in seperate chroot 
> sandboxes. I'm looking for easier and better options, I've looked at 
> SELinux and don't believe that I can produce a reasonable policy in a 
> reasonable amount of time (and I don't trust distro vendors to do it for 
> me, they have to allow a lot of things that don't make sense on my 
> systems, and I occasionally need to allow something that wouldn't make 
> sense in the general case, let alone all the software I run that the disto 
> doesn't know anything about)

Whoa.  Again you're mistaking the current state of SELinux, rather than
SELinux + AA extension.   If such a beast provides the same features you
get with the current AA implementation, why would you care?

> chroot sandboxes, virtual machines, containers all have the problem that 
> when you need to have more then one application interacting they need to 
> be put togeather and the basic mechanism doesn't provide you any security 
> against each other.
>
> SELinux is aiming for 'perfect' security, I'll readily admit that, just 
> like I'll admit that AA is only aiming for 'good enough' security, but 
> that 'good enough' security would help me and I don't see any way to get 
> to SELinux's 'perfect' security.

All that is irrelevant to the discussion though.

> Also don't care about the details of how it gets implemented, but when 
> the AA people have a working implementation, and the SELinux people are 
> strongly opposed to the concept, I don't see any advantage in trying to 
> get the AA people to throw away a lot of their working code to try and get 
> people (many of who have be very insulting frankly) to accept such 
> fandamental changes.

But "working implementation" is _not_ the criteria for acceptance into
the kernel and that's what this discussion is about.

> if the SELinux people had responded to the announcement of AA with "that's 
> a nice idea, if we add these snippits from your code to SELinux then we 
> can do the same thing" it would be a very different story.

To be fair, that's not their job.
 
> but as always patches talk louder then anything else, if you believe that 
> the efforts should be combined so strongly why don't you start submitting 
> the appropriate patches to SELinux to make it able to do what AA does?

Because i'm not the one trying to get something into the kernel.  I'm not
the one who has to show that my patches are reasonable and make best use
of the current kernel infrastructure possible.

Sean
