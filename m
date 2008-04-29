Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYD2Dzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYD2Dzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYD2Dzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:55:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874AbYD2Dzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:55:31 -0400
Date: Mon, 28 Apr 2008 20:55:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bernd Schubert <bernd-schubert@gmx.de>,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 008 of 9] md: md: raid5 rate limit error printk
Message-Id: <20080428205522.28dce527.akpm@linux-foundation.org>
In-Reply-To: <1080429033534.20399@suse.de>
References: <20080429133104.20146.patches@notabene>
	<1080429033534.20399@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 13:35:34 +1000 NeilBrown <neilb@suse.de> wrote:

> +			printk_rl(KERN_WARNING "raid5:%s: read error NOT corrected!! "
> +				  "(sector %llu on %s).\n",
> +				  mdname(conf->mddev),
> +				  (unsigned long long)(sh->sector + rdev->data_offset),
> +				  bdn);
>  		else if (atomic_read(&rdev->read_errors)
>  			 > conf->max_nr_stripes)
>  			printk(KERN_WARNING
> 
> diff .prev/include/linux/raid/md_k.h ./include/linux/raid/md_k.h
> --- .prev/include/linux/raid/md_k.h	2008-04-29 12:25:24.000000000 +1000
> +++ ./include/linux/raid/md_k.h	2008-04-29 12:27:58.000000000 +1000
> @@ -368,6 +368,9 @@ static inline void safe_put_page(struct 
>  	if (p) put_page(p);
>  }
>  
> +#define printk_rl  printk_ratelimit() ?: printk

(boggle)

Isn't this backwards?  Should be !printk_ratelimit()?

open-coding the printk_ratelimit() at each callsite would be more
conventional.
