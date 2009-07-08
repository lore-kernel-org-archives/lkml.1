Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbZGHJfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbZGHJfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 05:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756768AbZGHJfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 05:35:25 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:44270 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbZGHJfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 05:35:24 -0400
Date: Wed, 8 Jul 2009 18:35:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] U300 sched_clock implementation
Message-ID: <20090708093505.GA14719@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Tim Bird <tim.bird@am.sony.com>, linux-kernel@vger.kernel.org,
	mingo@elte.hu, linux-arm-kernel@lists.arm.linux.org.uk
References: <63386a3d0905112337p2d426481o5f9bf9b9489cc57e@mail.gmail.com> <63386a3d0905231446h245bb4a9gec111f68a74a44e4@mail.gmail.com> <1243151839.26820.642.camel@twins> <63386a3d0905250513q6ca56eeepcf7bebe46c447fb4@mail.gmail.com> <1243256510.26820.679.camel@twins> <63386a3d0906010046k3b86d70av3e290fc26c2934f5@mail.gmail.com> <1243933212.23657.5726.camel@twins> <20090707074243.GA6995@n2100.arm.linux.org.uk> <63386a3d0907070101g51026139rb40635a26a4826a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d0907070101g51026139rb40635a26a4826a7@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 10:01:58AM +0200, Linus Walleij wrote:
> Adding in Paul M since it was his patch that was supposed to fix up a
> generic solution...
> 
> 2009/7/7 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> > On Tue, Jun 02, 2009 at 11:00:12AM +0200, Peter Zijlstra wrote:
> >> I think its best if we continue with the patch Paul Mundt has been
> >> proposing.
> >
> > [added Tim Bird to CC]
> >
> > So what do we do? ?There's apparantly been zero movement on this for
> > over a month, and Tim Bird is reposting his patch adding __notrace
> > to ARMs existing sched_clock implementations.
> >
> > Given that it seems the generic approach has died a death, I suggest we
> > merge Linus' U300 patch, and get Tim to redo his patch to take account
> > of that, and apply both.
> >
> > Then, if the generic approach eventually happens, everything can then be
> > fixed up.
> >
> > Alternatively, if there is movement on the generic approach...
> >
> > Discuss.
> >
> 
> I would really like to see Pauls work finalized, it looked very promising,
> and I think there was actually a rough consensus about his last patch.
> But I guess that will be in the 2.6.32 merge window earliest?
> 
There was a consensus up until the point John noted that sched_clock()
can't wrap, so the generic approach is going to need a bit more work to
take the cycle shift and so on in to account. I've gotten momentarily
sidetracked with other things, but I'll post an updated version shortly.

Having said that, I don't see any reason why this should block progress
on the ARM side, once folks are happy with the generic version then most
of the implementations can be killed off, so a few more isn't going to
make much of a difference one way or the other.

The only reason I haven't done an SH-specific sched_clock() is because
none of our clocksources are architecture specific, and they all reside
in drivers/.
