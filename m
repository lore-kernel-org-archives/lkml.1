Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbZCWQsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbZCWQsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:48:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755978AbZCWQrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:47:52 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:5728 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbZCWQrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:47:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s+EMKWoyG4ELT+gd+4GXQKBlxxTDx2B/J5ZF17TuQqpPiHb8J+hU1VJusLdFKkQ3tu
         L0TDg+/UbVRqc5EsWP+GluRJCZVqq0GkM1Ui5V6jcJsfagCKgT6tbYwQ9SHq6B3ikLpz
         UnTpt+Cd2sqR0AbxxSSVbocVpfMyTiQzcmiMo=
Date: Mon, 23 Mar 2009 17:47:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, daniel@caiaq.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/ftrace] kernel/trace/trace_functions_graph.c: fix
	nsecs_str buffer size
Message-ID: <20090323164745.GB5988@nowhere>
References: <1237824637-28190-1-git-send-email-daniel@caiaq.de> <tip-603b9b9081ae0a1af986b9059a0a5055876ddea9@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-603b9b9081ae0a1af986b9059a0a5055876ddea9@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 04:42:27PM +0000, Daniel Mack wrote:
> Commit-ID:  603b9b9081ae0a1af986b9059a0a5055876ddea9
> Gitweb:     http://git.kernel.org/tip/603b9b9081ae0a1af986b9059a0a5055876ddea9
> Author:     Daniel Mack <daniel@caiaq.de>
> AuthorDate: Mon, 23 Mar 2009 17:10:37 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 23 Mar 2009 17:40:51 +0100
> 
> kernel/trace/trace_functions_graph.c: fix nsecs_str buffer size
> 
> Impact: fix currently inactive buffer-overflow
> 
> In kernel/trace/trace_functions_graph.c, print_graph_duration(),
> len can be as low as 1 or 2, which could make snprintf() write
> beyond the buffer bounds. (Found by cppcheck, no real-world bug
> occured)
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <1237824637-28190-1-git-send-email-daniel@caiaq.de>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  kernel/trace/trace_functions_graph.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)



Ingo, as I explained to Daniel before (I should have Cc you),
there is no overflow to protect here, so this patch will not
change anything.

This is my bad, I should better comment my code.

Frederic.


 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index e876816..a305472 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -430,7 +430,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s)
>  	unsigned long nsecs_rem = do_div(duration, 1000);
>  	/* log10(ULONG_MAX) + '\0' */
>  	char msecs_str[21];
> -	char nsecs_str[5];
> +	char nsecs_str[8];
>  	int ret, len;
>  	int i;
>  

