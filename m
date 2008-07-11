Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbYGKXWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbYGKXWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYGKXWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:22:08 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:9353 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753118AbYGKXWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:22:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAICHd0h5LFxA/2dsb2JhbACqRA
X-IronPort-AV: E=Sophos;i="4.30,348,1212330600"; 
   d="scan'208";a="147025742"
Date: Sat, 12 Jul 2008 09:22:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: xfs bug in 2.6.26-rc9
Message-ID: <20080711232201.GG11558@disturbed>
Mail-Followup-To: Sebastian Siewior <lkml@ml.breakpoint.cc>,
	Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <20080711190209.GA7401@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711190209.GA7401@Chamillionaire.breakpoint.cc>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 09:02:09PM +0200, Sebastian Siewior wrote:
> * Dave Chinner | 2008-07-11 18:42:49 [+1000]:
> 
> >Oh - you must be running a debug XFS.  CONFIG_XFS_DEBUG was only
> >introduced in 2.6.26-rc1 and defaults to 'N', so you must have
> >selected the non-default option when prompted. This will cause your
> >machine to oops at the slightest inconsistency that is found,
> >regardless of whether it is fatal or not. Like the help text says,
> >don't set this unless you are an XFS developer....
> Could you please add this to the Kconfig entry.

I effectively quoted from it:

config XFS_DEBUG
        bool "XFS Debugging support (EXPERIMENTAL)"
        depends on XFS_FS && EXPERIMENTAL
        help
          Say Y here to get an XFS build with many debugging features,
          including ASSERT checks, function wrappers around macros,
          and extra sanity-checking functions in various code paths.

          Note that the resulting code will be HUGE and SLOW, and probably
          not useful unless you are debugging a particular problem.

          Say N unless you are an XFS developer, or you play one on TV.

> Debug mode is usually
> noisy, little slower and mostly usefull just to the developers but *I*
> would not expect to BUG() in the non-fatal case.

What do you expect debug code to do? Asserts are designed to
drop the machine into a debugger when they fail so the problem can
be, well, debugged.

> Not sure but if this is just for hch and you than a define in xfs.h
> might be safer :)

And any other XFS developer using the XFS git tree or mainline, as
tends to happen these days. And there are cases where a debug XFS
might be needed to help find a problem that is being hit out in
the field.

Like all other debug config options, don't set them unless you know
what you are doing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
