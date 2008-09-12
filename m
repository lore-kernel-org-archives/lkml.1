Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYILTVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYILTVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbYILTVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:21:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755439AbYILTVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:21:44 -0400
Date: Fri, 12 Sep 2008 12:20:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com
Subject: Re: [PATCH] apci: dump slit
Message-Id: <20080912122031.eca8723e.akpm@linux-foundation.org>
In-Reply-To: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008 11:17:48 -0700
Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  drivers/acpi/numa.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: linux-2.6/drivers/acpi/numa.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/numa.c
> +++ linux-2.6/drivers/acpi/numa.c
> @@ -150,6 +150,14 @@ static __init int slit_valid(struct acpi
>  {
>  	int i, j;
>  	int d = slit->locality_count;
> +	printk(KERN_DEBUG "ACPI: SLIT: nodes = %d\n", d);
> +	for (i = 0; i < d; i++) {
> +		for (j = 0; j < d; j++)  {
> +			u8 val = slit->entry[d*i + j];
> +			printk(" %d", val);
> +		}
> +		printk("\n");
> +	}
>  	for (i = 0; i < d; i++) {
>  		for (j = 0; j < d; j++)  {
>  			u8 val = slit->entry[d*i + j];

why?
