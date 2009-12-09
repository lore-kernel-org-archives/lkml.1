Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZLISFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZLISFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 13:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbZLISF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 13:05:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40566 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488AbZLISF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 13:05:27 -0500
X-Authority-Analysis: v=1.0 c=1 a=sHHlHcWDpqoA:10 a=7U3hwN5JcxgA:10 a=in-ESPKl4uUPddIV0mwA:9 a=tWxkKKHgAJd9_6GkF7YA:7 a=XAb_2VObXJVJCZa2cyJ4RJPY8IEA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][GIT PULL][v2.6.33] tracing: Remove comparing of NULL
 to va_list in trace_array_vprintk()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Carsten Emde <Carsten.Emde@osadl.org>,
       Olof Johansson <olof@lixom.net>, hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <20091209061148.GA14010@elte.hu>
References: <4B01AE5D.1010801@osadl.org>
	 <tip-c13d2f7c3231e873f30db92b96c8caa48f100f33@git.kernel.org>
	 <20091206051352.GA4628@lixom.net> <4B1BAB74.104@osadl.org>
	 <1260332397.2146.38.camel@gandalf.stny.rr.com>
	 <20091209055602.GB2512@elte.hu>  <20091209061148.GA14010@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 09 Dec 2009 13:05:32 -0500
Message-ID: <1260381932.2146.122.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 07:11 +0100, Ingo Molnar wrote:
> -tip testing found that the Alpha defconfig fails to build. (error log 
> attached below)
> 
> To fix this bug i have unpulled this commit for now:
> 
>  efcf61a: tracing: Remove comparing of NULL to va_list in trace_array_vprintk()
> 
> Thanks,
> 
> 	Ingo
> 
> ---------------->
> In file included from /home/mingo/tip/include/linux/ftrace_event.h:5,
>                  from /home/mingo/tip/include/trace/syscall.h:6,
>                  from /home/mingo/tip/include/linux/syscalls.h:71,
>                  from /home/mingo/tip/init/noinitramfs.c:23:

Ah, this was caused by the !CONFIG_TRACING path:

-static inline void trace_print_seq(struct seq_file *m, struct trace_seq *s)
+static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
{
}

Will fix.

Thanks,

-- Steve


