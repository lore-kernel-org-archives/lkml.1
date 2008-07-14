Return-Path: <linux-kernel-owner+w=401wt.eu-S1756982AbYGNHa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbYGNHa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYGNHav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:30:51 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:1350 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754562AbYGNHau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:30:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADubekh5LFxA/2dsb2JhbACoOw
X-IronPort-AV: E=Sophos;i="4.30,357,1212330600"; 
   d="scan'208";a="148482980"
Date: Mon, 14 Jul 2008 17:30:35 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: xfs bug in 2.6.26-rc9
Message-ID: <20080714073035.GV29319@disturbed>
Mail-Followup-To: Mikael Abrahamsson <swmike@swm.pp.se>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807111215040.30192@uplift.swm.pp.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 12:21:56PM +0200, Mikael Abrahamsson wrote:
> On Fri, 11 Jul 2008, Dave Chinner wrote:
>
>> That aside, what was the assert failure reported prior to the oops? 
>> i.e. paste the lines in the log before the ---[ cut here ]--- line? One 
>> of them will start with 'Assertion failed:', I think....
>
> These ones?
>
> Jul  8 04:44:56 via kernel: [554197.888008] Assertion failed: whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, line: 5879
> Jul  9 03:25:21 via kernel: [42940.748007] Assertion failed: whichfork == XFS_ATTR_FORK || ip->i_delayed_blks == 0, file: fs/xfs/xfs_bmap.c, line: 5879

That implies a flush to disk failed to write everything, but no error was
reported back to the flush. Not particularly conclusive what caused
your problem.

That being said, it's not a fatal error - it simply means that
the bmap will return a bogus block number reported for the delalloc
extent that still exists. 

This implies an in-memory error, not an on-disk error...

> I should also say that this assert failue happened two nights in a row so 
> I guess it's fairly reproducible (didn't happen on the 10th, and today,  
> the 11th it seems to have panic:ed around 03:30 (I start the  
> defragmentation via cron at 03:00) which I think is related.

Can you find the file it is failing on and run 'xfs_bmap -vvp
<file>' to just extract the extent map outside the context of
xfs_fsr?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
