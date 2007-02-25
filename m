Return-Path: <linux-kernel-owner+w=401wt.eu-S964797AbXBYKpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797AbXBYKpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 05:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964801AbXBYKpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 05:45:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40470 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964800AbXBYKpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 05:45:15 -0500
Date: Sun, 25 Feb 2007 11:45:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
       ego@in.ibm.com, akpm@osdl.org, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       Aneesh Kumar <aneesh.kumar@gmail.com>
Subject: Re: [RFC][PATCH 7/7] Freezer: Add try_to_freeze calls to all kernel threads
Message-ID: <20070225104511.GL2045@elf.ucw.cz>
References: <200702231116.23607.rjw@sisk.pl> <200702231126.52473.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702231126.52473.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Add try_to_freeze() calls to the remaining kernel threads that do not call
> try_to_freeze() already, although they set PF_NOFREEZE.
> 
> In the future we are going to replace PF_NOFREEZE with a set of flags that will
> be set to indicate in which situations the task should not be frozen (for
> example, there can be a task that should be frozen for the CPU hotplugging and
> should not be frozen for the system suspend).  For this reason every kernel
> thread should be able to freeze itself (ie. call try_to_freeze()), so that it
> can be frozen whenever necessary.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Looks ok to me. ACK.

> @@ -113,6 +114,8 @@ static int mtd_blktrans_thread(void *arg
>  			schedule();
>  			remove_wait_queue(&tr->blkcore_priv->thread_wq, &wait);
>  
> +			try_to_freeze();
> +
>  			spin_lock_irq(rq->queue_lock);
>  
>  			continue;

I'd prefer to move try_to_freeze() just after schedule().
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
