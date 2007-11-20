Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbXKTJ37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbXKTJ37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbXKTJ3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:29:52 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:50548 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939AbXKTJ3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:29:51 -0500
Date: Tue, 20 Nov 2007 10:29:49 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv4 2/6] x86&x86-64 support for sys_indirect
Message-ID: <20071120092949.GD7992@osiris.boeblingen.de.ibm.com>
References: <200711200653.lAK6rEhQ025882@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711200653.lAK6rEhQ025882@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define INDIRECT_SYSCALL(regs) (regs)->rax
> +#define INDIRECT_SYSCALL32(regs) (regs)->eax
> +
> +#define CALL_INDIRECT(regs) \
> +  ({ extern long (*sys_call_table[]) (__u64, __u64, __u64, __u64, __u64, __u64); \
> +     sys_call_table[INDIRECT_SYSCALL(regs)] ((regs)->rdi, (regs)->rsi, \
> +					     (regs)->rdx, (regs)->r10, \
> +					     (regs)->r8, (regs)->r9); \
> +     })
> +

All these macros could be functions, or? Would give us some type checking
and avoids the capital letters.
