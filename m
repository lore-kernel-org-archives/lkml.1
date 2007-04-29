Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbXD2H7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbXD2H7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbXD2H7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:59:47 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59642 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315AbXD2H7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:59:46 -0400
Subject: Re: [patch] CFS scheduler, -v6
From: Kasper Sandberg <lkml@metanurb.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
In-Reply-To: <20070429065900.GB32281@elte.hu>
References: <20070425214704.GA32572@elte.hu>
	 <1177596399.14496.1.camel@localhost>
	 <200704261041.04838.gene.heskett@gmail.com>
	 <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu>
	 <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost>
	 <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu>
	 <20070429065900.GB32281@elte.hu>
Content-Type: text/plain
Date: Sun, 29 Apr 2007 09:59:35 +0200
Message-Id: <1177833575.9756.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 08:59 +0200, Ingo Molnar wrote:
> * Willy Tarreau <w@1wt.eu> wrote:
> 
> > I don't know if Mike still has problems with SD, but there are now 
> > several interesting reports of SD giving better feedback than CFS on 
> > real work. In my experience, CFS seems smoother on *technical* tests, 
> > which I agree that they do not really simulate real work.
> 
> well, there are several reports of CFS being significantly better than 
> SD on a number of workloads - and i know of only two reports where SD 
> was reported to be better than CFS: in Kasper's test (where i'd like to 
> know what the "3D stuff" he uses is and take a good look at that 
> workload), and another 3D report which was done against -v6. (And even 
> in these two reports the 'smoothness advantage' was not dramatic. If you 
> know of any other reports then please let me know!)

I can tell you one thing, its not just me that has observed the
smoothness in 3d stuff, after i tried rsdl first i've had lots of people
try rsdl and subsequently sd because of the significant improvement in
smoothness, and they have all found the same results.

The stuff i have tested with in particular is unreal tournament 2004 and
world of warcraft through wine, both running opengl, and consuming all
the cpu time it can get.

and the thing that happens is simply that even when theres only that
process, sd is still smoother, but the significance is much larger once
just something starts, like if the mail client starts fetching mail, and
running some somewhat demanding stuff like spamasassin, the only way you
notice it is by the drop in fps, smoothness is 100% intact with SD
(ofcourse if you started HUGE load it probably would get so little cpu
it would stutter), but with every other scheduler you will notice
immediate and quite severe stuttering, in fact to many it will seem
intolerable.

I can tell you how I first noticed this, i was experimenting in ut2k4
with sd, and usually i always have to close my mail client, because when
spamasassin starts (nice 0), the game would stutter quite much, but when
i was playing i noticed some IO activity and work noises from my disk,
but that was all, no noticable stutter or problems with the 3d, but i
couldnt figure out why, i then discovered i had forgotten to close my
mail client which i previously ALWAYS have had to do.

If you have some ideas on how these problems might be fixed i'd surely
try fixes and stuff, or if you have some data you need me to collect to
better understand whats going on. But i suspect any somewhat demanding
3d application will do, and the difference is so staggering that when
you see it in effect, you cant miss it.

> 
> 	Ingo
> 

