Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbYHOILN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbYHOILN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 04:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYHOIK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 04:10:56 -0400
Received: from elasmtp-spurfowl.atl.sa.earthlink.net ([209.86.89.66]:58427
	"EHLO elasmtp-spurfowl.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691AbYHOIKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 04:10:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=tek53nV/ww9C0ppsk4VlnoZcIqWlaIBCYInwZiW8wpi5cWqlbE9Lj9hPG2GWeg2J;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Fri, 15 Aug 2008 04:10:50 -0400
From: Bill Fink <billfink@mindspring.com>
To: David Witbrodt <dawitbro@sbcglobal.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       netdev <netdev@vger.kernel.org>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- why Yinghai's revert
 may have failed
Message-Id: <20080815041050.37479646.billfink@mindspring.com>
In-Reply-To: <990549.89300.qm@web82101.mail.mud.yahoo.com>
References: <990549.89300.qm@web82101.mail.mud.yahoo.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d54946bcad3c767257163742240c3847a350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Thu, 14 Aug 2008, David Witbrodt wrote:

> > > I used 'git apply --check ' first, and got no errors, so
> > > I applied it, built, installed, and rebooted.
> > 
> > that patch revert to use request_resource, so there is some other problem
> > 
> > YH
> 
> I finished experimenting last night with trying to find the last commit
> in the gittree that would let me revert the problem successfully...
> and I got completely raped.
> 
> The bisecting took me all the way back to the first commit introducing
> the problem on these motherboards:  3def3d6d...
> 
> Considering these 3 consecutive commits (according to 'git log')from late
> Feb. 2008, between kernel versions 2.6.25 and 2.6.26-rc1:
> ---------------------------------------------------------
> 
> 700efc1b...:  the last kernel I can build and run just fine.
> 
> 3def3d6d...:  this one builds, but locks up in inet_init() once the sequence
> of function calls reaches synchronize_rcu().  Reverting here works, but is
> trivial and silly, just reproducing 700efc1b...
> 
> 1e934dda...:  attempting to revert the changes from 3def3d6d... (just one
> commit before!) already fails.
> ---------------------------------------------------------
> 
> This last commit has an effect on my machine that prevents attempts to
> revert 3def3d6d... from working as intended.  This may explain why
> Yinghai's patch providing the revert for 2.6.27-rc3 did not work.
> (Hopefully none of the other changes between Feb. and Aug. would also keep
> the revert from working, but I wouldn't bet my life on it....)
> 
> The 3d... and 1e... commits are quite small, touching only 4 files total,
> and both commits involve calls to insert_resource().  Something on my 2
> problem machines is behaving badly in this area.

I wonder if it would help to revert both the 3def3d6d... and 1e934dda...
commits.  If there are 2 (or more) problematic commits, then of course
it wouldn't help to revert just one of the two commits.  This is one of
the nastiest type of debugging scenario, when there is more than one
cause of the observed problem, although in such case the multiple
causes are often related in some way.

						-Bill
