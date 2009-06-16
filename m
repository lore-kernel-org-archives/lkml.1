Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbZFPQNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbZFPQNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbZFPQNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:13:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36715 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbZFPQNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:13:36 -0400
Date: Tue, 16 Jun 2009 12:13:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Roel Kluin <roel.kluin@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tracing: Keep index within map_pid_to_cmdline[]
In-Reply-To: <4A37DDEA.3080003@gmail.com>
Message-ID: <alpine.DEB.2.00.0906161212550.26673@gandalf.stny.rr.com>
References: <4A37DDEA.3080003@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Jun 2009, Roel Kluin wrote:

> Ensure that index `pid' remains within array map_pid_to_cmdline[]
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 8acd9b8..f359e9e 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -803,7 +803,7 @@ void trace_find_cmdline(int pid, char comm[])
>  		return;
>  	}
>  
> -	if (pid > PID_MAX_DEFAULT) {
> +	if (pid > PID_MAX_DEFAULT || pid < 0) {
>  		strcpy(comm, "<...>");
>  		return;
>  	}

Did you ever hit a case where pid was < 0? Or is this just a "safety 
patch"?

-- Steve

