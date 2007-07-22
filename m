Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbXGVMEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbXGVMEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbXGVMDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:03:54 -0400
Received: from waste.org ([66.93.16.53]:33093 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352AbXGVMDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:03:53 -0400
Date: Sun, 22 Jul 2007 07:02:13 -0500
From: Matt Mackall <mpm@selenic.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
Message-ID: <20070722120213.GX11115@waste.org>
References: <1184970779.4012.38.camel@chaos> <20070721222509.GI11166@waste.org> <20070721235109.GQ3672@sequoia.sous-sol.org> <1185090646.4012.149.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185090646.4012.149.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 09:50:46AM +0200, Thomas Gleixner wrote:
> On Sat, 2007-07-21 at 16:51 -0700, Chris Wright wrote:
> > * Matt Mackall (mpm@selenic.com) wrote:
> > > Can we see some stats on:
> > > 
> > > How many files were auto-merged?
> > > How many files got 32.c and 64.c extensions?
> > > How many existed only in one arch?
> > 
> > It's mostly about file movement first.
> > 
> >  918 files changed, 4745 insertions(+), 2836 deletions(-)
> 
> Hmm, did you forget to make distclean ?
> 
> Numbers from the script:
> 
> include/asm-i386     240 files
> include/asm-x86_64   169 files
> ------------------------------
>                      409 files
> 
> include/asm-x86      389 files
> 
> arch/i386            335 files
> arch/x86_64          141 files
> ------------------------------
>                      476 files
> 
> arch/x86             484 files
> 
> The increase here is due to migration helper files which only include
> the (_32.x or the _64.x) variant.
> 
> Makefile helpers       9 files
> Kconfig helpers        1 file
> Source helpers         4 files
> ------------------------------
>                       14 files
> 
> Summary:
> vanilla            22657 files
> vanilla->x86       22649 files
> 
> ------------------------------
> 
> include/x86 has 125 _32 and 125 _64 files
> arch/x86 has     55 _32 and  55 _64 files
> 
> 25 files were auto-merged
> 
> Looking at include/asm-x86/*_[32/64].h there are offhand ~ 50 of the 125
> which differ only minimal (white space damage, comment changes, ...),
> where the unification is a no brainer.

That looks more promising than I would have expected. For what it's
worth, I was originally fairly disgusted by the _32/64.c thing, but
the idea grows on me.

-- 
Mathematics is the supreme nostalgia of our time.
