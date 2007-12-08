Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbXLHMnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbXLHMnS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 07:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbXLHMnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 07:43:07 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:52583 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbXLHMnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 07:43:05 -0500
Subject: Re: [PATCH 1/6] indirect: use asmlinkage in i386 syscall table
	prototype
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       suresh.b.siddha@intel.com
In-Reply-To: <11969832193635-git-send-email-zach.brown@oracle.com>
References: <1196983219534-git-send-email-zach.brown@oracle.com>
	 <11969832193635-git-send-email-zach.brown@oracle.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 08 Dec 2007 13:40:25 +0100
Message-Id: <1197117625.19335.3.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


tor, 06 12 2007 kl. 15:20 -0800, skrev Zach Brown:
> call_indirect() was using the wrong calling convention for the system call
> handlers.  system call handlers would get mixed up arguments.
> 
> Signed-off-by: Zach Brown <zach.brown@oracle.com>
> 
> diff --git a/include/asm-x86/indirect_32.h b/include/asm-x86/indirect_32.h
> index a1b72ac..e3dea8e 100644
> --- a/include/asm-x86/indirect_32.h
> +++ b/include/asm-x86/indirect_32.h
> @@ -15,8 +15,8 @@ struct indirect_registers {
>  
>  static inline long call_indirect(struct indirect_registers *regs)
>  {
> -  extern long (*sys_call_table[]) (__u32, __u32, __u32, __u32, __u32, __u32);
> -
> +	extern asmlinkage long (*sys_call_table[])(long, long, long,
This should be something like below instead, otherwise gcc wont parse
asmlinkage as being an attribute of the function signature.
	extern long (asmlinkage *sys_call_table[])(long, long, long,
I don't now if it has changed with recent gcc versions, this works for
me with 4.2.0.
> +						   long, long, long);
>    return sys_call_table[INDIRECT_SYSCALL(regs)](regs->ebx, regs->ecx,
>  						regs->edx, regs->esi,
>  						regs->edi, regs->ebp);


Simon Holm Thøgersen

