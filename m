Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbXLNRng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbXLNRng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 12:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXLNRnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 12:43:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53112 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754523AbXLNRnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 12:43:24 -0500
Date: Fri, 14 Dec 2007 09:41:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Satyam Sharma <satyam@infradead.org>, David Jones <davej@redhat.com>
Subject: Re: [PATCH] Don't mark cpufreq_stats_free_table with __cpuexit
Message-Id: <20071214094144.601dcddf.akpm@linux-foundation.org>
In-Reply-To: <20071214134548.GA15149@flint.arm.linux.org.uk>
References: <20071214134548.GA15149@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 13:45:48 +0000 Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> Commit 55395ae72b6e5ae614d28df74158c47454652583 introduced:
> 
> `.exit.text' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
> 
> Never mark functions that may be called during run time or
> initialisation time with a section that may be (or have been)
> discarded.
> 
> It was mentioned in the commit comments that an exit-section function
> was being called from an init-section function.  This should _always_
> result in the patch being rejected.  It's just a big no no.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index 8a45d0f..bf5f780 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -164,7 +164,8 @@ freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
>  	return -1;
>  }
>  
> -static void __cpuexit cpufreq_stats_free_table(unsigned int cpu)
> +/* functions called from init paths can not be marked for an exit section */
> +static void /*__cpuexit*/ cpufreq_stats_free_table(unsigned int cpu)
>  {
>  	struct cpufreq_stats *stat = cpufreq_stats_table[cpu];
>  	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
> 

yu, thanks, I have a fix for this from Adrian queued for when Linus
resurfaces.

