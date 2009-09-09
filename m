Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZIIQ6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZIIQ6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZIIQ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:58:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45604 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbZIIQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:58:04 -0400
Subject: Re: [PATCH] ftrace.h: TP_fast_assign - use do {} while (0);
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Joe Perches <joe@perches.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1252514933.28130.45.camel@Joe-Laptop.home>
References: <1252514933.28130.45.camel@Joe-Laptop.home>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 09 Sep 2009 12:58:05 -0400
Message-Id: <1252515485.27001.25.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 09:48 -0700, Joe Perches wrote:
> Perhaps this is a more kernel style standard way to allow
> local variables in TP_fast_assign.
> 
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=a9c1c3abe1160a5632e48c929b02b740556bf423
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index f64fbaa..4c99bdc 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -142,7 +142,7 @@
>  #define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
>  
>  #undef TP_fast_assign
> -#define TP_fast_assign(args...) args
> +#define TP_fast_assign(args...) do { args } while (0);
>  
>  #undef TP_perf_assign
>  #define TP_perf_assign(args...)

This is not a normal macro that is used globally. I like the referenced
commit better, because it shows where it is used what is happening.
Note, TP_fast_assign is just a parameter into another macro, and using
do { } while (0) is not really going to help change anything. This
doesn't even remove a checkpatch warning.

-- Steve


