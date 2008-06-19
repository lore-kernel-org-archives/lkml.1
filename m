Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYFSAtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYFSAtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbYFSAtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:49:15 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:40642 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532AbYFSAtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:49:14 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 20:49:14 EDT
Message-ID: <4859AB75.3020906@freedesktop.org>
Date: Wed, 18 Jun 2008 17:42:29 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dvhltc@us.ibm.com,
       niv@us.ibm.com, dino@in.ibm.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, vegard.nossum@gmail.com,
       adobriyan@gmail.com, oleg@tv-sign.ru, bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH] Make rcutorture more vicious: reinstate boot-time testing
References: <20080618122144.GA27143@linux.vnet.ibm.com> <20080618162649.GA18326@linux.vnet.ibm.com>
In-Reply-To: <20080618162649.GA18326@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Hello again!
> 
> This patch re-institutes the ability to build rcutorture directly into
> the Linux kernel.  The reason that this capability was removed was that
> this could result in your kernel being pretty much useless, as rcutorture
> would be running starting from early boot.  This problem has been avoided
> by (1) making rcutorture run only three seconds of every six by default,
> (2) adding a CONFIG_RCU_TORTURE_TEST_RUNNABLE that permits rcutorture
> to be quiesced at boot time, and (3) adding a sysctl in /proc named
> /proc/sys/kernel/rcutorture_runnable that permits rcutorture to be
> quiesced and unquiesced when built into the kernel.
> 
> Please note that this /proc file is -not- available when rcutorture
> is built as a module.  Please also note that to get the earlier
> take-no-prisoners behavior, you must use the boot command line to set
> rcutorture's "stutter" parameter to zero.
> 
> The rcutorture quiescing mechanism is currently quite crude: loops
> in each rcutorture process that poll a global variable once per tick.
> Suggestions for improvement are welcome.  The default action will
> be to reduce the polling rate to a few times per second.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Suggested-by: Ingo Molnar <mingo@elte.hu>

This patch looks quite reasonable to me.

Signed-off-by: Josh Triplett <josh@kernel.org>

- Josh Triplett

