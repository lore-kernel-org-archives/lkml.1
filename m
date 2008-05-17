Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbYEQTSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbYEQTSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 15:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYEQTSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 15:18:32 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:40654 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbYEQTSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 15:18:31 -0400
Date: Sat, 17 May 2008 22:16:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: kyle@parisc-linux.org, matthew@wil.cx, grundler@parisc-linux.org
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: parisc setup_sigcontext32() array overflows
Message-ID: <20080517191636.GA8140@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/asm-parisc/ptrace.h:

<--  snip  -->

...
struct pt_regs {
        unsigned long gr[32];   /* PSW is in gr[0] */
...
}

<--  snip  -->


arch/parisc/kernel/signal32.c:

<--  snip  -->

...
setup_sigcontext32(struct compat_sigcontext __user *sc, struct compat_regfile __user * rf, 
                struct pt_regs *regs, int in_syscall)            
{
...
                /* Store upper half */
                compat_reg = (compat_uint_t)(regs->gr[32] >> 32);
...                                                   ^^
                /* Store upper half */
                compat_reg = (compat_uint_t)((regs->gr[32]+4) >> 32);
...                                                    ^^

<--  snip  -->


Spotted by the GNU C compiler.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

