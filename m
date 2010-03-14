Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab0CNQ4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 12:56:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48590 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759543Ab0CNQ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 12:56:08 -0400
X-Authority-Analysis: v=1.0 c=1 a=TmnEcBdXtfUA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=lLfAgDd_-pBZhNCkeTEA:9 a=AS9MVfcgP3RRJrkHsM9HxBl-ipwA:4 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 04/10] ARM: ftrace: allow building without frame
 pointers
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <1268462987-8271-5-git-send-email-rabin@rab.in>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
	 <1268462987-8271-5-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Mar 2010 12:56:06 -0400
Message-ID: <1268585766.13400.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-13 at 12:19 +0530, Rabin Vincent wrote:
> With a new enough GCC, ARM function tracing can be supported without the
> need for frame pointers.  This is essential for Thumb-2 support, since
> frame pointers aren't available then.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>

> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 13e13d4..e10519f 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -124,7 +124,7 @@ if FTRACE
>  config FUNCTION_TRACER
>  	bool "Kernel Function Tracer"
>  	depends on HAVE_FUNCTION_TRACER
> -	select FRAME_POINTER
> +	select FRAME_POINTER if (!ARM_UNWIND)

I'm fine with this if the ARM maintainers are.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  	select KALLSYMS
>  	select GENERIC_TRACER
>  	select CONTEXT_SWITCH_TRACER



