Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbXJGXgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbXJGXgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 19:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbXJGXgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 19:36:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34669 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751072AbXJGXgb (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 19:36:31 -0400
Date: Mon, 8 Oct 2007 09:36:18 +1000
From: David Chinner <dgc@sgi.com>
To: Laurent Caron <lcaron@lncsa.com>
Cc: drbd-user@linbit.com, linux-kernel@vger.kernel.org
Subject: Re: Crash on 2.6.21.7 Vanilla + DRBD 0.7
Message-ID: <20071007233618.GV995458@sgi.com>
References: <20071004092111.ahweigho@trusted.lncsa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004092111.ahweigho@trusted.lncsa.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 09:29:40AM +0200, Laurent Caron wrote:
> 
> Hi,
> 
> I did compile a fresh 2.6.21.7 kernel from kernel.org (no distro patch, ....), and latest svn (3062) 0.7.X drbd.
> 
> After just 2 days of uptime, I did experience another crash.
> 
> I wonder if it is an XFS related bug, a DRBD one, or related to XFS on top of DRBD.
> 
> This bug seems to occur with intensive IO operations.
> 
> What do you think about it ?

This still looks like memory corruption of some sort:. I'd
suspect DRBD at this point because nobody is repprting this against
other block devices in 2.6.21....

> Oct  3 18:55:23  kernel: Oops: 0002 [#1]
> Oct  3 18:55:23  kernel: SMP 
> Oct  3 18:55:23  kernel: CPU:    7
> Oct  3 18:55:23  kernel: EIP:    0060:[<c016540c>]    Not tainted VLI
> Oct  3 18:55:23  kernel: EFLAGS: 00010046   (2.6.21-dl380-g5-20071001 #1)
> Oct  3 18:55:23  kernel: EIP is at cache_alloc_refill+0x11c/0x4f0

Can you turn on slab debug and poisoning and see where
the kernel fails with that? e.g. set:

CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SLAB_LEAK=y

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
