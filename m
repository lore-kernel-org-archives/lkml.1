Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbZIOHkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbZIOHkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 03:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZIOHkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 03:40:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35935 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZIOHkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 03:40:20 -0400
Subject: Re: [PATCH] perf_counter: fix buffer overflow in perf_copy_attr()
From: Peter Zijlstra <peterz@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AAF37D4.5010706@cn.fujitsu.com>
References: <4AAF37D4.5010706@cn.fujitsu.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 09:40:14 +0200
Message-Id: <1253000414.5506.11.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 14:44 +0800, Xiao Guangrong wrote:
> If we pass a big size data over perf_counter_open syscall, the kernel
> will copy this data to a small buffer, It will cause kernel crash.
> 
> This bug make kernel unsafe and no-root user can trigger it.

Ah, indeed. Thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

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
>  	}
>  
>  	ret = copy_from_user(attr, uattr, size);

