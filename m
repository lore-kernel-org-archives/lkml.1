Return-Path: <linux-kernel-owner+w=401wt.eu-S2993049AbXDYUI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993049AbXDYUI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 16:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993048AbXDYUI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 16:08:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35468 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993049AbXDYUI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 16:08:58 -0400
Date: Wed, 25 Apr 2007 22:08:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Message-ID: <20070425200836.GB17387@elf.ucw.cz>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org> <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> <20070425151825.GW3468@stusta.de> <20070425173405.GE17074@elf.ucw.cz> <20070425183934.GX3468@stusta.de> <alpine.LFD.0.98.0704251148110.9964@woody.linux-foundation.org> <20070425192512.GZ3468@stusta.de> <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704251231111.9964@woody.linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > .. but if the alternative is a feature that just isn't worth it, and 
> > > likely to not only have its own bugs, but cause bugs elsewhere? (And yes, 
> > > I believe STD is both of those. There's a reason it's called "STD". Go 
> > > to google and type "STD" and press "I'm feeling lucky". Google is God).
> > 
> > Is there really no use case for STD?
> 
> People seem to have reading comprehension problems.
> 
> The STD code is buggy, and has introduced bugs in STR too, largely thanks 
> to bad design. Some of them have happily gotten fixed. Others did not, and 
> now we have three totally different versions (two of which share some 
> infrastructure), all of which are broken (ie the "suspend2" people will 
> swear up-and-down that swsusp doesn't work for them, but anybody who 
> thinks that "suspend2" will work for everybody is just being a total 
> idiot, and I have a bridge to sell to them).

Well, lets get some credit to STD... it worked before STR, and it
allowed debugging basic driver infrastructure. 

> So my objections to STD have nothing to do with saving state and shutting 
> down. They have everything to do with the fact that it is not - and will 
> never be - a "suspend", and it shouldn't affect suspend.

STD needs to snapshot system, and then it needs devices to be
suspended so that snapshot is consistent.

> And that's a *fundamental* problem. If the STD people cannot even realize 
> that they have less to do with "suspend" than to "reboot", how do you ever 
> expect them to get anything to work, and not affect other things 
> negatively?

STD worked first ;-). Yes, these days it has little to do with
"suspend", it was mostly separated to "snapshot" and "restore".

We still keep swsusp in kernel for compatibility (and because it makes
debugging very easy).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
