Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYDCOE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYDCOE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 10:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbYDCOEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 10:04:15 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52894 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756869AbYDCOEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:04:13 -0400
Message-Id: <1207231451.8070.1245872431@webmail.messagingengine.com>
X-Sasl-Enc: vbqTUbWmC37gnzy6a5L4IRfnmUJbUrHQfRmHSFxTW0uh 1207231451
From: "Kai" <epimetreus@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Ray Lee" <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Mike Galbraith" <efault@gmx.de>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1206310206.17373.1243881033@webmail.messagingengine.com>
   <2c0942db0803231522w7c66f168xf7fea72d135ba395@mail.gmail.com>
   <1206341873.32060.1243929851@webmail.messagingengine.com>
   <20080327091711.GD30918@elte.hu>
Subject: Re: Serious performance regression in Wine applications and Linux      
   2.6.24.*
In-Reply-To: <20080327091711.GD30918@elte.hu>
Date: Thu, 03 Apr 2008 07:04:11 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 10:17:14 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> 
> * Kai <epimetreus@fastmail.fm> wrote:
> 
> > The issue only shows with Age of Wonders II and AoW Shadow Magic.
> > 
> > Every version of wine from 0.9.55 to 0.9.58, including several 
> > intermediate git builds.
> > 
> > Xorg version 1.4.0.90, and a couple other versions (the problems has 
> > persisted across a couple updates of Xorg)
> > 
> > Hardware rendering; using the prop. nV driver; updating that also 
> > doesn't affect the issue, nor does retaining the same version.
> 
> could you run this script while such a slowdown is really prominent:
> 
>   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> 
> and send me the output it generates? The output is the most useful if 
> you do this on a kernel that has CONFIG_SCHED_DEBUG=y and 
> CONFIG_SCHEDSTATS=y enabled.
> 
> on the off chance that this issue has been fixed in the soon-to-be 
> 2.6.25 kernel, you might also want to try x86.git/latest, which is based 
> on the latest Linus tree and has all relevant x86 fixes and improvements 
> added as well:
> 
>   http://people.redhat.com/mingo/x86.git/README
> 
> several of the changes can affect performance.
> 
> a third (and most comprehensive) way to debug this would be to send me a 
> scheduler trace of such a slowdown, you can generate a scheduler trace 
> the following way:
> 
>   http://people.redhat.com/mingo/sched-devel.git/readme-tracer.txt
> 
> but we can probably give a first estimation based on the cfs-debug-info 
> output already. Btw., you can combine the scheduler and the x86 git tree 
> into a temporary unified tree by doing these two commands:
> 
>   git-checkout -b tmp x86/latest
>   git-merge sched-devel/latest
> 
> (run "make oldconfig" to pick up the new config options.)

Okay, so I don't know a lot about git; I tried following the
instructions in the readme at
http://people.redhat.com/mingo/x86.git/README to get a latest x86 tree,
and merge it with sched-devel/latest using the commands git-checkout -b
tmp x86/latest and git-merge sched-devel/latest:

mkdir linux.trees.git || exit -1
cd linux.trees.git
git-init-db
git-remote add linus
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
git-remote add x86
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
git-remote update
git-checkout -b tmp x86/latest
git-merge sched-devel/latest

Then I copied over a config file and updated it, but building failed
shortly into the process, with some errors about missing a } before ;,
and excess elements in scalar initializer, in file
arch/x86/kernel/init_task.cc.. anyway, I tried to update again, using
git-remote update, but it kept giving me this output: 

Updating linus
Updating sched-devel
fatal: The remote end hung up unexpectedly
fetch sched-devel: command returned error: 128

So I'm just going to test using 2.6.25-rc8-git2; however, can someone
also give me the proper sequence of commands to get a working tree as
Ingo Molnar requested, so I can test that way, too? Sorry to be a pain.
