Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbXDKOQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbXDKOQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbXDKOQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:16:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2566 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752817AbXDKOQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:16:53 -0400
Date: Wed, 11 Apr 2007 14:00:58 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: [patch] high-res timers: UP resume fix
Message-ID: <20070411140058.GA5014@ucw.cz>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070407082554.GA1943@elte.hu> <1175935730.28263.510.camel@localhost.localdomain> <200704071148.43136.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704071148.43136.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > [...] Soeren, can you confirm that you are using a !CONFIG_SMP kernel, 
> > > > and if yes, does the patch below fix the resume problem for you?
> > > 
> > > hm, you seem to have a CONFIG_SMP=y kernel. I dont immediately see where 
> > > we re-enable interrupts in the SMP case, but could you try my patch 
> > > nevertheless
> > 
> > We do in on_each_cpu() unconditionally. I missed that.
> 
> BTW, the on_each_cpu() in clock_was_set() is unnecessary, because
> timekeeping_resume() is always run on one CPU.

I wonder if we should add BUG_ON(interrupts_enabled) just before
enabling interrupts to catch similar mistakes early?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
