Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbZI1Nva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbZI1Nva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 09:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZI1Nva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 09:51:30 -0400
Received: from thunk.org ([69.25.196.29]:38845 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZI1Nv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 09:51:29 -0400
Date: Mon, 28 Sep 2009 09:51:09 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: tglx@linutronix.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: T400 suspend/resume regression -- bisected to a mystery merge
	commit
Message-ID: <20090928135109.GB17514@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, tglx@linutronix.de,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	Ondrej Zary <linux@rainbow-software.org>,
	Magnus Damm <magnus.damm@gmail.com>
References: <E1MrRDa-0002WF-LO@closure.thunk.org> <200909271813.42829.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909271813.42829.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 06:13:42PM +0200, Rafael J. Wysocki wrote:
> 
> commit c7121843685de2bf7f3afd3ae1d6a146010bf1fc
> Author: Magnus Damm <magnus.damm@gmail.com>
> Date:   Tue Jul 28 14:09:55 2009 -0700
> 
>     clocksource: Save mult_orig in clocksource_disable()
> 
> Please try to revert it and retest.

Using Linus's suggested technique, I bisected it down to this commit:

Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date:   Fri Aug 14 15:47:30 2009 +0200

    timekeeping: Update clocksource with stop_machine
    
    update_wall_time calls change_clocksource HZ times per second to check
    if a new clock source is available. In close to 100% of all calls
    there is no new clock. Replace the tick based check by an update done
    with stop_machine.
    
    Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Acked-by: John Stultz <johnstul@us.ibm.com>
    Cc: Daniel Walker <dwalker@fifo99.com>
    LKML-Reference: <20090814134810.711836357@de.ibm.com>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Unfortunately there are a bunch of patches I'm trying to get in shape
to push to Linus (the merge window coincided unfortunately with
LinuxCon/Plumbeer's so I'm a bit behind) so I haven't had a chance to
take it further.  I'll try reverting each of the above two patches,
and report back in a day or two.

    	   	   				- Ted
