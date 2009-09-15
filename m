Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbZIOG4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbZIOG4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZIOG4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:56:02 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:37547 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbZIOG4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:56:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19119.14970.129589.518079@cargo.ozlabs.ibm.com>
Date: Tue, 15 Sep 2009 16:55:54 +1000
From: Paul Mackerras <paulus@samba.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_counter: fix buffer overflow in perf_copy_attr()
In-Reply-To: <4AAF37D4.5010706@cn.fujitsu.com>
References: <4AAF37D4.5010706@cn.fujitsu.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong writes:

> If we pass a big size data over perf_counter_open syscall, the kernel
> will copy this data to a small buffer, It will cause kernel crash.
> 
> This bug make kernel unsafe and no-root user can trigger it.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  kernel/perf_counter.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
> index 667ab25..75c46c0 100644
> --- a/kernel/perf_counter.c
> +++ b/kernel/perf_counter.c
> @@ -4216,6 +4216,7 @@ static int perf_copy_attr(struct perf_counter_attr __user *uattr,
>  			if (val)
>  				goto err_size;
>  		}
> +		size = sizeof(*attr);

Looks right to me.

Acked-by: Paul Mackerras <paulus@samba.org>
