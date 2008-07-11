Return-Path: <linux-kernel-owner+w=401wt.eu-S1757145AbYGKInD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbYGKInD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 04:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYGKImx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 04:42:53 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:22459 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbYGKImw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 04:42:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABW4dkh5LFxA/2dsb2JhbACwKg
X-IronPort-AV: E=Sophos;i="4.30,343,1212330600"; 
   d="scan'208";a="146660671"
Date: Fri, 11 Jul 2008 18:42:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: xfs bug in 2.6.26-rc9
Message-ID: <20080711084248.GU29319@disturbed>
Mail-Followup-To: Mikael Abrahamsson <swmike@swm.pp.se>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 09:46:47AM +0200, Mikael Abrahamsson wrote:
>
> I received this when running xfs_fsr to defragment my xfs volume (which  
> resides on a crypted lvm).

Hmmmm. XFS has a history of triggering unique bugs in crypted
volumes - thank you for letting us know up front that this is
what you are using.

> Could it be that something is wrong with my xfs volume and this is not  
> being properly handled (since it seems to refer to getbmap below?).

Could be - xfs_check will tell you if there is anything wrong with
it.

> Kernel is configured with oldconfig from ubuntu hardy stock kernel plus  
> Alsa. Hardware can be seen at  
> <https://bugs.launchpad.net/ubuntu/+source/linux/+bug/235074>.
>
> Kernel oopsed (caps lock+other flashing when I woke up this morning),  
> don't know if it's related to the below bug or if it's something else.  
> Screensaver was on so I couldn't see any text to see more info.
>
> Jul  8 04:44:56 via kernel: [554197.888008] ------------[ cut here ]------------
> Jul  8 04:44:56 via kernel: [554197.888008] kernel BUG at fs/xfs/support/debug.c:81!
> Jul  8 04:44:56 via kernel: [554197.888008] invalid opcode: 0000 [#1] SMP
> Jul  8 04:44:56 via kernel: [554197.888008] Modules linked in: soundcore  
> ac97_bus isofs udf crc_itu_t nvidia(P) af_packet rfcomm l2c
                               ^^^^^^^^^

That could also be a factor.

>  Pid: 16200, comm: xfs_fsr Tainted: P          (2.6.26-rc8 #1)
>  EIP: 0060:[<f956201b>] EFLAGS: 00010282 CPU: 0
>  EIP is at assfail+0x1b/0x20 [xfs]
             ^^^^^^^

Oh - you must be running a debug XFS.  CONFIG_XFS_DEBUG was only
introduced in 2.6.26-rc1 and defaults to 'N', so you must have
selected the non-default option when prompted. This will cause your
machine to oops at the slightest inconsistency that is found,
regardless of whether it is fatal or not. Like the help text says,
don't set this unless you are an XFS developer....

That aside, what was the assert failure reported prior to the oops? i.e.
paste the lines in the log before the ---[ cut here ]--- line?
One of them will start with 'Assertion failed:', I think....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
