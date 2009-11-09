Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbZKIJnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbZKIJnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 04:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZKIJne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 04:43:34 -0500
Received: from www.tglx.de ([62.245.132.106]:40832 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718AbZKIJne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 04:43:34 -0500
Date: Mon, 9 Nov 2009 10:43:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@googlemail.com>
cc: Oleg Nesterov <oleg@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: 2.6.32-rc5-mmotm1101 - lockdep whinge during early boot
In-Reply-To: <alpine.LFD.2.00.0911051748090.12138@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0911091038010.2725@localhost.localdomain>
References: <6417.1257351084@turing-police.cc.vt.edu>  <200911051941.03401.rusty@rustcorp.com.au>  <20091105141055.GA17350@redhat.com>  <alpine.LFD.2.00.0911051547110.12138@localhost.localdomain>  <20091105152241.GA24690@redhat.com>  <20091105153321.GB24690@redhat.com>
  <alpine.LFD.2.00.0911051653170.12138@localhost.localdomain> <6e0cfd1d0911050820v19ebedl4177eea7b576ad67@mail.gmail.com> <alpine.LFD.2.00.0911051748090.12138@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, Thomas Gleixner wrote:
> On Thu, 5 Nov 2009, Martin Schwidefsky wrote:
> > >
> > > Which basically reverts commit 7285dd7fd375763bfb8ab1ac9cf3f1206f503c16
> > >
> > 
> > It is this commit in linux-next:
> > 
> > commit 66b1a72ceaa7da811db025855f19482f0a38e815
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Thu Sep 10 19:39:52 2009 +0200
> > 
> >     Revert "clocksource: Resolve cpu hotplug dead lock with TSC unstable"
> > 
> >     This reverts commit 7285dd7fd375763bfb8ab1ac9cf3f1206f503c16.
> > 
> >     causes crashes.
> > 
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Eeek. We fixed this in mainline via:
> 
> commit f79e0258ea1f04d63db499479b5fb855dff6dbc5
> Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Date:   Fri Sep 11 15:33:05 2009 +0200
> 
>     clocksource: Resolve cpu hotplug dead lock with TSC unstable, fix crash
> 
> and
> 
> commit 54a6bc0b071c50150bc6d1da16c2cd9a963e288c
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon Sep 14 19:49:02 2009 +0200
> 
>     clocksource: Delay clocksource down rating to late boot
> 
> 
> These patches came via the tip tree right at the beginning of the
> merge window several days _before_ I asked Linus to pull the timer
> code for 32.
> 
> So there is something weird going on.

Ok, figured out what happened.

The revert has been in next via the tip-tree for some days when
testing turned up the problem and the fixes were not ready.

So it looks like Andrew picked exactly such a linux-next snapshot to
create his baseline patch.

linux-next, tip, mainline of today all have the correct and functional
code.

Thanks,

	tglx
