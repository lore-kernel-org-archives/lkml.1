Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbZC0Jgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbZC0Jgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZC0Jf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:35:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59989 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758838AbZC0Jf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:35:56 -0400
Message-ID: <49CC9DB2.9000705@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 17:34:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix wrong format string iter for printk
References: <49CC9739.30107@cn.fujitsu.com> <49CC97B6.7040809@cn.fujitsu.com>
In-Reply-To: <49CC97B6.7040809@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhaolei wrote:
> printk("%Q");
> Output before patch:
> %QQ
> Output after patch:
> %Q
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  lib/vsprintf.c |   16 ----------------
>  1 files changed, 0 insertions(+), 16 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 908dd41..b56f6d0 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -1062,13 +1062,6 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  			if (str < end)
>  				*str = '%';
>  			++str;
> -			if (*fmt) {
> -				if (str < end)
> -					*str = *fmt;
> -				++str;
> -			} else {
> -				--fmt;
> -			}
>  			break;
>  
>  		case FORMAT_TYPE_NRCHARS: {
> @@ -1356,8 +1349,6 @@ do {									\
>  			break;
>  
>  		case FORMAT_TYPE_INVALID:
> -			if (!*fmt)
> -				--fmt;
>  			break;
>  
>  		case FORMAT_TYPE_NRCHARS: {
> @@ -1544,13 +1535,6 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
>  			if (str < end)
>  				*str = '%';
>  			++str;
> -			if (*fmt) {
> -				if (str < end)
> -					*str = *fmt;
> -				++str;
> -			} else {
> -				--fmt;
> -			}
>  			break;
>  
>  		case FORMAT_TYPE_NRCHARS:

It's nice.
Review-by: Lai Jiangshan <laijs@cn.fujitsu.com>


