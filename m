Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbXDDSE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbXDDSE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbXDDSE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:04:56 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:42651 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbXDDSEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:04:54 -0400
Date: Wed, 4 Apr 2007 20:04:48 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: Performance Stats: Kernel patch
Message-Id: <20070404200448.780a804b.dada1@cosmosbay.com>
In-Reply-To: <4613D7D2.20806@ru.mvista.com>
References: <46124E93.2000408@ru.mvista.com>
	<16797.1175641303@turing-police.cc.vt.edu>
	<4613A4FF.9030202@ru.mvista.com>
	<20070404154624.826578b1.dada1@cosmosbay.com>
	<4613D7D2.20806@ru.mvista.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Apr 2007 20:52:34 +0400
Maxim Uvarov <muvarov@ru.mvista.com> wrote:


> Index: linux-2.6.18/include/asm/thread_info.h
> ===================================================================
> --- linux-2.6.18.orig/include/asm/thread_info.h
> +++ linux-2.6.18/include/asm/thread_info.h
> @@ -44,6 +44,9 @@ struct thread_info {
>                                                    of nested (IRQ) stacks
>                                                 */
>         __u8                    supervisor_stack[0];
> +#ifdef CONFIG_THREAD_PERF_STAT_SYSC
> +       unsigned long           sysc_cnt;           /* Syscall counter */
> +#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
>  };
> 
>  #else /* !__ASSEMBLY__ */

You probably meant include/asm-i386/thread_info.h, not include/asm/thread_info.h

Then, you should not place sysc_cnt after supervisor_stack[0], since supervisor_stack[0] should be the last element of struct thread_info.

Better to put sysc_cnt right after preempt_count for example.

Also, is there any reason your patches are against 2.6.18, and not current kernel ?

