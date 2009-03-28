Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbZC1FHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbZC1FHD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 01:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZC1FGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 01:06:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56382 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbZC1FGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 01:06:52 -0400
Date: Sat, 28 Mar 2009 06:06:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090328050633.GA13003@elte.hu>
References: <72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com> <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326182519.d576d703.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 26 Mar 2009 18:03:15 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Thu, 26 Mar 2009, Andrew Morton wrote:
> > > 
> > > userspace can get closer than the kernel can.
> > 
> > Andrew, that's SIMPLY NOT TRUE.
> > 
> > You state that without any amount of data to back it up, as if it was some 
> > kind of truism. It's not.
> 
> I've seen you repeatedly fiddle the in-kernel defaults based on 
> in-field experience.  That could just as easily have been done in 
> initscripts by distros, and much more effectively because it 
> doesn't need a new kernel.  That's data.
> 
> The fact that this hasn't even been _attempted_ (afaik) is 
> deplorable.
> 
> Why does everyone just sit around waiting for the kernel to put a 
> new value into two magic numbers which userspace scripts could 
> have set?

Three reasons.

Firstly, this utterly does not scale.

Microsoft has built an empire on the 'power of the default settings' 
- why cannot Linux kernel developers finally realize the obvious: 
that setting defaults centrally is an incredibly efficient way of 
shaping the end result?

The second reason is that in the past 10 years we have gone through 
a couple of toxic cycles of distros trying to work around kernel 
behavior by setting sysctls. That was done and then forgotten, and a 
few years down the line some kernel maintainer found [related to a 
bugreport] that distro X set that sysctl to value Y which now had a 
different behavior and immediately chastised the distro broken and 
refused to touch the bugreport and refused bugreports from that 
distro from that point on.

We've seen this again, and again, and i remember 2-3 specific 
examples and i know how badly this experience trickles down on the 
distro side.

The end result: pretty much any tuning of kernel defaults is done 
extremely reluctantly by distros. They consider kernel behavior a 
domain of the kernel, and they dont generally risk going away from 
the default. [ In other words, distro developers understand the 
'power of defaults' a lot better than kernel developers ... ]

This is also true in the reverse direction: they dont actually mind 
the kernel doing a central change of policy, if it's a general step 
forward. Distro developers are very practical, and they are a lot 
less hardline about the sacred Unix principle of separation of 
kernel from policy.

Thirdly: the latency of getting changes to users. A new kernel is 
released every 3 months. Distros are released every 6 months. A new 
Firefox major version is released about once a year. A new major GCC 
is released every three years.

Given the release frequency and given our goal to minimize the 
latency of getting improvements to users, which of these projects is 
best suited to introduce a new default value? [and no, such changes 
are not generally done in minor package updates.]

	Ingo
