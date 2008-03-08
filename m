Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYCHUTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYCHUTn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 15:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYCHUTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 15:19:33 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:49023 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbYCHUTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 15:19:33 -0500
Date: Sat, 8 Mar 2008 23:19:09 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] waitid si_code regression
Message-ID: <20080308201909.GA83@tv-sign.ru>
References: <20080308194122.4EEB226F991@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308194122.4EEB226F991@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Roland McGrath wrote:
> 
> In commit ee7c82da830ea860b1f9274f1f0cdf99f206e7c2, the magic (short)
> cast when storing si_code was lost in wait_task_stopped.  This leaks
> the in-kernel CLD_* values that do not match what userland expects.
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index cd20bf0..53872bf 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -1378,7 +1378,7 @@ unlock_sig:
>  	if (!retval && infop)
>  		retval = put_user(0, &infop->si_errno);
>  	if (!retval && infop)
> -		retval = put_user(why, &infop->si_code);
> +		retval = put_user((short)why, &infop->si_code);

Ugh, thanks.

Oleg.

