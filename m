Return-Path: <linux-kernel-owner+w=401wt.eu-S964834AbXDJI5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbXDJI5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966121AbXDJI5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:57:42 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:34475 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964834AbXDJI5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:57:41 -0400
Date: Tue, 10 Apr 2007 10:21:11 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, davidsen@tmr.com, randy.dunlap@oracle.com,
       Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
Message-Id: <20070410102111.923b92a9.dada1@cosmosbay.com>
In-Reply-To: <461A4C1E.3070309@ru.mvista.com>
References: <461A4C1E.3070309@ru.mvista.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Apr 2007 18:22:22 +0400
Maxim Uvarov <muvarov@ru.mvista.com> wrote:



> --- linux-2.6.21-rc5.orig/arch/x86_64/kernel/entry.S
> +++ linux-2.6.21-rc5/arch/x86_64/kernel/entry.S
> @@ -236,6 +236,11 @@ ENTRY(system_call)
>  	movq %r10,%rcx
>  	call *sys_call_table(,%rax,8)  # XXX:	 rip relative
>  	movq %rax,RAX-ARGOFFSET(%rsp)
> +#ifdef CONFIG_THREAD_PERF_STAT_SYSC
> +	GET_THREAD_INFO(%rcx)
> +	addq $1, threadinfo_sysc_cnt(%rcx)   # Increment syscalls counter
> +#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
> +

Please reorganize the code so that you dont duplicate GET_THREAD_INFO() stuff
You can do this for example before calling the syscall, not after.

   ja badsys
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+  incq threadinfo_sysc_cnt(%rcx)   # Increment syscalls counter
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
   movq %r10,%rcx
   call *sys_call_table(,%rax,8)  # XXX:    rip relative
