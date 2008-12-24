Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbYLXD2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbYLXD2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 22:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYLXD15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 22:27:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63025 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYLXD14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 22:27:56 -0500
Message-ID: <4951AB76.3030709@cn.fujitsu.com>
Date: Wed, 24 Dec 2008 11:24:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: enable format arguments checking
References: <494CB7A2.1070603@cn.fujitsu.com>
In-Reply-To: <494CB7A2.1070603@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> format arguments checking for ftrace_printk() is __printf(1, 2),
> not __printf(1, 0).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 9c5bc6b..0c71788 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -210,7 +210,7 @@ extern void ftrace_dump(void);
>  static inline void
>  ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
>  static inline int
> -ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 0)));

Hi, Steven Rostedt
	Did you notice this patch?
	This patch changed a char in a line: s/0/2/. It enables the format checking.

	Lai.

> +ftrace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
>  
>  static inline int
>  ftrace_printk(const char *fmt, ...)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


