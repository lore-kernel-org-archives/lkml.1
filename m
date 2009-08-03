Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZHCLjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZHCLjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZHCLjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:39:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40726 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbZHCLjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:39:42 -0400
Date: Mon, 3 Aug 2009 13:39:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       kilroyd@googlemail.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] locking: Check spinlock_t/rwlock_t argument
	type on non-SMP builds too
Message-ID: <20090803113929.GA25828@elte.hu>
References: <1249238465-4929-1-git-send-email-kilroyd@googlemail.com> <tip-8d19bd347e1073e7f1ef9f8057c560a5f6be63d7@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-8d19bd347e1073e7f1ef9f8057c560a5f6be63d7@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for David Kilroy <kilroyd@googlemail.com> wrote:

> Commit-ID:  8d19bd347e1073e7f1ef9f8057c560a5f6be63d7
> Gitweb:     http://git.kernel.org/tip/8d19bd347e1073e7f1ef9f8057c560a5f6be63d7
> Author:     David Kilroy <kilroyd@googlemail.com>
> AuthorDate: Sun, 2 Aug 2009 19:41:05 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 2 Aug 2009 21:29:07 +0200
> 
> locking: Check spinlock_t/rwlock_t argument type on non-SMP builds too
> 
> When writing code for UP without CONFIG_DEBUG_SPINLOCK it's
> easy to get the first argument to the spinlock/rwlock functions
> wrong. This is because the parameter is not actually used in
> this configuration.
> 
> Typically you will only find out it's wrong:
> 
>  * by rebuilding with CONFIG_SMP or CONFIG_DEBUG_SPINLOCK
>  * after you've submitted your beautiful patch series
> 
> The first means a long wait, and the latter is a bit late.
> 
> Change the intermediate macros into inline functions.
> 
> -v2: Use C inlines instead of in-macro type-checks
> -v3: Correct bug in _spin_trylock_bh

x86 works fine now - but this patch broke architecture builds, such 
as the build on Alpha:

In file included from 
/home/mingo/tip/arch/alpha/kernel/sys_sable.c:25:
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 
't2_readb':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:451: error: 
'_spin_lock_irqsave' is static but used in inline function 
't2_readb' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:456: error: 
'_spin_unlock_irqrestore' is static but used in inline function 
't2_readb' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 
't2_readw':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:465: error: 
'_spin_lock_irqsave' is static but used in inline function 
't2_readw' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:470: error: 
'_spin_unlock_irqrestore' is static but used in inline function 
't2_readw' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 
't2_readl':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:483: error: 
'_spin_lock_irqsave' is static but used in inline function 
't2_readl' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:488: error: 
'_spin_unlock_irqrestore' is static but used in inline function 
't2_readl' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 
't2_readq':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:497: error: 
'_spin_lock_irqsave' is static but used in inline function 
't2_readq' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:504: error: 
'_spin_unlock_irqrestore' is static but used in inline function 
't2_readq' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 
't2_writeb':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:513: error: 
'_spin_lock_irqsave' is static but used in inline function 
't2_writeb' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:519: error: 
'_spin_unlock_irqrestore' is static but used in inline function 
't2_writeb' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 
't2_writew':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:527: error: 
'_spin_lock_irqsave' is static but used in inline function 
't2_writew' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:533: error: 
'_spin_unlock_irqrestore' is static but used in inline function 
't2_writew' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 
't2_writel':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:545: error: 
'_spin_lock_irqsave' is static but used in inline function 
't2_writel' which is not static

	Ingo
