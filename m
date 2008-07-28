Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbYG1O5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbYG1O5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 10:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756973AbYG1OyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 10:54:18 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:44907 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756313AbYG1OyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 10:54:15 -0400
X-Greylist: delayed 1952 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2008 10:54:15 EDT
From: Gabriel Paubert <paubert@iram.es>
Date: Mon, 28 Jul 2008 15:52:51 +0200
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hugh@veritas.com>, Linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: CONFIG_FRAME_POINTER [was [PATCH] x86: BUILD_IRQ say .text]
Message-ID: <20080728135251.GA1216@iram.es>
References: <Pine.LNX.4.64.0807211828470.26173@blonde.site> <20080724104459.GI28817@elte.hu> <Pine.LNX.4.64.0807251839190.20617@blonde.site> <1217022373.11188.115.camel@pasglop> <Pine.LNX.4.64.0807261122430.20543@blonde.site> <1217075802.11188.129.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217075802.11188.129.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 10:36:42PM +1000, Benjamin Herrenschmidt wrote:
> On Sat, 2008-07-26 at 12:02 +0100, Hugh Dickins wrote:
> > 
> > Hmm, perhaps it is doing sibling calls differently even without the
> > explicit -fno-optimize-sibling-calls (but when I add that option,
> > the vmlinux size does go up another 4400).
> > 
> > Sorry, I'm most probably fussing over nothing,
> > and wasting your time with my ignorance.
> 
> No you aren't, there is indeed something happening. It looks like gcc is
> keeping a copy of each stack frame in r31, thus forcing to save/restore
> that register, along function calls, possibly to help get reliable
> frames for leaf functions. I don't think we use that "feature" in our
> backtrace code though... so it won't harm in the sense that it won't
> break things, but it will indeed bloat the code a little bit.
> 
> Maybe we should totally disable -fno-omit-frame-pointers on powerpc ...

Yes.
> either that or see about actually using that r31 linkage, though I'm not
> sure it would be that useful.

On PPC you can get reliable backtraces (modulo leaf functions, but AFAIR
the frame pointer does not help, only the CFI data) without a frame pointer
since the ABI makes the stack pointer chain easy to follow. The frame pointer
(r31) is only necessary when there are variable size stack allocations, 
alloca() for example, but are they even allowed in the kernel?

	Regards,
	Gabriel
