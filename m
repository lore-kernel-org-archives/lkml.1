Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887Ab0ATG4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0ATG4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538Ab0ATG4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:56:16 -0500
Received: from mail.perches.com ([173.55.12.10]:1314 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab0ATG4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:56:16 -0500
Subject: Re: [PATCH 1/2] scsi: add __print_hex() to ftrace
From: Joe Perches <joe@perches.com>
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
In-Reply-To: <4B56A60F.6060207@jp.fujitsu.com>
References: <4B56A60F.6060207@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 22:56:13 -0800
Message-ID: <1263970573.18117.96.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-20 at 15:43 +0900, Kei Tokunaga wrote:
> diff -puN kernel/trace/trace_output.c~ftrace_print_hex kernel/trace/trace_output.c
> --- linux-2.6.33-rc4-trace/kernel/trace/trace_output.c~ftrace_print_hex	2010-01-14 19:55:45.000000000 +0900
> +++ linux-2.6.33-rc4-trace-kei/kernel/trace/trace_output.c	2010-01-14 20:02:49.000000000 +0900
> @@ -355,6 +355,21 @@ ftrace_print_symbols_seq(struct trace_se
>  }
>  EXPORT_SYMBOL(ftrace_print_symbols_seq);
>  
> +const char *
> +ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
> +{
> +	int i;
> +	const char *ret = p->buffer + p->len;
> +
> +	for (i = 0; i < buf_len; i++)
> +		trace_seq_printf(p, "%s%2.2x", i == 0 ? "" : " ", buf[i]);
> +
> +	trace_seq_putc(p, 0);

hex_dump_to_buffer?


