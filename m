Return-Path: <linux-kernel-owner+w=401wt.eu-S1160998AbXAZJbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160998AbXAZJbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 04:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965602AbXAZJbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 04:31:40 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4036 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965620AbXAZJbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 04:31:39 -0500
Date: Wed, 24 Jan 2007 14:01:06 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Scott Preece <sepreece@gmail.com>
Cc: Alessandro Di Marco <dmr@gmx.it>, linux-kernel@vger.kernel.org,
       vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070124140105.GD7365@ucw.cz>
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz> <877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz> <87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz> <7b69d1470701231134k4e3e8a4dj2b95a230fa3da81c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b69d1470701231134k4e3e8a4dj2b95a230fa3da81c@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> >
> >>    But I still believe it can be out.
> >>
> >> Do you believe it could be a user-space daemon or 
> >what?
> >
> >Yes, what prevents userspace daemon watching 
> >/dev/input/event* to
> >provide this functionality?
> >                                                                        Pavel
> ---
> 
> One possible argument is to allow integrating 
> "input-like" user events
> with other kinds of system-level events that you might 
> want to have
> treated like user activity. For instance, our definition 
> of user
> activity includes: button presses, opening-closing the 
> cover (on a
> phone), and plugging in or removing memory cards, 
> accessories, or
> cables. We actually use a mix of kernel and user-space 
> monitoring,

Well... input already has 'pseudokey' for lid, and yes, you
probably can monitor cover, memory cards and cables from userspace,
already... as you do. Cover, and maybe even cards/cables could be
integrated with input infrastructure, too.

(Still waiting for you to start selling those cool phones in czech
republic :-).

> A user-space monitor also has more opportunity for races 
> - for
> instance, deciding that the inactivity timeout has 
> occurred between
> the time that the user does something and the time that 
> the kernel
> gets a notification up to user space.

Same races are inside kernel, too.

> My own hot button is making sure that the definition of 
> what
> constitutes user activity is managed in exactly one 
> place, whether in
> the kernel or not. My naive model would be to put the 
> response at user
> level, but to provide a single point of definition in 
> the kernel (say,
> /dev/useractivity or the equivalent) that the user-level 
> daemon could
> listen to.

Actually, I believe right solution is to provide one, unified,
monitoring daemon, using whatever interfaces are available. (+ add
missing functionality to the kernel, if neccessary).

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
