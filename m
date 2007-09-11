Return-Path: <linux-kernel-owner+w=401wt.eu-S966842AbXIKUjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966842AbXIKUjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933666AbXIKUj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:39:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:48307 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933649AbXIKUj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:39:28 -0400
From: Andi Kleen <ak@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: x86 merge - a little feedback
Date: Tue, 11 Sep 2007 21:38:10 +0100
User-Agent: KMail/1.9.1
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070911201219.GA9674@uranus.ravnborg.org>
In-Reply-To: <20070911201219.GA9674@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709112138.11247.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> In the filename there is NOTHING for most of
> the non-shared code that tell that this file is
> used by only i386 or x86_64.

Exactly my point from KS. The big mash-up will not really make much difference
in terms of Makefile clarity or whatever Thomas' point was. Apparently he 
wanted to eliminate a few lines of code from the Makefile and merge
the header files completely? 

Anyways, the end result will be roughly the same as it is now: i386 and x86-64
are shared in not completely obvious ways and if you change one you have to 
test compile the other too.

Same old, same old, as always.

> I dunno if this will address the concern of Andi about mixing i386 and
> x86_64 but to me at least things would be so much more obvious if the
> original relationship are spelled out.

In the end it won't make much difference where the files are located
(although I frankly don't see the advantage of this intrusive move).

You always have to at least compile test both if you change one and I doubt 
most  people will be able to avoid this no matter how the Makefile looks
or where the files are. 

Even if everything was merged together and only ifdefs remained that
fundamental fact would not change either.

A few more files could be also definitely shared, no argument. e.g. 
the time subsystem will likely to be shared soon anyways. And probably
a few others. That should be better all done carefully step by step and 
properly reviewed though, not in some kind of brutal "rewrite the world" 
event.

My concern is mostly that he seems to want to merge some things between 32bit 
and  64bit (like the APIC drivers or the crappy i386 maze-of-inlines 
subarchitecture design) which ought not be together. I think I managed to 
keep x86-64 a relatively clean port over-all, but I see this now going down 
the drain :/

-Andi
