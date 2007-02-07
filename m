Return-Path: <linux-kernel-owner+w=401wt.eu-S1161276AbXBGM7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161276AbXBGM7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 07:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965563AbXBGM7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 07:59:19 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2114 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965542AbXBGM7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 07:59:18 -0500
Date: Wed, 7 Feb 2007 12:35:52 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
Message-ID: <20070207123552.GD4481@ucw.cz>
References: <200702060353.l163rUmj000771@zach-dev.vmware.com> <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C8FA2D.6010706@vmware.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> >  
> >>Failure to use real-time delay here causes the 
> >>keyboard to become demonically
> >>possessed in the event of a kernel crash, with wildly 
> >>blinking lights and
> >>unpredictable behavior.  This has resulted in several 
> >>injuries.
> >
> >There must be a reason why it wasn't default before. 
> >Has this
> >reason changed?
> 
> This only matters under paravirt; non-paravirt kernels 
> and kernels running on native hardware will always 
> behave properly.
> 
> But paravirtualized kernels with fake devices have no 
> need to udelay to accommodate slow hardware - the 
> hardware is just virtual.  The USE_REAL_TIME_DELAY 
> define allows udelay to be specifically reverted back to 
> being a real delay.  There are only a couple cases where 

Ugh, it sounds like paravirt is more b0rken then I thought. It should
always to the proper delay, then replace those udelays that are not
needed on virtualized hardware with something else.

Just magically defining udelay into nop is broken.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
