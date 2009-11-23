Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbZKWX1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbZKWX1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756642AbZKWX1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:27:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755852AbZKWX1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:27:37 -0500
Date: Mon, 23 Nov 2009 15:25:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Luming Yu <luming.yu@gmail.com>
Subject: Re: [PATCH 1/2] hrtimer: correct a few numbers in comments and
 printk outputs
Message-Id: <20091123152516.729e1407.akpm@linux-foundation.org>
In-Reply-To: <1258745020-28060-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1258745020-28060-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 20:23:39 +0100
Uwe Kleine-K__nig  <u.kleine-koenig@pengutronix.de> wrote:

> @@ -52,7 +52,7 @@ int tick_dev_program_event(struct clock_event_device *dev, ktime_t expires,
>  			printk(KERN_WARNING
>  			       "CE: %s increasing min_delta_ns to %lu nsec\n",
>  			       dev->name ? dev->name : "?",
> -			       dev->min_delta_ns << 1);
> +			       dev->min_delta_ns);
>  
>  			i = 0;
>  		}

This one's already in linux-next:

@@ -50,9 +50,9 @@ int tick_dev_program_event(struct clock_
 				dev->min_delta_ns += dev->min_delta_ns >> 1;
 
 			printk(KERN_WARNING
-			       "CE: %s increasing min_delta_ns to %lu nsec\n",
+			       "CE: %s increasing min_delta_ns to %llu nsec\n",
 			       dev->name ? dev->name : "?",
-			       dev->min_delta_ns << 1);
+			       (unsigned long long) dev->min_delta_ns << 1);
 
 			i = 0;
 		}
