Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab0BWNrE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 08:47:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49624 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab0BWNrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 08:47:00 -0500
X-Authority-Analysis: v=1.0 c=1 a=0zAnwTMcbsIA:10 a=bFw54WxwBiv1EkgVNhoA:9 a=rNbgzg3rPDkqqXqu2AJlvDbOUbUA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 03/10] ftrace: allow building without frame pointers
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <1266090518-31120-4-git-send-email-rabin@rab.in>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
	 <1266090518-31120-4-git-send-email-rabin@rab.in>
Content-Type: text/plain
Date: Tue, 23 Feb 2010 08:44:42 -0500
Message-Id: <1266932682.19540.15.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-14 at 01:18 +0530, Rabin Vincent wrote:
> With current gcc, compiling with both -pg and -fomit-frame-pointer is
> not allowed.  However, -pg can be used to build without actually
> specying -fno-omit-frame-pointer, upon which the defaut behaviour for
> the target will be used.
> 
> On ARM, it is not possible to build a Thumb-2 kernel with
> -fno-omit-frame-pointer (FRAME_POINTERS depends on !THUMB2_KERNEL). In
> order to support ftrace for Thumb-2, we need to be able to allow a
> combination of FUNCTION_TRACER and !FRAME_POINTER.  We do this by
> omitting -fomit-frame-pointer if ftrace is enabled.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  Makefile |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 67d6cff..72d90de 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -546,8 +546,11 @@ endif
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
>  else
> +ifndef CONFIG_FUNCTION_TRACER

Is this needed? Selecting FUNCTION_TRACER also selects FRAME_POINTER,
which this change is in the else part of that #if.

-- Steve

> +# -fomit-frame-pointer is incompatible with -pg
>  KBUILD_CFLAGS	+= -fomit-frame-pointer
>  endif
> +endif
>  
>  ifdef CONFIG_DEBUG_INFO
>  KBUILD_CFLAGS	+= -g

