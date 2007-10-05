Return-Path: <linux-kernel-owner+w=401wt.eu-S1760418AbXJEIdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418AbXJEIdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 04:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbXJEIdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 04:33:00 -0400
Received: from www.tglx.de ([62.245.132.106]:53225 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbXJEIc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 04:32:58 -0400
Date: Fri, 5 Oct 2007 10:32:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
In-Reply-To: <20071005061106.GA27798@uranus.ravnborg.org>
Message-ID: <alpine.LRH.0.999.0710051026200.10191@www.tglx.de>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <200710022351.48971.alistair@devzero.co.uk> <20071005053813.GA25242@elte.hu>
 <20071005061106.GA27798@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2007, Sam Ravnborg wrote:
> > > cp: cannot stat `arch/x86_64/boot/bzImage': No such file or directory
> > > 
> > > Obviously, this file has moved to arch/x86/boot, but it seems like 
> > > possibly unnecessary breakage. I've been copying bzImage for years 
> > > from arch/x86_64/boot, and I'm sure there's a handful of scripts 
> > > (other than Debian's kernel-image) doing this too.
> > > 
> > > For now, I hacked the tool[1]. Maybe, if we care, a symlink could be 
> > > set up between arch/x86/boot and arch/$ARCH/boot ? Or would papering 
> > > over this be more trouble than it's worth?
> > 
> > yeah, a symlink is the right solution i think. Our first-step goal is to 
> > make the switchover seamless for all practical purposes, and a 
> > compatibility symlink in arch/i386/boot/ will not hurt. (we shouldnt 
> > worry about the really old zImage target though)
> 
> But when can we then get rid of it?
> This is a simple question about when we take the noise..
> And right now people know we are shifting to x86 - so it makes
> sense to let the dependent userspace tools take the pain now and not later.
> 
> Starting to fill up a build kernel with symlinks for compatibility with
> random progarms seems to be the wrong approach.
> 
> 	Sam - that dislike especially the asm symlink

Sam,

I completely agree with you, but we want to keep the migration noise
as low as possible. Adding the symlink right now along with an entry
into features-removal.txt (6 month grace period) allows a smoother
transition. The distro folks should better get their gear together
until then.

	tglx
