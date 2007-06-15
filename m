Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbXFORtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbXFORtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbXFORto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:49:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:30789 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbXFORto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:49:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uthBUYwOE4DvU9FnJX+p/TJtPoXH7myzG/P7zXHP+MH6LAz8X+eCel6GDQdwTLB1ZytR4qbH55V2ps4R8sKfABnTGRlsMB+pixNqUGYlM66rDpjBxKCrK5UyllcOizeNHv+sjEw4lO0SnrGdNOJhNq5Rv1318xPdgNcmndemiLw=
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton@gmail.com>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Subject: Re: [patch] CFS scheduler, -v17
Date: Fri, 15 Jun 2007 19:47:14 +0200
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20070614224908.GA9412@elte.hu> <20070615132841.5ee01f4d@localhost>
In-Reply-To: <20070615132841.5ee01f4d@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706151947.14266.mboton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 18:28, Luiz Fernando N. Capitulino wrote:
>  Hmm, I'm getting this while compiling:
>
> """
>   LD      .tmp_vmlinux1
> kernel/built-in.o: In function `rq_clock':
> /home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321:
> undefined reference to `cpu_of'
> /home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321:
> undefined reference to `cpu_of'
> /home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321:
> undefined reference to `cpu_of'
> /home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321:
> undefined reference to `cpu_of'
> /home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kernel/sched.c:321:
> undefined reference to `cpu_of'
> kernel/built-in.o:/home/lcapitulino/src/kernels/upstream/linux-2.6-cfs/kern
>el/sched.c:321: more undefined references to `cpu_of' follow make: ***
> [.tmp_vmlinux1] Error 1
> """
>
>  The code in question is really strange:
>
> #ifdef CONFIG_SMP
> ...
> static inline int cpu_of(struct rq *rq)
> #ifdef CONFIG_SMP
> 	return rq->cpu;
> #else
> 	return 0;
> #endif
> }
> ...
> #endif

I patched kernel 2.6.21.5 with CFS v17 and I didn't experience this problem (I 
checked that piece of code and I didn't see something wrong).
Looks like it only appears in kernel 2.6.22-rc4.

-- 
	Miguel Botón
