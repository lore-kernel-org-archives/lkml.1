Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbZLNMCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbZLNMCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757055AbZLNMCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:02:00 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:42106 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbZLNMCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:02:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jFJmQUZlxn5+KtmqmTOgvo3bIftAwXZB7405QbKCm+LcLfjFYDBUu0elxwbeWBnLJQ
         WwYWMNY6EEmNAr2dp9p9pYcT8hjD7zO4QE8Hq8wt/GdSUkiHDO+oVfeEsAF1b/A2iNAL
         +A6qc793mHo5IfEZ15lgbwCUXlxfigFIy/N8M=
Date: Mon, 14 Dec 2009 13:01:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] trace_syscalls: fix SYSCALL_DEFINE0
Message-ID: <20091214120152.GG5168@nowhere>
References: <4B1F4E86.9040207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1F4E86.9040207@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 03:15:18PM +0800, Lai Jiangshan wrote:
> 
> struct syscall_metadata variable name in SYSCALL_DEFINE0
> is not the same as SYSCALL_DEFINE1/2/3/4/5/6.
> 
> SYSCALL_TRACE_ENTER_EVENT() and SYSCALL_TRACE_EXIT_EVENT() expect
> struct syscall_metadata's name is __syscall_meta__XXXXXX
> as SYSCALL_DEFINE1/2/3/4/5/6 defines.
> 
> It causes event_enter_##sname->data points to a wrong place.
> (event_enter_##sname->data points to a dummy struct syscall_metadata)
> 
> It causes syscalls which are defined by SYSCALL_DEFINE0() can not be traced.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 55e7108..bee1d41 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -196,7 +196,7 @@ struct perf_event_attr;
>  	static const struct syscall_metadata __used		\
>  	  __attribute__((__aligned__(4)))			\
>  	  __attribute__((section("__syscalls_metadata")))	\
> -	  __syscall_meta_##sname = {				\
> +	  __syscall_meta__##sname = {				\
>  		.name 		= "sys_"#sname,			\
>  		.nb_args 	= 0,				\
>  		.enter_event	= &event_enter__##sname,	\


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

