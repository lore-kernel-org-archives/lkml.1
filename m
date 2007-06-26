Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbXFZAOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbXFZAOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 20:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbXFZAOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 20:14:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34838 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbXFZAOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 20:14:36 -0400
Date: Mon, 25 Jun 2007 17:14:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       John Stultz <johnstul@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch -mm 10/28] highres: Improve debug output
Message-Id: <20070625171404.4717ed48.akpm@linux-foundation.org>
In-Reply-To: <20070623124030.575989896@inhelltoy.tec.linutronix.de>
References: <20070623124005.931747831@inhelltoy.tec.linutronix.de>
	<20070623124030.575989896@inhelltoy.tec.linutronix.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007 13:32:35 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

>  	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
> -	    !tick_device_is_functional(dev))
> +		    !tick_device_is_functional(dev)) {
> +
> +		printk(KERN_INFO "Clockevents: "
> +		       "could not switch to one-shot mode:");
> +		if (!dev) {
> +			printk(" no tick device\n");
> +		} else {
> +			if (!tick_device_is_functional(dev))
> +				printk(" %s is not functional.\n", dev->name);
> +			else if (!(dev->features & CLOCK_EVT_FEAT_ONESHOT))
> +				printk(" %s does not support one-shot mode.\n",
> +				       dev->name);
> +		}

There is a logic path through here where the printk doesn't get its \n
termination?  And it will fail to print the reason for the failure, too.

Maybe that's a can't-happen, in which case the CLOCK_EVT_FEAT_ONESHOT test
is superfluous?

