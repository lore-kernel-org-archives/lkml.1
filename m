Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbZKKV5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbZKKV5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759389AbZKKV5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:57:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51404 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379AbZKKV5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:57:38 -0500
Subject: Re: [PATCH] ftrace: return error instead of 12 bytes read
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ingo <mingo@elte.hu>
In-Reply-To: <4AFB2C0B.50605@gmail.com>
References: <4AFB2C0B.50605@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 11 Nov 2009 16:57:41 -0500
Message-Id: <1257976661.22249.18.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 22:26 +0100, Roel Kluin wrote:
> A negative error value is required: now we cannot
> distinguish ENOMEM from a valid read of 12 bytes.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Thanks! I'll pull this in right away and get it out to Ingo.

-- Steve

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

