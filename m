Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbZEYPDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbZEYPDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 11:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZEYPDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 11:03:40 -0400
Received: from waste.org ([66.93.16.53]:43015 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbZEYPDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 11:03:39 -0400
Subject: Re: [GIT PULL] scheduler fixes
From: Matt Mackall <mpm@selenic.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       npiggin@suse.de
In-Reply-To: <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI>
References: <alpine.LFD.2.01.0905180955550.3301@localhost.localdomain>
	 <20090518170909.GA1623@elte.hu> <20090518190320.GA20260@elte.hu>
	 <alpine.LFD.2.01.0905181208130.3301@localhost.localdomain>
	 <20090518202031.GA26549@elte.hu>
	 <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain>
	 <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI>
	 <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu>
	 <4A1A2261.1000504@kernel.org> <20090525051521.GC23032@elte.hu>
	 <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI>
Content-Type: text/plain
Date: Mon, 25 May 2009 09:55:59 -0500
Message-Id: <1243263359.12761.48.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-25 at 11:47 +0300, Pekka J Enberg wrote:
> On Mon, 25 May 2009, Ingo Molnar wrote:
> > Ok, i think this all looks pretty realistic - but there's quite a 
> > bit of layering on top of pending changes in the x86 and irq trees. 
> > We could do this on top of those topic branches in -tip, and rebase 
> > in the merge window. Or delay it to .32.
> > 
> > ... plus i think we are _very_ close to being able to remove all of 
> > bootmem on x86 (with some compatibility/migration mechanism in 
> > place). Which bootmem calls do we have before kmalloc init with 
> > Pekka's patch applied? I think it's mostly the page table init code.
> >  
> > ( beyond the page allocator internal use - where we could use 
> >   straight e820 based APIs that clip memory off from the beginning 
> >   of existing e820 RAM ranges - enriched with NUMA/SRAT locality 
> >   info. )
> 
> OK, here's a version of the patch with Yinghai's rebasing on top of 
> tip/master. All in-kernel memory allocators boot cleanly now on my 
> configuration (I did not try SLQB but it probably needs fixing). I would 
> appreciate if someone gave SLAB+NUMA configuration a try.
> 
> Ingo, I don't really want to carry this in slab.git so perhaps you could 
> put this and Yinghai's irq init cleanup in a "earlyslab" branch in tip for 
> testing?
> 
> And oh, Christoph/Matt, can I have your NAK/ACK for this patch?

Looks ok to me, though I'd probably split it into three parts (slab,
slub, init).

For future reference, 0xbaadf00d ought to move into poison.h.

-- 
http://selenic.com : development and support for Mercurial and Linux


