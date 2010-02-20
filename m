Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab0BTVZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 16:25:00 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54258 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0BTVY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 16:24:58 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 20 Feb 2010 22:24:43 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: <linux/wait.h> requires <linux/sched.h> (was Re: [PATCH 3/4]
 firewire: get_cycle_timer optimization and cleanup)
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.f36b636501d78192@s5r6.in-berlin.de>
Message-ID: <tkrat.5fa896f03c3d0c16@s5r6.in-berlin.de>
References: <tkrat.a3f2efe539e59c19@s5r6.in-berlin.de>
 <tkrat.f36b636501d78192@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 Feb, Stefan Richter wrote:
> --- linux-2.6.33-rc8.orig/drivers/firewire/core-cdev.c
> +++ linux-2.6.33-rc8/drivers/firewire/core-cdev.c
[...]
> @@ -32,8 +33,6 @@
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/poll.h>
> -#include <linux/preempt.h>
> -#include <linux/sched.h>
>  #include <linux/spinlock.h>
>  #include <linux/string.h>
>  #include <linux/time.h>
[...]

This doesn't compile on some configurations.  core-cdev.c requires (and
includes) linux/wait.h which in turn requires (but does not include)
linux/sched.h.

However, adding #include <linux/sched.h> in wait.h isn't going to be
possible very easily; there are a whole lot of missing definitions in
other headers that are pulled in by sched.h then.

Hence I will simply readd sched.h to firewire/core-cdev.c.
-- 
Stefan Richter
-=====-==-=- --=- =-=--
http://arcgraph.de/sr/

