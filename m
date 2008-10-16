Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYJPXQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYJPXQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbYJPXQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:16:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756778AbYJPXQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:16:39 -0400
Date: Thu, 16 Oct 2008 16:15:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, jdike@addtoit.com, stable@kernel.org
Subject: Re: [Patch] uml: fix one compile error
Message-Id: <20081016161557.af935f49.akpm@linux-foundation.org>
In-Reply-To: <20081016152626.GD13374@hack.voiplan.pt>
References: <20081016152626.GD13374@hack.voiplan.pt>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 16:26:26 +0100
Am__rico Wang <xiyou.wangcong@gmail.com> wrote:

> 
> This patch fixed the following compile error:
> 
>   CC      arch/um/sys-i386/signal.o
>   /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c: In
> function 'copy_sc_from_user':
> /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c:182:
> warning: dereferencing 'void *' pointer
> /home/wangcong/Projects/linux-2.6/arch/um/sys-i386/signal.c:182:
> error: request for member '_fxsr_env' in something not a structure or
> union
> 
> 
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> Cc: jdike@addtoit.com
> 
> ---
> diff --git a/arch/um/sys-i386/signal.c b/arch/um/sys-i386/signal.c
> index fd0c25a..1296473 100644
> --- a/arch/um/sys-i386/signal.c
> +++ b/arch/um/sys-i386/signal.c
> @@ -179,7 +179,8 @@ static int copy_sc_from_user(struct pt_regs *regs,
>  	if (have_fpx_regs) {
>  		struct user_fxsr_struct fpx;
>  
> -		err = copy_from_user(&fpx, &sc.fpstate->_fxsr_env[0],
> +		err = copy_from_user(&fpx,
> +			&((struct _fpstate __user *)sc.fpstate)->_fxsr_env[0],
>  				     sizeof(struct user_fxsr_struct));
>  		if (err)
>  			return 1;

Which kernel versions are affected by this error? 2.6.27?

Thanks.
