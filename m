Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbZGHKS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbZGHKS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZGHKSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:18:05 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38212 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbZGHKSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:18:04 -0400
Date: Wed, 8 Jul 2009 06:17:56 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: fix reported unit for RLIMIT_CPU
Message-ID: <20090708101756.GA6000@hmsreliant.think-freely.org>
References: <20090708042331.GT11156@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708042331.GT11156@outflux.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 09:23:32PM -0700, Kees Cook wrote:
> /proc/$pid/limits should show RLIMIT_CPU as seconds, which is the unit
> used in kernel/posix-cpu-timers.c:
> 
>         unsigned long psecs = cputime_to_secs(ptime);
>         ...
>         if (psecs >= sig->rlim[RLIMIT_CPU].rlim_max) {
>                 ...
>                 __group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  fs/proc/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 3ce5ae9..5891360 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -461,7 +461,7 @@ struct limit_names {
>  };
>  
>  static const struct limit_names lnames[RLIM_NLIMITS] = {
> -	[RLIMIT_CPU] = {"Max cpu time", "ms"},
> +	[RLIMIT_CPU] = {"Max cpu time", "seconds"},
>  	[RLIMIT_FSIZE] = {"Max file size", "bytes"},
>  	[RLIMIT_DATA] = {"Max data size", "bytes"},
>  	[RLIMIT_STACK] = {"Max stack size", "bytes"},

Yup, thanks!
Acked-by: Neil Horman <nhorman@tuxdriver.com>
