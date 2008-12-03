Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbYLCLsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbYLCLsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYLCLr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:47:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36663 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbYLCLr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:47:59 -0500
Date: Wed, 3 Dec 2008 12:47:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jianjun Kong <jianjun@zeuux.org>
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>, mingo@redhat.com
Subject: Re: v2.6.28-rc7: Fail compile arch/x86/kernel/cpu/common.c
Message-ID: <20081203114748.GB19664@elte.hu>
References: <20081203070115.GA32403@ubuntu> <20081203073504.GB17580@elte.hu> <20081203112725.GA6822@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081203112725.GA6822@ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jianjun Kong <jianjun@zeuux.org> wrote:

> On Wed, Dec 03, 2008 at 08:35:04AM +0100, Ingo Molnar wrote:
> >* Jianjun Kong <jianjun@zeuux.org> wrote:
> >> arch/x86/kernel/cpu/common.c: In function ‘early_identify_cpu’:
> >> arch/x86/kernel/cpu/common.c:555: error: ‘boot_cpu_id’ undeclared (first
> >> use in this function)

the error message is not consistent with what the code does:

$ cat arch/x86/kernel/cpu/common.c
[...]
#include <asm/smp.h>

combined with:

> $ cat arch/x86/include/asm/smp.h
> 
> #ifndef _ASM_X86_SMP_H
> #define _ASM_X86_SMP_H

> #ifdef CONFIG_X86_HAS_BOOT_CPU_ID
> extern unsigned char boot_cpu_id;
> #else
> #define boot_cpu_id	0
> #endif
> 
> #endif /* __ASSEMBLY__ */
> #endif /* _ASM_X86_SMP_H */

how can this not build? Do you have __ASSEMBLY__ defined in your CFLAGS 
perhaps?

	Ingo
