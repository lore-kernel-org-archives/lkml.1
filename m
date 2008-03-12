Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbYCLQf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbYCLQf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYCLQfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:35:50 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:35150 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYCLQfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:35:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 12 Mar 2008 09:35:43 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] signals: send_signal: be paranoid about signalfd_notify()
In-Reply-To: <20080312131716.GA14324@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0803120934360.30443@alien.or.mcafeemobile.com>
References: <20080312131716.GA14324@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Oleg Nesterov wrote:

> send_signal() shouldn't call signalfd_notify() if it then fails with -EAGAIN.
> Harmless, just a paranoid cleanup.
> 
> Also remove the comment. It is obsolete, signalfd_notify() was simplified and
> does a simple wakeup.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Looks fine to me.

Acked-by: Davide Libenzi <davidel@xmailserver.org>



> 
> --- 25/kernel/signal.c~3_SS_NOTIFY	2008-03-12 15:16:52.000000000 +0300
> +++ 25/kernel/signal.c	2008-03-12 15:55:47.000000000 +0300
> @@ -769,13 +769,6 @@ static int send_signal(int sig, struct s
>  	 */
>  	if (legacy_queue(pending, sig))
>  		return 0;
> -
> -	/*
> -	 * Deliver the signal to listening signalfds. This must be called
> -	 * with the sighand lock held.
> -	 */
> -	signalfd_notify(t, sig);
> -
>  	/*
>  	 * fast-pathed signals for kernel-internal things like SIGSTOP
>  	 * or SIGKILL.
> @@ -825,6 +818,7 @@ static int send_signal(int sig, struct s
>  	}
>  
>  out_set:
> +	signalfd_notify(t, sig);
>  	sigaddset(&pending->signal, sig);
>  	complete_signal(sig, t, group);
>  	return 0;
> 


- Davide


