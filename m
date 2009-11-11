Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbZKKVro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbZKKVro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759366AbZKKVrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:47:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759359AbZKKVrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:47:42 -0500
Date: Wed, 11 Nov 2009 13:47:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ingo <mingo@elte.hu>,
       rostedt@goodmis.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] ftrace: return error instead of 12 bytes read
Message-Id: <20091111134730.a0da9e38.akpm@linux-foundation.org>
In-Reply-To: <4AFB2C0B.50605@gmail.com>
References: <4AFB2C0B.50605@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009 22:26:35 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> A negative error value is required: now we cannot
> distinguish ENOMEM from a valid read of 12 bytes.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  kernel/trace/trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index b20d3ec..03c7fd5 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3730,7 +3730,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
>  
>  	s = kmalloc(sizeof(*s), GFP_KERNEL);
>  	if (!s)
> -		return ENOMEM;
> +		return -ENOMEM;
>  
>  	trace_seq_init(s);
>  

lol, there we go again.

Andy, can we have a checkpatch rule please?
