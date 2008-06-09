Return-Path: <linux-kernel-owner+w=401wt.eu-S1758686AbYFISCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758686AbYFISCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYFISCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:02:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:57235 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbYFISCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:02:24 -0400
Subject: Re: [PATCH] 2.6.25.4-rt6: missing global_rt_runtime() in sched.c
From: Daniel Walker <dwalker@mvista.com>
To: ciaby <ciaby@autistici.org>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <7688fdc041a8f848b0627dccccddcf12@localhost>
References: <7688fdc041a8f848b0627dccccddcf12@localhost>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 11:02:20 -0700
Message-Id: <1213034540.16459.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-06-09 at 09:51 +0000, ciaby wrote:
> I already sent this patch, but seems that nobody cared... the last 2
> revisions of the -rt kernel don't compile properly.
> Second patch to fix this.
> Regards
> 
> Giovanni "ciaby" Civardi
> 
> diff -uNr linux-2.6.25.4-rt6.orig/kernel/sched.c
> linux-2.6.25.4-rt6/kernel/sched.c
> --- linux-2.6.25.4-rt6.orig/kernel/sched.c      2008-06-09
> 11:35:57.000000000 +0200
> +++ linux-2.6.25.4-rt6/kernel/sched.c   2008-06-09 11:40:45.000000000 +0200
> @@ -672,6 +672,13 @@
>   */
>  #define RUNTIME_INF    ((u64)~0ULL)
>  
> +static u64 global_rt_runtime(void)
> +{
> +       if (sysctl_sched_rt_period < 0)
> +               return RUNTIME_INF;
> +       return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;

Your patch has a couple of problems .. It's line wrapped, it's missing
proper tabbing (got stripped maybe), and no Signed-off-by: .. 

Daniel

