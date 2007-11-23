Return-Path: <linux-kernel-owner+w=401wt.eu-S1753770AbXKWHmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770AbXKWHmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 02:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXKWHmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 02:42:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbXKWHmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 02:42:06 -0500
Date: Thu, 22 Nov 2007 23:41:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: <linux-kernel@vger.kernel.org>, <cbe-oss-dev@ozlabs.org>
Subject: Re: [RFC/PATCH] Export force_sig_info
Message-Id: <20071122234141.087743fa.akpm@linux-foundation.org>
In-Reply-To: <1194845812.531937.269801315194.qpush@pokey>
References: <1194845812.531937.269801315194.qpush@pokey>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2007 16:36:52 +1100 Jeremy Kerr <jk@ozlabs.org> wrote:

> This change allows force_sig_info to be called from modules.
> 
> Signed-off-by: Jeremy Kerr <jk@ozlabs.org>
> 
> --
> 
> Any objections to exporting this symbol? I'm  planning to move some
> SPU fault-handling code from the kernel to the spufs.ko object.
> 
> ---
> 
>  kernel/signal.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6-spufs/kernel/signal.c
> ===================================================================
> --- linux-2.6-spufs.orig/kernel/signal.c
> +++ linux-2.6-spufs/kernel/signal.c
> @@ -815,6 +815,7 @@ force_sig_info(int sig, struct siginfo *
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(force_sig_info);
>  
>  void
>  force_sig_specific(int sig, struct task_struct *t)

Perhaps export it from within a powerpc-specific C file (along with
suitable comment) to prevent people from generally relying upon the export?

