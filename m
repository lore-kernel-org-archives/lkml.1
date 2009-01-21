Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbZAUHUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbZAUHUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 02:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbZAUHTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 02:19:53 -0500
Received: from mail.suse.de ([195.135.220.2]:32853 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752AbZAUHTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 02:19:52 -0500
Date: Wed, 21 Jan 2009 08:19:50 +0100
From: Nick Piggin <npiggin@suse.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep and debug objects together are broken?
Message-ID: <20090121071950.GM24891@wotan.suse.de>
References: <20090120085559.GB19505@wotan.suse.de> <19f34abd0901201311t2425056dia6182812f7270297@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0901201311t2425056dia6182812f7270297@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 10:11:47PM +0100, Vegard Nossum wrote:
> On Tue, Jan 20, 2009 at 9:55 AM, Nick Piggin <npiggin@suse.de> wrote:
> > Hi,
> >
> > I've had a problem frustrating my testing because lockdep was silently turning
> > itself off... I patched out the code to disable lockdep after the first error,
> > and it started showing up weird errors. kernel/fork.c:990 seemed to be the
> > first to trigger (hard irqs disabled) from a call_usermodehelper call. Later,
> > migration thread was reported to try to unlock rq->lock although it was
> > holding no locks. Then init was reported to return to userspace without
> > releasing an objectdebug hash lock.
> >
> > All that went away and everything seemed to work properly with debug objects
> > configured out.
> >
> > I didn't get too far in trying to debug the problem. But it should be easy
> > enough to reproduce (if not, I can post traces or test patches).
> 
> I just built a kernel with lockdep and debugobjects enabled, and
> everything seemed fine. I think you should post your kernel version,
> config, and the lockdep patch (if needed -- it didn't seem to turn
> itself off here).

Are you sure? Ie. sysrq+D a still works properly? In that case, you
wouldn't need the lockdep patch because it just prevents the feature from being
switched off.

I'll have to dig a bit further, then. The annoying thing is that
lockdep turns itself off at the drop of a hat (and this particular
problem seems to happen without any backtraces), so it invalidates
all your lockdep testing if you don't realise it has turned itself
off.

Is there a way to re-arm lockdep? That would be neat.

