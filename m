Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbZFWHV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbZFWHV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbZFWHVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:21:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47778 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZFWHVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:21:20 -0400
Date: Tue, 23 Jun 2009 09:21:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, hidave.darkstar@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: +
	printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
	added to -mm tree
Message-ID: <20090623072116.GC5747@elte.hu>
References: <200906230556.n5N5uG3a017246@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906230556.n5N5uG3a017246@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2194]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +++ a/kernel/printk.c
> @@ -198,12 +198,11 @@ __setup("log_buf_len=", log_buf_len_setu
>  #ifdef CONFIG_BOOT_PRINTK_DELAY
>  
>  static unsigned int boot_delay; /* msecs delay after each printk during bootup */
> -static unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
> +static unsigned long long loops_per_msec;

Lost a comment here - on purpose?

> -	printk_delay_msec = loops_per_msec;
>  	printk(KERN_DEBUG "boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
> -		"HZ: %d, printk_delay_msec: %llu\n",
> -		boot_delay, preset_lpj, lpj, HZ, printk_delay_msec);
> +		"HZ: %d, loops_per_msec: %llu\n",
> +		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);

If you touch debug printks then please use pr_debug().

	Ingo
