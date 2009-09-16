Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbZIPNGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbZIPNGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757182AbZIPNGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:06:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35997 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476AbZIPNGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:06:36 -0400
Subject: Re: [PATCH 1/2] tracing: Fix minor bugs for
 __unregister_ftrace_function_probe
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       fweisbec@gmail.com, "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, paulus@samba.org,
       systemtap@sources.redhat.com
In-Reply-To: <4AAF6726.5090905@bk.jp.nec.com>
References: <4AAF6726.5090905@bk.jp.nec.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 16 Sep 2009 09:06:38 -0400
Message-Id: <1253106398.20020.192.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 19:06 +0900, Atsushi Tsuji wrote:
> Fix the condition of strcmp for "*".
> Also fix NULL pointer dereference when glob is NULL.
> 
> Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>


This is a real fix, I'll pull it in separately.

Thanks!

-- Steve

> ---
>  kernel/trace/ftrace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 8c804e2..5ef8f59 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2059,9 +2059,9 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
>  	int i, len = 0;
>  	char *search;
>  
> -	if (glob && (strcmp(glob, "*") || !strlen(glob)))
> +	if (glob && (strcmp(glob, "*") == 0 || !strlen(glob)))
>  		glob = NULL;
> -	else {
> +	else if (glob) {
>  		int not;
>  
>  		type = ftrace_setup_glob(glob, strlen(glob), &search, &not);

