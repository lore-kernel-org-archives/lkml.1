Return-Path: <linux-kernel-owner+w=401wt.eu-S1756316AbZFQQRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbZFQQRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZFQQRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:17:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:34490 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbZFQQRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:17:48 -0400
Date: Wed, 17 Jun 2009 18:17:44 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090617161744.GA22192@wotan.suse.de>
References: <1245059476.12400.7.camel@pasglop> <1245059859.23207.16.camel@penberg-laptop> <20090615102737.GA20461@wotan.suse.de> <1245062727.12400.23.camel@pasglop> <20090615112355.GB6012@wotan.suse.de> <1245101498.12400.37.camel@pasglop> <20090616044601.GB28596@wotan.suse.de> <alpine.LFD.2.01.0906161141290.3282@localhost.localdomain> <20090617074719.GB26664@wotan.suse.de> <alpine.LFD.2.01.0906170853580.16802@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906170853580.16802@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 09:01:16AM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 17 Jun 2009, Nick Piggin wrote:
> > 
> > In some cases perhaps it is difficult. In others it should be
> > pretty natural. Lots of memory allocating paths pass gfp
> > a long way down the stack.
> 
> I agree that some cases would be pretty natural. In fact, that's what we 
> started out doing. On the x86 side, we didn't have a lot of issues in 
> testing, and we fixed them up by using GFP_NOWAIT (see for example 
> cpupri_init() in kernel/sched_cpupri.c, or init_irq_default_affinity() in 
> kernel/irq/handle.c - both of which were fixed up in that phase).
> 
> Those paths, in fact, in general already had "bootmem" flags etc. And x86 
> doesn't need to initialize a lot of state at bootup. 

Yes.

 
> Then Ben happened, and crazy PPC ioremap crap. 

OK. I agree ioremap probably would get painful. Are they doing that
too early anyway? From your email it sounds like maybe they are.

 
> So the problem is exactly that it was perfectly natural to pass down a gfp 
> or other flag in _some_ cases. And then in a few cases it's much more 
> painful.

Sure... I understand, and I don't want to force people to add
more nasty code to work around these. I am fine with the fix
to slab for now... I was just hoping maybe we don't put the
rule in place that all early boot allocations shall use GFP_KERNEL.
I'd like to see the allocation context passed down (including via
code that knows when interrupts are off in early boot) if possible
without ttoo much ugliness.

