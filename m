Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYJDU6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYJDU6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 16:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYJDU6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 16:58:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:36328 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbYJDU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 16:58:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Quksm3G35P7979QAXRdXGvlwNF4A/TzIR0hFQQiHi3uGLYS4wXszsRxeiDuV2iZrix
         BPD9CJ38pa946gR6eCpSWci+zBfZkA3oqz3Jsx2MTV8WjmJZLkwJYp3j4b6uDLcC3O+o
         gJ6qoe62gWLYViTE6zuT59NvWnPvq4c4RMkQU=
Message-ID: <c62985530810041358p1cc361b1te89894cedcd7e3b3@mail.gmail.com>
Date: Sat, 4 Oct 2008 22:58:12 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [patch] fix printk format typo in boot ftracer.
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20081004134227.465fa20c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081004134227.465fa20c@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/4 Arjan van de Ven <arjan@infradead.org>:
> When printing nanoseconds, the right printk format string is %09 not %06...
>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>
> diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
> index a7efe35..d0a5e50 100644
> --- a/kernel/trace/trace_boot.c
> +++ b/kernel/trace/trace_boot.c
> @@ -62,14 +62,14 @@ static enum print_line_t initcall_print_line(struct trace_iterator *iter)
>        struct timespec rettime = ktime_to_timespec(it->rettime);
>
>        if (entry->type == TRACE_BOOT) {
> -               ret = trace_seq_printf(s, "[%5ld.%06ld] calling  %s @ %i\n",
> +               ret = trace_seq_printf(s, "[%5ld.%09ld] calling  %s @ %i\n",
>                                          calltime.tv_sec,
>                                          calltime.tv_nsec,
>                                          it->func, it->caller);
>                if (!ret)
>                        return TRACE_TYPE_PARTIAL_LINE;
>
> -               ret = trace_seq_printf(s, "[%5ld.%06ld] initcall %s "
> +               ret = trace_seq_printf(s, "[%5ld.%09ld] initcall %s "
>                                          "returned %d after %lld msecs\n",
>                                          rettime.tv_sec,
>                                          rettime.tv_nsec,

I picked these formats from the printk.c time formatting. But you're right,
09 would give us the whole nano precision.
