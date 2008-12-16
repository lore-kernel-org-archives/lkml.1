Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYLPI01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYLPI01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 03:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYLPIZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 03:25:53 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57396 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbYLPIZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 03:25:52 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mmotm][PATCH] proc: enclose desc variable of show_stat() in CONFIG_SPARSE_IRQ
Cc: kosaki.motohiro@jp.fujitsu.com, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081216002247.100bc362.akpm@linux-foundation.org>
References: <20081216165758.DBB2.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081216002247.100bc362.akpm@linux-foundation.org>
Message-Id: <20081216172455.DBBB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 16 Dec 2008 17:25:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This would be better, no?

Agreed. sorry sending silly patch.



> --- a/fs/proc/stat.c~proc-enclose-desc-variable-of-show_stat-in-config_sparse_irq
> +++ a/fs/proc/stat.c
> @@ -28,7 +28,6 @@ static int show_stat(struct seq_file *p,
>  	u64 sum_softirq = 0;
>  	struct timespec boottime;
>  	unsigned int per_irq_sum;
> -	struct irq_desc *desc;
>  
>  	user = nice = system = idle = iowait =
>  		irq = softirq = steal = cputime64_zero;
> @@ -48,8 +47,7 @@ static int show_stat(struct seq_file *p,
>  		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
>  		for_each_irq_nr(j) {
>  #ifdef CONFIG_SPARSE_IRQ
> -			desc = irq_to_desc(j);
> -			if (!desc)
> +			if (!irq_to_desc(j))
>  				continue;
>  #endif
>  			sum += kstat_irqs_cpu(j, i);
> @@ -103,8 +101,7 @@ static int show_stat(struct seq_file *p,
>  	for_each_irq_nr(j) {
>  		per_irq_sum = 0;
>  #ifdef CONFIG_SPARSE_IRQ
> -		desc = irq_to_desc(j);
> -		if (!desc) {
> +		if (!irq_to_desc(j)) {
>  			seq_printf(p, " %u", per_irq_sum);
>  			continue;
>  		}
> _
> 



