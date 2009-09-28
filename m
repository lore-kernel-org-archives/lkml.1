Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZI1VVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZI1VVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbZI1VVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:21:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38679 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbZI1VVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:21:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: T400 suspend/resume regression -- bisected to a mystery merge commit
Date: Mon, 28 Sep 2009 23:22:57 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: tglx@linutronix.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>,
       Magnus Damm <magnus.damm@gmail.com>
References: <E1MrRDa-0002WF-LO@closure.thunk.org> <200909271813.42829.rjw@sisk.pl> <20090928135109.GB17514@mit.edu>
In-Reply-To: <20090928135109.GB17514@mit.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909282322.57824.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 September 2009, Theodore Tso wrote:
> On Sun, Sep 27, 2009 at 06:13:42PM +0200, Rafael J. Wysocki wrote:
> > 
> > commit c7121843685de2bf7f3afd3ae1d6a146010bf1fc
> > Author: Magnus Damm <magnus.damm@gmail.com>
> > Date:   Tue Jul 28 14:09:55 2009 -0700
> > 
> >     clocksource: Save mult_orig in clocksource_disable()
> > 
> > Please try to revert it and retest.
> 
> Using Linus's suggested technique, I bisected it down to this commit:
> 
> Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Date:   Fri Aug 14 15:47:30 2009 +0200
> 
>     timekeeping: Update clocksource with stop_machine
>     
>     update_wall_time calls change_clocksource HZ times per second to check
>     if a new clock source is available. In close to 100% of all calls
>     there is no new clock. Replace the tick based check by an update done
>     with stop_machine.
>     
>     Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
>     Cc: Ingo Molnar <mingo@elte.hu>
>     Acked-by: John Stultz <johnstul@us.ibm.com>
>     Cc: Daniel Walker <dwalker@fifo99.com>
>     LKML-Reference: <20090814134810.711836357@de.ibm.com>
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Unfortunately there are a bunch of patches I'm trying to get in shape
> to push to Linus (the merge window coincided unfortunately with
> LinuxCon/Plumbeer's so I'm a bit behind) so I haven't had a chance to
> take it further.  I'll try reverting each of the above two patches,
> and report back in a day or two.

Great, thanks a lot!

Rafael
