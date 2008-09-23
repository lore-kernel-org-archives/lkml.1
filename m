Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYIWGDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYIWGDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 02:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYIWGDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 02:03:39 -0400
Received: from gw.goop.org ([64.81.55.164]:37321 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbYIWGDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 02:03:38 -0400
Message-ID: <48D886BB.80804@goop.org>
Date: Mon, 22 Sep 2008 23:03:39 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Hugh Dickins <hugh@veritas.com>, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 2/2] corruption check: run the corruption checks from
 a work queue
References: <20080922195810.624d777a@infradead.org> <20080922195839.5bf7bd62@infradead.org>
In-Reply-To: <20080922195839.5bf7bd62@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> -void start_periodic_check_for_corruption(void)
> +
> +
> +int start_periodic_check_for_corruption(void)
>   
Couldn't this be static now?

>  {
>  	if (!memory_corruption_check || corruption_check_period == 0)
> -		return;
> +		return 0;
>  
>  	printk(KERN_INFO "Scanning for low memory corruption every %d seconds\n",
>  	       corruption_check_period);
>  
>  	init_timer(&periodic_check_timer);
>  	periodic_check_timer.function = &periodic_check_for_corruption;
> -	periodic_check_for_corruption(0);
> +	mod_timer(&periodic_check_timer,
> +			round_jiffies(jiffies + corruption_check_period*HZ));
> +
> +	return 0;
>  }
> +
> +module_init(start_periodic_check_for_corruption);

    J
