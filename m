Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZFWBD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZFWBD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 21:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZFWBDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 21:03:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53123 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbZFWBDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 21:03:21 -0400
Message-ID: <4A402A4D.3030804@cn.fujitsu.com>
Date: Tue, 23 Jun 2009 09:05:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ftrace: remove redundant test on nsigned
References: <4A3FF508.3000304@gmail.com>
In-Reply-To: <4A3FF508.3000304@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> Unsigned `cnt' cannot be less than 0.
> 

The patch is fine, but there's a typo in the title s/nsigned/unsigned

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Or should it be `if (!cnt || cnt > MAX)' and what should MAX be then?
> 

No, note there is another check:

	if (cnt > EVENT_BUF_SIZE)
		cnt = EVENT_BUF_SIZE;

> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index aa08be6..b83f030 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -204,7 +204,7 @@ ftrace_event_write(struct file *file, const char __user *ubuf,
>  	char *buf;
>  	char ch;
>  
> -	if (!cnt || cnt < 0)
> +	if (!cnt)
>  		return 0;
>  
>  	ret = tracing_update_buffers();
> --
