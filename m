Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbXE2SQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbXE2SQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbXE2SQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:16:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16327 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbXE2SQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:16:14 -0400
Date: Tue, 29 May 2007 11:22:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Make usb-autosuspend timer 1 sec jiffy aligned
Message-Id: <20070529112230.c2687091.randy.dunlap@oracle.com>
In-Reply-To: <20070529175821.GA5411@linux-os.sc.intel.com>
References: <20070529175821.GA5411@linux-os.sc.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 10:58:21 -0700 Venki Pallipadi wrote:

> 
> 
> Below are a bunch of random timers, that were active on my system,
> that can better be round_jiffies() aligned.

and these 4 patches help with (a) power usage, or (b) cache
usage/niceness, or (c) other (be specific)...

Thanks.

> I guess we need a audit of all timer usages atleast in kernel-core.
> 
> This patch:
> 
> Make usb autosuspend timers 1sec jiffy aligned.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> Index: linux-2.6.22-rc-mm/drivers/usb/core/driver.c
> ===================================================================
> --- linux-2.6.22-rc-mm.orig/drivers/usb/core/driver.c	2007-05-24 11:16:00.000000000 -0700
> +++ linux-2.6.22-rc-mm/drivers/usb/core/driver.c	2007-05-25 10:00:50.000000000 -0700
> @@ -974,7 +974,7 @@
>  			 * or for the past.
>  			 */
>  			queue_delayed_work(ksuspend_usb_wq, &udev->autosuspend,
> -					suspend_time - jiffies);
> +				round_jiffies_relative(suspend_time - jiffies));
>  			}
>  		return -EAGAIN;
>  	}
> -

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
