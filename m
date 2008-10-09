Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYJIXCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYJIXCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 19:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbYJIXCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 19:02:32 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:52258 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbYJIXCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 19:02:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhQDAFkp7kh5LGoriGdsb2JhbACTWQEBARUirAGBag
X-IronPort-AV: E=Sophos;i="4.33,385,1220193000"; 
   d="scan'208";a="226047809"
Date: Fri, 10 Oct 2008 10:02:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Sean Purdy <sean-kernel@purdy.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: XFS internal error xfs_trans_cancel in 2.6.27
Message-ID: <20081009230227.GL9597@disturbed>
Mail-Followup-To: Sean Purdy <sean-kernel@purdy.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20081009113610.F13062@moloch.hellmouth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009113610.F13062@moloch.hellmouth.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2008 at 11:36:10AM +0100, Sean Purdy wrote:
> Hi,
> 
> 
> Further to the discussion (and patching) of an xfs_trans_cancel
> issue in June, in kernel < 2.6.26
> 
> A similar issue came up on one disk of a 4 x 750GiB machine
> with a 2.6.24 kernel.  So I installed 2.6.27-6 and gave it another try.
> But I'm still seeing the same problem.  Remounting the drive each time
> is fine, and xfs_check shows no errors.

2.6.27-6? You mean 2.6.27-rc6?

Anyway, you need to try this patch:

http://oss.sgi.com/archives/xfs/2008-10/msg00105.html

which I posted a few days ago that fixes the latest reproducable
case of this shutdown that I know of.

If that patch doesn't fix it, what you need to do is get the
filesystem into a state where this sequence of commands can be
repeated:

# mount <dev> <mntpt>
# cd <mntpt>/some/dir/in/fs/where/error/is/occurring
# touch <somefile>
[ filesystem shuts down ]

At that point, if you provide me with an xfs_metadump image and
the exact commands to reproduce the shutdown, I will be able to
find the problem and patch it pretty quickly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
