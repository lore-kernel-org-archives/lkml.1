Return-Path: <linux-kernel-owner+w=401wt.eu-S1161823AbXD1PhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161823AbXD1PhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 11:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161833AbXD1PhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 11:37:16 -0400
Received: from pfepc.post.tele.dk ([195.41.46.237]:60465 "EHLO
	pfepc.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161823AbXD1PhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 11:37:13 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Kasper Sandberg <lkml@metanurb.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Zach Carter <linux@zachcarter.com>, buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070427115526.GA7699@elte.hu>
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 17:35:51 +0200
Message-Id: <1177774551.21279.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 13:55 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > update for lkml readers: this is some really 'catastrophic' condition 
> > triggering on your box. Here ogg123 just never skips on an older 750 
> > MHz box, which is 4-5 times slower than your 2GHz box - while i have 
> > _fourty nice-0 infinite loops_ running. I.e. at this clearly 
> > ridiculous load, at just 2.5% of CPU time ogg123 is just chugging 
> > along nicely and never leaves out a beat.
> 
> Kasper, just to exclude the possibility that this is somehow related to 
> IO scheduling, could you copy the OGG file over to /dev/shm and play it 
> from there? Do you still get the bad skips?
Just copied to a tmpfs, and it still skips badly.

in response to your question, Ingo, yes, i see those atleast 0 ms
messages.

I am not running esd, i use alsa directly from ogg123.

but its not just ogg123, mplayer does it too. just moving a window can
trigger it. even scrolling in my maillist causes it.

and this ONLY happens on cfs, not vanilla, not staircase, not sd.

while i look at top, the load average is 0.11

its definetly not an IO issue, cause i just tried creating some IO load,
like reading files, it doesent skip, but moving windows triggers it
better than anything(mplayer seems more sensitive than ogg123), it seems
anything X-related makes it explode..

tried looking for buffer stuff in /proc/asound, couldnt find anything,
im using the via82xx driver.


> 
> 	Ingo
> 

