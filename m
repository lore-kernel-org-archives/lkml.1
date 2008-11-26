Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbYKZFi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbYKZFi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbYKZFiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:38:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750749AbYKZFiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:38:20 -0500
Date: Tue, 25 Nov 2008 21:37:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/5] ftrace: add thread comm to function graph tracer
Message-Id: <20081125213748.2cd86b2b.akpm@linux-foundation.org>
In-Reply-To: <20081126051710.149585354@goodmis.org>
References: <20081126051622.134970943@goodmis.org>
	<20081126051710.149585354@goodmis.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008 00:16:26 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> Impact: enhancement to function graph tracer
> 
> Export the trace_find_cmdline so the function graph tracer can
> use it to print the comms of the threads.
> 
> -static char *trace_find_cmdline(int pid)
> +char *trace_find_cmdline(int pid)
>
> ...
>
>  static int verif_pid(struct trace_seq *s, pid_t pid)
>  {
> +	char *comm;
> +
>  	if (last_pid != -1 && last_pid == pid)
>  		return 1;
>  
>  	last_pid = pid;
> -	return trace_seq_printf(s, "\n------------8<---------- thread %d"
> +	comm = trace_find_cmdline(pid);
> +
> +	return trace_seq_printf(s, "\n------------8<---------- thread %s-%d"
>  				    " ------------8<----------\n\n",
> -				  pid);
> +				    comm, pid);
>  }

This code gets its int's and pid_t's all mixed up.  It's a bit cosmetic, but
nice to get it right for readability's sake.
