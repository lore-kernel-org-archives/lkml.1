Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbYIQO0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbYIQO0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbYIQO0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:26:00 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3602 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752891AbYIQOZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:25:58 -0400
Date: Sun, 17 Aug 2008 21:48:38 +0200
From: Pavel Machek <pavel@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Shem Multinymous <multinymous@gmail.com>,
       Elias Oltmanns <eo@nebensachen.de>, Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
Message-ID: <20080817194838.GC4043@ucw.cz>
References: <48C7FCEE.8060404@kernel.org> <41840b750809110908o54a61f55w7b1b9793abf55634@mail.gmail.com> <48C948A6.3080404@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C948A6.3080404@kernel.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> 2. If we're gonna unify interface, how much can we unify the backend?
> >>   Some devices are based on polling, others interrupt.  For polling,
> >>   is it better to delegate the whole polling to userland or is it
> >>   better to do some of it in kernel (tp_smapi seems to be doing
> >>   this)?
> > 
> > The ThinkPad accelerometer needs to be polled at very regular
> > intervals (max jitter on the order of 10ms), which sounds like a job
> > for the kernel.
> 
> Yes, I agree.
> 
> > This is because in ThinkPads we actually have a 4-level pile:
> > [hdapsd userspace] -> [hdaps kernel] -> [embedded controller] ->
> > [accelerometer A2D]
> > What the kernel polls is actually is the H8S embedded controller (EC)
> > chip, which in turn does its own polling of the accelerometer A2D.
> > Now, the EC has a tiny buffer and strange buffering semantics, and it
> > has its own internal clock, so the software->EC polling should be very
> > regular to minmize EC buffer overflows/underruns.
> 
> So, I think the whole polling should be implemented inside the kernel
> and the kernel should notify userland when new data is available,
> which is about what the current joystick implementation does and can
> be achieved using sysfs_notify_event().

I like joystick/input interface slightly better. In some cases,
machines with accelerometers (openmoko) use them for input primarily.

HP interface will be more specialized (but less useful); still  userland daemon can handle the differences...

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
