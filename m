Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbYGQVYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbYGQVYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932978AbYGQVYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:24:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932902AbYGQVYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:24:17 -0400
Date: Thu, 17 Jul 2008 14:23:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       stable@kernel.org
Subject: Re: [PATCH] Fix build on COMPAT platforms when CONFIG_EPOLL is
 disabled.
Message-Id: <20080717142314.1aeb2f58.akpm@linux-foundation.org>
In-Reply-To: <20080718.003108.128619119.anemo@mba.ocn.ne.jp>
References: <20080718.003108.128619119.anemo@mba.ocn.ne.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 00:31:08 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> Add missing cond_syscall() entry for compat_sys_epoll_pwait.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> ---
> diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
> index 5b9b467..0fea0ee 100644
> --- a/kernel/sys_ni.c
> +++ b/kernel/sys_ni.c
> @@ -59,6 +59,7 @@ cond_syscall(sys_epoll_create);
>  cond_syscall(sys_epoll_ctl);
>  cond_syscall(sys_epoll_wait);
>  cond_syscall(sys_epoll_pwait);
> +cond_syscall(compat_sys_epoll_pwait);
>  cond_syscall(sys_semget);
>  cond_syscall(sys_semop);
>  cond_syscall(sys_semtimedop);

Interesting.  It appears that both 2.6.25.x and 2.6.26.x need this
fix as well.
