Return-Path: <linux-kernel-owner+w=401wt.eu-S1161151AbXDKBFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151AbXDKBFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 21:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161152AbXDKBFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 21:05:48 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54596 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161151AbXDKBFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 21:05:47 -0400
Date: Tue, 10 Apr 2007 18:05:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1 build fails for m68k
Message-Id: <20070410180539.16f3090b.akpm@linux-foundation.org>
In-Reply-To: <20070411004112.GA15262@Krystal>
References: <20070411004112.GA15262@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 20:41:12 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> I get the following compiler error when building 2.6.21-rc6-mm1 for
> m68k:
> 
> 
>   /opt/crosstool/gcc-4.1.1-glibc-2.3.6/m68k-unknown-linux-gnu/bin/m68k-unknown-linux-gnu-gcc -Wp,-MD,arch/m68k/kernel/.asm-offsets.s.d  -nostdinc -isystem /opt/crosstool/gcc-4.1.1-glibc-2.3.6/m68k-unknown-linux-gnu/lib/gcc/m68k-unknown-linux-gnu/4.1.1/include -D__KERNEL__ -Iinclude -Iinclude2 -I/home/compudj/git/linux-2.6-lttng/include -include include/linux/autoconf.h -I/home/compudj/git/linux-2.6-lttng/. -I. -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -O2 -pipe -fno-strength-reduce -ffixed-a2 -m68040 -fomit-frame-pointer -fno-stack-protector -Wdeclaration-after-statement -Wno-pointer-sign  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(asm_offsets)"  -D"KBUILD_MODNAME=KBUILD_STR(asm_offsets)" -fverbose-asm -S -o arch/m68k/kernel/asm-offsets.s /home/compudj/git/linux-2.6-lttng/arch/m68k/kernel/asm-offsets.c
> /home/compudj/git/linux-2.6-lttng/arch/m68k/kernel/asm-offsets.c: In function 'main':
> /home/compudj/git/linux-2.6-lttng/arch/m68k/kernel/asm-offsets.c:27: error: 'struct task_struct' has no member named 'ptrace'

That's because m68k is missing utrace support.  Quite a lot of
architectures are in that state.

If you're using quilt (you should be) you can

- remove utrace patches from the series file
- quilt push linux-kernel-markers-documentation.patch
- do work

I'll reorder the -mm series file so that utrace comes much later, which
will simplify this.

