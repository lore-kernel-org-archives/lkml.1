Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbXKJKXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbXKJKXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 05:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbXKJKXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 05:23:39 -0500
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:34322
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbXKJKXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 05:23:38 -0500
Date: Sat, 10 Nov 2007 02:32:43 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Sam Ravnborg <sam@ravnborg.org>
cc: Jeff Garzik <jeff@garzik.org>, Paul Mundt <lethal@linux-sh.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
In-Reply-To: <20071110093948.GB5707@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0711100220370.4780@asgard.lang.hm>
References: <20071109230812.GA5176@uranus.ravnborg.org> <4735242B.1010801@garzik.org>
 <20071110075444.GA5707@uranus.ravnborg.org> <20071110082152.GA18632@linux-sh.org>
 <47356AD5.4070102@garzik.org> <20071110093948.GB5707@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2007, Sam Ravnborg wrote:

> Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
> 
> In an not opposed to keep ARCH={i386,x86_64} but then we should
> establish clear semantics.
> What does it imply when I build a kernel with ARCH=i386?
> - 32 bit, build kernel, uname -m

as a user I think it would be a good idea to keep the i386/x86_64 options 
around for a few kernel revisions to maintain compatibilty with people's 
build scripts (not everyone upgrades every kernel release. I've been 
running kernel.org kernels in production for over 10 years and between the 
scheduler changes in .23 and the arch merge in .24 even I'm going to be 
very cautious until .25 or .26 fleshes out all the gotchas, although the 
per-device buffer work is valuble enough that a couple systems will get 
it soon)

you also need a transition for make oldconfig for several versions

i386 should imply 32 bit and the old CPU i386 options
x86_64 should imply 64 bit and the old amd_64 cpu options

> and what about the intuitive version: make ARCH=x86
> Is this a 32 or 64 bit kernel?

unknown, which cpu did you select to compile it for? and in the case of 
cpus that support both modes, which one did you select? I don't know if 
it makes sense to just list K8-32 and K8-64 as seperate cpu options in one 
menu or to have a 32/64 bit switch and then two seperate cpu menus (I 
suspect the first is better in the long run) but either way can work.

> How do we in a generic way say "this is a 64 bt kernel"?
> Something that works equally well for s390, ppc, sh, sparc etc?
>
> make ARCH=s39064 looks bad...
> make ARCH=sh64 looks OK...

why do you need to have it as a specific command-line option instead of 
being part of your cpu selection?

and isn't there something like march=686 that could be extended to 
march=k8-32 vs march=k8-64?

march=s390-64 or s390-32 doesn't look nearly as bad as s39064 that you 
listed above.

David Lang

