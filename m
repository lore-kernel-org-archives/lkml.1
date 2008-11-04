Return-Path: <linux-kernel-owner+w=401wt.eu-S1757106AbYKDX7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbYKDX7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758901AbYKDXzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:55:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760905AbYKDXzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:55:53 -0500
Date: Tue, 4 Nov 2008 15:54:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fork.c: cleanup for copy_sighand()
Message-Id: <20081104155455.f0b0e5b1.akpm@linux-foundation.org>
In-Reply-To: <490AC707.1060808@cn.fujitsu.com>
References: <490AC707.1060808@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008 16:51:19 +0800
Zhaolei <zhaolei@cn.fujitsu.com> wrote:

> Check CLONE_SIGHAND only is enough, because combination of CLONE_THREAD and
> CLONE_SIGHAND is already done in copy_process().
> 
> Impact: cleanup, no functionality changed
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  kernel/fork.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index f608356..36a0dac 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -741,7 +741,7 @@ static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
>  {
>  	struct sighand_struct *sig;
>  
> -	if (clone_flags & (CLONE_SIGHAND | CLONE_THREAD)) {
> +	if (clone_flags & CLONE_SIGHAND) {
>  		atomic_inc(&current->sighand->count);
>  		return 0;
>  	}

OK, it appears to be correct and might yield a tiny speedup on some
architectures.

But whether this change is desirable from a clarity and maintainability
point of view is unclear to me.  Let's add the cc's..

