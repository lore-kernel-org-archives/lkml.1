Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbZJBRu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbZJBRu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbZJBRu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:50:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35896 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270AbZJBRu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:50:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>
Subject: Re: T400 suspend/resume regression -- bisected to a mystery merge commit
Date: Fri, 2 Oct 2009 19:51:29 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Theodore Tso <tytso@mit.edu>, tglx@linutronix.de,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Ondrej Zary <linux@rainbow-software.org>
References: <E1MrRDa-0002WF-LO@closure.thunk.org> <20090928135109.GB17514@mit.edu> <aec7e5c30910012350g3908b2ecj4e9ed5f4549c6a4d@mail.gmail.com>
In-Reply-To: <aec7e5c30910012350g3908b2ecj4e9ed5f4549c6a4d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910021951.29370.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Magnus Damm wrote:
> On Mon, Sep 28, 2009 at 10:51 PM, Theodore Tso <tytso@mit.edu> wrote:
> > On Sun, Sep 27, 2009 at 06:13:42PM +0200, Rafael J. Wysocki wrote:
> >>
> >> commit c7121843685de2bf7f3afd3ae1d6a146010bf1fc
> >> Author: Magnus Damm <magnus.damm@gmail.com>
> >> Date:   Tue Jul 28 14:09:55 2009 -0700
> >>
> >>     clocksource: Save mult_orig in clocksource_disable()
> >>
> >> Please try to revert it and retest.
> >
> > Using Linus's suggested technique, I bisected it down to this commit:
> >
> > Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Date:   Fri Aug 14 15:47:30 2009 +0200
> >
> >    timekeeping: Update clocksource with stop_machine
> >
> >    update_wall_time calls change_clocksource HZ times per second to check
> >    if a new clock source is available. In close to 100% of all calls
> >    there is no new clock. Replace the tick based check by an update done
> >    with stop_machine.
> >
> >    Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> >    Cc: Ingo Molnar <mingo@elte.hu>
> >    Acked-by: John Stultz <johnstul@us.ibm.com>
> >    Cc: Daniel Walker <dwalker@fifo99.com>
> >    LKML-Reference: <20090814134810.711836357@de.ibm.com>
> >    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> >
> > Unfortunately there are a bunch of patches I'm trying to get in shape
> > to push to Linus (the merge window coincided unfortunately with
> > LinuxCon/Plumbeer's so I'm a bit behind) so I haven't had a chance to
> > take it further.  I'll try reverting each of the above two patches,
> > and report back in a day or two.
> 
> Just checking, did need to revert
> c7121843685de2bf7f3afd3ae1d6a146010bf1fc? I hope not. =)

But someone else did, as mentioned above.  It is on the regression list as
http://bugzilla.kernel.org/show_bug.cgi?id=14222

Thanks,
Rafael
