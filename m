Return-Path: <linux-kernel-owner+w=401wt.eu-S1763747AbXH3WoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763747AbXH3WoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762899AbXH3WoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:44:02 -0400
Received: from ozlabs.org ([203.10.76.45]:47195 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbXH3WoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:44:00 -0400
Subject: Re: [PATCH] Fix lguest page-pinning logic ("lguest: bad stack page
	0xc057a000")
From: Rusty Russell <rusty@rustcorp.com.au>
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lguest <lguest@ozlabs.org>
In-Reply-To: <20070830163812.GA22190@slug>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <20070822202551.GB31846@slug>
	 <20070823145038.9895784f.akpm@linux-foundation.org>
	 <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org>
	 <20070824082249.GG31846@slug>
	 <1188043649.20041.81.camel@localhost.localdomain>
	 <20070825122324.GA6138@slug> <20070825211405.GA18217@slug>
	 <1188230999.5531.15.camel@localhost.localdomain>
	 <20070830163812.GA22190@slug>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 08:12:55 +1000
Message-Id: <1188511975.6353.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 18:38 +0200, Frederik Deweerdt wrote: 
> On Tue, Aug 28, 2007 at 02:09:59AM +1000, Rusty Russell wrote:
> > If the stack pointer is 0xc057a000, then the first stack page is at
> > 0xc0579000 (the stack pointer is decremented before use).  Not
> > calculating this correctly caused guests with CONFIG_DEBUG_PAGEALLOC=y
> > to be killed with a "bad stack page" message: the initial kernel stack
> > was just preceeding the .smp_locks section which
> > CONFIG_DEBUG_PAGEALLOC marks read-only when freeing.
> > 
> Hello Rusty,
> 
> I just could try the patch, sorry for the delay. Albeit it allows to
> progress a little further in the boot process, lguest seems to like that
> "section that was just freed" :)

Yes, I got this too, then had to jump on a plane (and away from my test
box).

Turns out this actually isn't my bug (yay!).

See next patch...
Rusty.

