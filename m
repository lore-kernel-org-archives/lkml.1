Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbYIPCwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbYIPCwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 22:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYIPCwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 22:52:12 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:26217 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753827AbYIPCwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 22:52:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAHy7zkh5LD0i/2dsb2JhbAC4UoFl
X-IronPort-AV: E=Sophos;i="4.32,405,1217773800"; 
   d="scan'208";a="207122590"
Date: Tue, 16 Sep 2008 12:52:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.27-rc6: lockdep warning: iprune_mutex at
	shrink_icache_memory+0x38/0x1a8
Message-ID: <20080916025204.GL5811@disturbed>
Mail-Followup-To: Alexander Beregalov <a.beregalov@gmail.com>, rjw@sisk.pl,
	linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
References: <20080913233138.GA19576@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080913233138.GA19576@orion>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 03:31:38AM +0400, Alexander Beregalov wrote:
> Hi
> 
> [ INFO: possible circular locking dependency detected ]
> 2.6.27-rc6-00034-gd1c6d2e #3
> -------------------------------------------------------
> nfsd/1766 is trying to acquire lock:
>  (iprune_mutex){--..}, at: [<c01743fb>] shrink_icache_memory+0x38/0x1a8
> 
>  but task is already holding lock:
>   (&(&ip->i_iolock)->mr_lock){----}, at: [<c021134f>]
>   xfs_ilock+0xa2/0xd6
> 
> 
> I read files through nfs and saw delay for few seconds.
> System is x86_32, nfs, xfs.
> The last working kernel is 2.6.27-rc5,
> I do not know yet is it reproducible or not.

<sigh>

We need a FAQ for this one. It's a false positive.  Google for an
explanation - I've explained it 4 or 5 times in the past year and
asked that the lockdep folk invent a special annotation for the
iprune_mutex (or memory reclaim) because of the way it can cause
recursion into the filesystem and hence invert lock orders without
causing deadlocks.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
