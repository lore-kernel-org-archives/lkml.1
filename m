Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbXD0VmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbXD0VmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757353AbXD0VmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:42:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36229 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352AbXD0VmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:42:07 -0400
Date: Sat, 28 Apr 2007 03:10:47 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] Introduce freezer flags
Message-ID: <20070427214047.GA21224@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200704271737.31192.rjw@sisk.pl> <200704271740.17972.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704271740.17972.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 05:40:16PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Move all of the freezer-related flags to a separate field in task_struct and
> introduce functions to operate them using set_bit() etc.
> 
> 
> Index: linux-2.6.21-rc7-mm2/include/linux/sched.h
> ===================================================================
> --- linux-2.6.21-rc7-mm2.orig/include/linux/sched.h
> +++ linux-2.6.21-rc7-mm2/include/linux/sched.h
> @@ -1006,7 +1006,10 @@ struct task_struct {
>  	/* Deadlock detection and priority inheritance handling */
>  	struct rt_mutex_waiter *pi_blocked_on;
>  #endif
> -
> +#ifdef CONFIG_FREEZER
> +	/* Used by the process freezer, defined in freezer.h */
> +	unsigned int freezer_flags;

unsigned long freezer_flags; ??

Else it throws the following warnings.

include/linux/freezer.h: In function `frozen':
include/linux/freezer.h:22: warning: passing arg 2 of
`constant_test_bit' from incompatible pointer type
include/linux/freezer.h:22: warning: passing arg 2 of
`variable_test_bit' from incompatible pointer type
include/linux/freezer.h: In function `set_frozen_flag':
include/linux/freezer.h:27: warning: passing arg 2 of `set_bit' from
incompatible pointer type
include/linux/freezer.h: In function `clear_frozen_flag':
include/linux/freezer.h:32: warning: passing arg 2 of `clear_bit' from
incompatible pointer type
include/linux/freezer.h: In function `freezing':
include/linux/freezer.h:40: warning: passing arg 2 of
`constant_test_bit' from incompatible pointer type
include/linux/freezer.h:40: warning: passing arg 2 of
`variable_test_bit' from incompatible pointer type
include/linux/freezer.h: In function `freeze':
include/linux/freezer.h:48: warning: passing arg 2 of `set_bit' from
incompatible pointer type
include/linux/freezer.h: In function `clear_freeze_flag':
include/linux/freezer.h:56: warning: passing arg 2 of `clear_bit' from
incompatible pointer type
include/linux/freezer.h: In function `freezer_should_exempt':
include/linux/freezer.h:64: warning: passing arg 2 of
`constant_test_bit' from incompatible pointer type
include/linux/freezer.h:64: warning: passing arg 2 of
`variable_test_bit' from incompatible pointer type
include/linux/freezer.h: In function `freezer_exempt':
include/linux/freezer.h:72: warning: passing arg 2 of `set_bit' from
incompatible pointer type
include/linux/freezer.h: In function `freezer_do_not_count':
include/linux/freezer.h:132: warning: passing arg 2 of `set_bit' from
incompatible pointer type
include/linux/freezer.h: In function `freezer_count':
include/linux/freezer.h:142: warning: passing arg 2 of `clear_bit' from
incompatible pointer type
include/linux/freezer.h: In function `freezer_should_skip':
include/linux/freezer.h:152: warning: passing arg 2 of
`constant_test_bit' from incompatible pointer type
include/linux/freezer.h:152: warning: passing arg 2 of
`variable_test_bit' from incompatible pointer type

Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
