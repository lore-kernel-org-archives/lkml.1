Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZLCOld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZLCOld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 09:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbZLCOld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 09:41:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39014 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbZLCOlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 09:41:32 -0500
Subject: Re: [tip:tracing/urgent] tracing: Fix event format export
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johannes@sipsolutions.net, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-811cb50baf63461ce0bdb234927046131fc7fa8b@git.kernel.org>
References: <20091113224009.GB23942@elte.hu>
	 <tip-811cb50baf63461ce0bdb234927046131fc7fa8b@git.kernel.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 03 Dec 2009 09:41:37 -0500
Message-Id: <1259851297.12870.134.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-14 at 10:18 +0000, tip-bot for Johannes Berg wrote:
> Commit-ID:  811cb50baf63461ce0bdb234927046131fc7fa8b
> Gitweb:     http://git.kernel.org/tip/811cb50baf63461ce0bdb234927046131fc7fa8b
> Author:     Johannes Berg <johannes@sipsolutions.net>
> AuthorDate: Fri, 13 Nov 2009 23:40:09 +0100
> Committer:  Steven Rostedt <rostedt@goodmis.org>
> CommitDate: Fri, 13 Nov 2009 22:20:34 -0500
> 
> tracing: Fix event format export
> 
> For some reason the export of the event print format to userspace
> uses '#fmt' which breaks if the format string is anything but a plain
> string, for example if it is built with macros then the macro names
> are exported instead of their contents.
> 
> Use
> 	"\"%s\"", fmt
> instead of
> 	"%s", #fmt
> to export the string and not the way it is built.
> 
> For example, in net/mac80211/driver-trace.h for the trace event drv_start
> there is:
> 
>         TP_printk(
>                 LOCAL_PR_FMT, LOCAL_PR_ARG
>         )
> 
> Which use to produce:
> 
>  print fmt: LOCAL_PR_FMT, REC->wiphy_name
> 
> Now produces:
> 
>  print fmt: "%s", REC->wiphy_name
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> LKML-Reference: <20091113224009.GB23942@elte.hu>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Ingo,

Any reason that this did not make it into Mainline? 2.6.32 is out, and
Johannes Berg was depending on this for his users.

-- Steve

> ---
>  include/trace/ftrace.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index cc0d966..dacb8ef 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -159,7 +159,7 @@
>  #undef __get_str
>  
>  #undef TP_printk
> -#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
> +#define TP_printk(fmt, args...) "\"%s\", %s\n", fmt, __stringify(args)
>  
>  #undef TP_fast_assign
>  #define TP_fast_assign(args...) args

