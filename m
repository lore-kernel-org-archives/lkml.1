Return-Path: <linux-kernel-owner+w=401wt.eu-S1760955AbZJMUpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbZJMUpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760444AbZJMUpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:45:00 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:57502 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760292AbZJMUo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ThHrhrcScnfG7Iuwl0rk8ocm8DjAiAmIBY84Sfia7tX0Chs8UjGCUd+CPM8SERM5G2
         Ku2JjfH5W3NTNjXS8elONABbdQZ7149iWHWhoVlxj3JbeaSx/EYY9zZTDSaSd6CHkbPV
         qQpGq7LnLDlqFsAQylpAXdyyrsaxbylcUjKXQ=
Date: Tue, 13 Oct 2009 22:43:47 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] [PATCH 2/5] tracing: export symbols for kernel
	lock tracepoints
Message-ID: <20091013204345.GA5135@nowhere>
References: <20091013203349.814936710@goodmis.org> <20091013203425.342967518@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013203425.342967518@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 04:33:51PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The big kernel lock tracepoints are used inside modules and they need
> to be exported accordingly.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  lib/kernel_lock.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
> index 4ebfa5a..76f05bc 100644
> --- a/lib/kernel_lock.c
> +++ b/lib/kernel_lock.c
> @@ -139,3 +139,5 @@ void __lockfunc _unlock_kernel(const char *func, const char *file, int line)
>  EXPORT_SYMBOL(_lock_kernel);
>  EXPORT_SYMBOL(_unlock_kernel);
>  
> +EXPORT_TRACEPOINT_SYMBOL(lock_kernel);
> +EXPORT_TRACEPOINT_SYMBOL(unlock_kernel);
> -- 


I remember when you showed me this patch, and it fixed a real
issue because we had the tracepoint call in smp_lock.h:

#define lock_kernel()	\
	trace_lock_kernel(__FUNC__, __FILE__, __LINE__);	\
	_lock_kernel();						\

So indeed the modules needed this missing export. But I had
to move the tracepoint calls to lib/kernel_lock.c instead,
because we had very bad headers dependencies.

So it's not needed anymore.

