Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYLaIbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYLaIbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYLaIba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:31:30 -0500
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:33952 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbYLaIb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:31:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnIDAN+7Wkl5LB1fgWdsb2JhbACTewEBFiK4K4ZE
X-IronPort-AV: E=Sophos;i="4.36,307,1228051800"; 
   d="scan'208";a="284811694"
Date: Wed, 31 Dec 2008 19:31:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: tux3@tux3.org, sniper <s3c24xx@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Message-ID: <20081231083123.GF10725@disturbed>
Mail-Followup-To: Daniel Phillips <phillips@phunq.net>, tux3@tux3.org,
	sniper <s3c24xx@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <200812301935.49303.phillips@phunq.net> <9bd6b5360812302334t2c6aca67s62ba54438d2bda9e@mail.gmail.com> <200812310000.55256.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812310000.55256.phillips@phunq.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 12:00:54AM -0800, Daniel Phillips wrote:
> On Tuesday 30 December 2008 23:34, sniper wrote:
> > Great, I have mounted tux3 filesystem under UML with stuffs in this mail,
> > but I still can't debug it with gdb. Anyone gives me suggestion?
....
> In the mean time, you could just tell gdb to mask off all segfaults,
> but would be kind of problematic for debugging.

Not really. That's the default setting I use for XFS debugging. I
just put breakpoints on "panic" and "stop" (sometimes
bust_spinlocks) and just let the kernel panic routine handle the
segv which will trip a breakpoint. Then just walk back up the stack
to the function that triggered the real SEGV and go from there.

This is pretty much necessary for XFS debugging because
just mounting a filesystem causes 8-10 SEGV signals to occur.
You simply can't run xfsqa when that is occurring...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
