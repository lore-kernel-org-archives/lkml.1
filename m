Return-Path: <linux-kernel-owner+w=401wt.eu-S1754948AbYH3AsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948AbYH3AsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 20:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYH3Ar7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 20:47:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbYH3Ar6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 20:47:58 -0400
Date: Fri, 29 Aug 2008 17:45:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, David Witbrodt <dawitbro@sbcglobal.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers <kernel-testers@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit
 a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
In-Reply-To: <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>  <200808292157.24179.rjw@sisk.pl>  <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>  <200808300031.16708.rjw@sisk.pl>  <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
  <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org> <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Yinghai Lu wrote:
> 
> the BAR is from pci_read_bases..., so that chipset is broken...
> they are even supposed to to hide that BAR to os.

Ok, can we please

 - *do* get a quirk for known-broken chipsets (at a *PCI* level, this is 
   not an x86 issue)

 - *not* get any more random PCI work-arounds that go through the x86 tree 
   and aren't even looked at by the (very few) people who actually 
   understand the PCI resource handling?

IOW, for the first issue, just teach pci_mmcfg_check_hostbridge() about 
this broken bridge, and have it fix things up (including hiding the thing, 
but also just verifying that the dang thing even -works- etc).

For the second issue - please do realize that we have had much over a 
_decade_ of work on the PCI resource handling, and it's fragile. The thing 
I reverted really isn't something that Ingo should ever have committed in 
the first place. It's not something an x86 maintainer can even make sane 
decisions on.

Resource handling things _need_ to get ACK's from people like Ivan 
Kokshaysky or me. Or at least _several_ other people who actually really 
understand not just PCI resource handling, but have actually seen all the 
horrible crap it causes, and understand how fragile this stuff is. It's 
all different, and it's all about all the million of broken machines out 
there that screw things up.

			Linus
