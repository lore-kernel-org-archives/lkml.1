Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab0BDTwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:52:50 -0500
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:51014 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322Ab0BDTwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:52:49 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2010 14:52:49 EST
Date: Thu, 4 Feb 2010 20:45:36 +0100
From: Paolo Ornati <ornati@fastwebnet.it>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BISECTED] post -rc6 regression, X server crash.
Message-ID: <20100204204536.3316dff0@fastwebnet.it>
In-Reply-To: <20100204143630.GA18161@emergent.ellipticsemi.com>
References: <20100204143630.GA18161@emergent.ellipticsemi.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 09:36:30 -0500
Nick Bowler <nbowler@elliptictech.com> wrote:

> I'm using Intel KMS with xf86-video-intel 2.10.0.  I bisected the issue
> to the following commit.  Reverting the commit allows Xorg to start
> again.
> 
> 859ddf09743a8cc680af33f7259ccd0fd36bfe9d is the first bad commit
> commit 859ddf09743a8cc680af33f7259ccd0fd36bfe9d
> Author: Tejun Heo <tj@kernel.org>
> Date:   Tue Feb 2 13:43:58 2010 -0800
> 
>     idr: fix a critical misallocation bug

Me too, with different chipset and driver version.

Reverting that commit fixes the problem for me.

xf86-video-intel 2.9.1

Xorg.0.log
=============
...
(II) intel(0): Integrated Graphics Chipset: Intel(R) 965G
...

Backtrace:
0: X(xorg_backtrace+0x26) [0x4ec0e6]
1: X(xf86SigHandler+0x39) [0x491769]
2: /lib/libc.so.6 [0x7fbf6439e3a0]
3: /usr/lib64/xorg/modules/drivers//intel_drv.so [0x7fbf62dc5b28]
4: /usr/lib64/xorg/modules/drivers//intel_drv.so(gen4_render_state_init+0x41f) [0x7fbf62dc6eff]
5: /usr/lib64/xorg/modules/drivers//intel_drv.so [0x7fbf62d9d115]
6: /usr/lib64/xorg/modules/drivers//intel_drv.so [0x7fbf62d9e333]
7: X(AddScreen+0x1c6) [0x430ae6]
8: X(InitOutput+0x241) [0x46b421]
9: X(main+0x200) [0x4311f0]
10: /lib/libc.so.6(__libc_start_main+0xe6) [0x7fbf6438aa26]
11: X [0x430839]

Fatal server error:
Caught signal 11.  Server aborting

-- 
	Paolo Ornati
	Linux 2.6.33-rc6-00155-gdb8b522 on x86_64
