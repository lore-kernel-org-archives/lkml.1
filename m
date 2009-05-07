Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbZEGLyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbZEGLyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbZEGLyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:54:41 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:61923 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754647AbZEGLyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:54:40 -0400
Message-ID: <4A02CBFF.4000901@rsk.demon.co.uk>
Date: Thu, 07 May 2009 12:54:39 +0100
From: Richard Kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] introduce "struct wait_opts" to simplify do_wait()
   pathes
References: <20090507064637.GA15861@redhat.com>
In-Reply-To: <20090507064637.GA15861@redhat.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> Introduce "struct wait_opts" which holds the parameters for misc helpers
> in do_wait() pathes.
> 
> This adds 13 lines to kernel/exit.c, but saves 256 bytes from .o and imho
> makes the code much more readable.
> 
> This patch temporary uglifies rusage/siginfo code a little bit, will be
> addressed by further cleanups.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-by: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  kernel/exit.c |  207 ++++++++++++++++++++++++++++++----------------------------
>  1 file changed, 110 insertions(+), 97 deletions(-)
> 
> --- PTRACE/kernel/exit.c~2_WOPTS	2009-05-07 04:32:08.000000000 +0200
> +++ PTRACE/kernel/exit.c	2009-05-07 04:37:49.000000000 +0200
> @@ -1076,6 +1076,18 @@ SYSCALL_DEFINE1(exit_group, int, error_c
>  	return 0;
>  }
>  
> +struct wait_opts {
> +	enum pid_type		wo_type;
> +	struct pid		*wo_pid;
> +	int			wo_flags;
> +
> +	struct siginfo __user	*wo_info;
> +	int __user		*wo_stat;
> +	struct rusage __user	*wo_rusage;
> +
> +	int			notask_error;
> +};
> +

Hi Oleg,
you can remove 8 bytes of alignment padding from wait_opts on 64bit
builds if you reorder it slightly.

struct wait_opts {
	enum pid_type 	wo_type;
	int 		wo_flags;
	struct pid	*wo_pid;
	...



regards
Richard

