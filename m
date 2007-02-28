Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbXB1N1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbXB1N1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 08:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932319AbXB1N1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 08:27:48 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50734 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932318AbXB1N1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 08:27:47 -0500
Date: Wed, 28 Feb 2007 18:57:34 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228132734.GA17050@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702272251.28844.rjw@sisk.pl> <20070228030113.GJ29179@in.ibm.com> <20070228035149.GL29179@in.ibm.com> <200702281211.04515.rjw@sisk.pl> <20070228131721.GD15509@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228131721.GD15509@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 06:47:21PM +0530, Srivatsa Vaddagiri wrote:
> --- workqueue.c.org	2007-02-28 18:32:48.000000000 +0530
> +++ workqueue.c	2007-02-28 18:44:23.000000000 +0530
> @@ -718,6 +718,8 @@ static void cleanup_workqueue_thread(str
>  		insert_wq_barrier(cwq, &barr, 1);
>  		cwq->should_stop = 1;
>  		alive = 1;
> +		if (frozen(cwq->thread))
> +			thaw(cwq->thread);

I meant thaw_process(cwq->thread) 

>  	}
>  	spin_unlock_irq(&cwq->lock);

-- 
Regards,
vatsa
