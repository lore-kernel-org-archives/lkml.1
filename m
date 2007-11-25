Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXKYGkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXKYGkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 01:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXKYGjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 01:39:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52516 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbXKYGjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 01:39:44 -0500
Date: Sat, 24 Nov 2007 22:39:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: youquan_song@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Corey Minyard <minyard@acm.org>,
       Wim Van Sebroeck <wim@iguana.be>
Subject: Re: ipmi_watchdog can not reset the kernel panic machine
Message-Id: <20071124223920.212b36e3.akpm@linux-foundation.org>
In-Reply-To: <2097.172.16.96.111.1195878521.squirrel@linux.intel.com>
References: <2097.172.16.96.111.1195878521.squirrel@linux.intel.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(cc's added)

On Fri, 23 Nov 2007 20:28:41 -0800 (PST) youquan_song@linux.intel.com wrote:

> Build kernel-2.6.24-rc3.  pmi_watchdog can not reset the kernel panic
> machine.  The watchdog can never to record panic information to IPMI SEL.
> 
> 1. I disable auto reset when kernel panic by echo "0" >
> /proc/sys/kernel/panic
> 
> 2.  modprobe ipmi_watchdog timeout=120 action=reset
> 
> 3.  Load a driver, the driver will call panic() when  ioctl to call into
> the driver.
> 
> 4.  By ioctl call into the driver,  panic the system.
> 
> in wdog_panic_handler, I printk "ipmi_watchdog_state=WDOG_TIMEOUT_NONE"
> so, the watchdog can never to record panic information to IPMI SEL.
> 
> 
> static int wdog_panic_handler(struct notifier_block *this,
> 			      unsigned long         event,
> 			      void                  *unused)
> {
> 	static int panic_event_handled = 0;
> 
> 	/* On a panic, if we have a panic timeout, make sure to extend
> 	   the watchdog timer to a reasonable value to complete the
> 	   panic, if the watchdog timer is running.  Plus the
> 	   pretimeout is meaningless at panic time. */
> 	if (watchdog_user && !panic_event_handled &&
> 	    ipmi_watchdog_state != WDOG_TIMEOUT_NONE) {
> 		/* Make sure we do this only once. */
> 		panic_event_handled = 1;
> 
> 		timeout = 255;
> 		pretimeout = 0;
> 		panic_halt_ipmi_set_timeout();
> 	}
> 
> 	return NOTIFY_OK;
> }

