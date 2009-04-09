Return-Path: <linux-kernel-owner+w=401wt.eu-S1759671AbZDID7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671AbZDID7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758963AbZDID6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:58:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50625 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984AbZDID6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:58:47 -0400
Date: Thu, 9 Apr 2009 05:58:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>, Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86,edac: fix for compiler error in traps.c
Message-ID: <20090409035839.GC20692@elte.hu>
References: <alpine.DEB.2.00.0904081954530.16430@gandalf.stny.rr.com> <alpine.DEB.2.00.0904082004070.16430@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904082004070.16430@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Impact: compile fix
> 
>  I got this compile failure on both tip/tracing/core as well as on 
>  v2.6.30-rc1.
>  
>    LD      .tmp_vmlinux1
>  arch/x86/kernel/built-in.o: In function `do_nmi':
>  (.text+0x3c18): undefined reference to `edac_handler_set'
>  arch/x86/kernel/built-in.o: In function `do_nmi':
>  (.text+0x3c48): undefined reference to `edac_atomic_assert_error'
>  make: *** [.tmp_vmlinux1] Error 1
>  [root@bxrhel51 linux-trace.git]# grep edac_handler_set 
>  [root@bxrhel51 linux-trace.git]# Grep edac_handler_set '*.[ch]'
>  find .  -name "*.[ch]" ! -type d  | xargs grep  "edac_handler_set"
>  ./arch/x86/kernel/traps.c:	if (edac_handler_set()) {
>  ./include/linux/edac.h:extern int edac_handler_set(void);
>  ./drivers/edac/edac_stub.c:int edac_handler_set(void)
>  ./drivers/edac/edac_stub.c:EXPORT_SYMBOL_GPL(edac_handler_set);
>  
> This patch seems to fix it.

> -obj-$(CONFIG_EDAC)			:= edac_stub.o
> +obj-$(CONFIG_EDAC)			+= edac_stub.o
>  obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o

It's weird that this breaks for you. What other bit of the kernel 
introduces CONFIG_EDAC rules?

And it's clean to start driver rules with the := assignment and then 
append to them via +=. The initial += should not be needed.

Are you sure you have a pristine build environment?

	Ingo
