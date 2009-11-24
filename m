Return-Path: <linux-kernel-owner+w=401wt.eu-S932598AbZKXKOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbZKXKOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:14:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932536AbZKXKOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:14:01 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46996 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbZKXKOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:14:00 -0500
Date: Tue, 24 Nov 2009 11:14:03 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Luming Yu <luming.yu@gmail.com>
Subject: Re: [PATCH 1/2] hrtimer: correct a few numbers in comments and
	printk outputs
Message-ID: <20091124101403.GA25364@pengutronix.de>
References: <1258745020-28060-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091123152516.729e1407.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091123152516.729e1407.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Mon, Nov 23, 2009 at 03:25:16PM -0800, Andrew Morton wrote:
> On Fri, 20 Nov 2009 20:23:39 +0100
> Uwe Kleine-K__nig  <u.kleine-koenig@pengutronix.de> wrote:
> 
> > @@ -52,7 +52,7 @@ int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
> >  			printk(KERN_WARNING
> >  			       "CE: %s increasing min_delta_ns to %lu nsec\n",
> >  			       dev->name ? dev->name : "?",
> > -			       dev->min_delta_ns << 1);
> > +			       dev->min_delta_ns);
> >  
> >  			i = 0;
> >  		}
> 
> This one's already in linux-next:
> 
> @@ -50,9 +50,9 @@ int tick_dev_program_event(struct clock_
>  				dev->min_delta_ns += dev->min_delta_ns >> 1;
>  
>  			printk(KERN_WARNING
> -			       "CE: %s increasing min_delta_ns to %lu nsec\n",
> +			       "CE: %s increasing min_delta_ns to %llu nsec\n",
>  			       dev->name ? dev->name : "?",
> -			       dev->min_delta_ns << 1);
> +			       (unsigned long long) dev->min_delta_ns << 1);
'<< 1' is wrong here, too.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
