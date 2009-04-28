Return-Path: <linux-kernel-owner+w=401wt.eu-S1762688AbZD1RSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762688AbZD1RSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760176AbZD1RSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:18:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753987AbZD1RSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:18:22 -0400
Date: Tue, 28 Apr 2009 10:13:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: david@lang.hm
cc: Tejun Heo <tj@kernel.org>, Dave Airlie <airlied@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kms in defconfig
In-Reply-To: <alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm>
Message-ID: <alpine.LFD.2.00.0904281002570.22156@localhost.localdomain>
References: <21d7e9970904270121s1c58365bqc8933f8a3ffc5f1a@mail.gmail.com>  <20090427083935.GA20941@elte.hu> <21d7e9970904270156v54a6483fs20d5b31c97a1d482@mail.gmail.com> <49F65FA2.4010603@kernel.org> <alpine.LFD.2.00.0904271852510.22156@localhost.localdomain>
 <alpine.DEB.1.10.0904280946210.17268@asgard.lang.hm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Apr 2009, david@lang.hm wrote:
> 
> as a end-user creating my own configs, I use the defaults as a guide to
> understand when something moves from "we think it's a good idea" to "things
> really need this"

I'm not talking about the defaults in the Kconfig files themselves, I'm 
talking about the millions of "*_defconfig" files that have tons of random 
default values.

> there's a _lot_ of stuff that goes in that is useful only is some situations,
> and the help text frequently doesn't help understanding what's really needed
> vs what the author of that feature _thinks_ is really needed (containers are a
> perfect example, they aren't needed in 99% of current systems, but it's
> actually _hard_ to really disable them completely)

Oh, I agree that the help text is not sufficient, and having new Kconfig 
options have sane default values is good. 

> you mention starting from a distro config, but most distro configs have a
> _huge_ number of things enabled that aren't needed for any particular box.

I think starting from the distro config and then turning off all modules 
("sed s/=m/=n/") is a good way to start off. Then enable just the modules 
that are actually loaded.

Of course, you then need to be aware of the things you may want even if 
they're not connected right now (eg things like FAT support). And 
sometimes it's hard to map "module name" -> "config options that need to 
be enabled".

So yes, it would be good to automate it:

> If a tool was available to detect the hardware and create a config tailored
> for the box, this use for a default config would go away

Yeah, I've wished for that.

Although I personally don't find that the actual hardware to be the 
biggest issue (since there are usually just a few options for that, and 
they are mostly not confusing). Instead, it's the issues about knowing 
which software components (netfilter, filesystems, auditing, POSIX ACL's) 
that you really want.

It tends to be easy to just enable them all, but if you want a nice 
efficient build, that's very much against the point.

So having some kind of (probably inevitably fairly complex) script that 
you could run to get a config would be good. The problem is that the 
script would need to be distributed with the kernel, yet it would often 
also have some nasty distro issues.

			Linus
