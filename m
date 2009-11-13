Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbZKMWkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbZKMWkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbZKMWkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:40:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37309 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760AbZKMWkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:40:14 -0500
Date: Fri, 13 Nov 2009 23:40:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.32] ftrace: fix event format export
Message-ID: <20091113224009.GB23942@elte.hu>
References: <1258115870.6167.4.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258115870.6167.4.camel@johannes.local>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


( extended the Cc:s. Please try to Cc: people you think would be 
  interested in your patches. )

* Johannes Berg <johannes@sipsolutions.net> wrote:

> For some reason the export of the event print
> format to userspace uses '#fmt' which breaks
> if the format string is anything but a plain
> string, for example if it is built with macros
> then the macro names are exported instead of
> their contents.
> 
> Use
> 	"\"%s\"", fmt
> instead of
> 	"%s", #fmt
> to export the string and not the way it is built.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> This is making the export of a bunch of events (only checked the
> wireless ones but those are all affected) unusable, so please apply to
> 2.6.32.
> 
>  include/trace/ftrace.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- wireless-testing.orig/include/trace/ftrace.h	2009-11-13 13:15:21.000000000 +0100
> +++ wireless-testing/include/trace/ftrace.h	2009-11-13 13:34:03.000000000 +0100
> @@ -159,7 +159,7 @@
>  #undef __get_str
>  
>  #undef TP_printk
> -#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
> +#define TP_printk(fmt, args...) "\"%s\", %s\n", fmt, __stringify(args)
>  
>  #undef TP_fast_assign
>  #define TP_fast_assign(args...) args
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
