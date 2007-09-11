Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbXIKHoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbXIKHoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 03:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757272AbXIKHoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 03:44:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293AbXIKHop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 03:44:45 -0400
Date: Tue, 11 Sep 2007 00:44:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: clockevents: fix resume logic
Message-Id: <20070911004400.c45f34fa.akpm@linux-foundation.org>
In-Reply-To: <1189496071.25767.84.camel@chaos>
References: <200707220159.l6M1xBgH001236@hera.kernel.org>
	<20070910144740.4eba2fda.akpm@linux-foundation.org>
	<1189492636.25767.62.camel@chaos>
	<20070911000001.30f8590b.akpm@linux-foundation.org>
	<1189495400.25767.81.camel@chaos>
	<1189496071.25767.84.camel@chaos>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 09:34:31 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 2007-09-11 at 09:23 +0200, Thomas Gleixner wrote:
> > > I went back to the original patch which I sent to Linus and it matches
> > > 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6.  So all I can think is that there
> > > must have been something else in the tree which I tested which fixed the
> > > bug which 18de5bc4c1f1f1fa5e14f354a7603bd6e9d4e3b6 introduced.  argh.
> > > 
> > > Can you think what would cause the symptoms which I described?  
> > 
> > It seems that time is not updated. Timer interrupt not active or some
> > other odd thing. I figure out what's going on when I find a box which
> > exposes the problem.
> 
> It get's even worse. Reverting the patch breaks _my_ VAIO. 
> 
> /me cries and looks for a job which does not involve computers
> 

heh.

I've confirmed that 2.6.22-rc6+thatpatch fails, but 2.6.22-rc6 plus the
three hundred patches up to and including that patch doesn't fail.

So there's something between "origin.patch" and
"clockevents-fix-resume-logic.patch" in the 2.6.22-rc6-mm1 lineup which
fixes thatpatch, once it is applied.

So I'm doing an inverted reverse polish bisection search to find out which
patch preemptively fixes clockevents-fix-resume-logic.patch.  Try doing
that with git, suckers.


gimme twenty minutes...
