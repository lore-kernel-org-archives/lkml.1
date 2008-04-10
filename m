Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYDJTJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYDJTJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYDJTJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:09:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbYDJTJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:09:11 -0400
Date: Thu, 10 Apr 2008 12:08:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, mtk.manpages@googlemail.com,
       stable@kernel.org
Subject: Re: [patch] signalfd fix for incorrect SI_QUEUE user data reporting
Message-Id: <20080410120845.8e7132d8.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804101152090.9668@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0804101152090.9668@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008 11:57:44 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> Michael Kerrisk found out that signalfd was not reporting back user data 
> pushed using sigqueue:
> 
> http://groups.google.com/group/linux.kernel/msg/9397cab8551e3123
> 
> The following patch makes signalfd to report back the ssi_ptr and ssi_int 
> members of the signalfd_siginfo structure.
> 
> 
> 
> Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> 
> 
> - Davide
> 
> 
> ---
>  fs/signalfd.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.mod/fs/signalfd.c
> ===================================================================
> --- linux-2.6.mod.orig/fs/signalfd.c	2008-04-09 11:53:37.000000000 -0700
> +++ linux-2.6.mod/fs/signalfd.c	2008-04-09 12:05:46.000000000 -0700
> @@ -111,9 +111,14 @@
>  		err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
>  		err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
>  		break;
> -	default: /* this is just in case for now ... */
> +	default:
> +		/*
> +		 * This case catches also the signals queued by sigqueue().
> +		 */
>  		err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
>  		err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
> +		err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
> +		err |= __put_user(kinfo->si_int, &uinfo->ssi_int);
>  		break;
>  	}
>  

I queued this for both 2.6.25 and 2.6.24.x.  Agree?
