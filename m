Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbYHXOqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbYHXOqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 10:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYHXOqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 10:46:42 -0400
Received: from ns.suse.de ([195.135.220.2]:41223 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYHXOql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 10:46:41 -0400
From: Andreas Schwab <schwab@suse.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       Linus Torvalds <torvalds@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Random crashes with 2.6.27-rc3 on PPC
References: <200808231610.46473.mb@bu3sch.de>
	<1219531969.21386.205.camel@pasglop> <200808241544.12412.mb@bu3sch.de>
X-Yow: Let me do my TRIBUTE to FISHNET STOCKINGS...
Date: Sun, 24 Aug 2008 16:46:38 +0200
In-Reply-To: <200808241544.12412.mb@bu3sch.de> (Michael Buesch's message of
	"Sun, 24 Aug 2008 15:44:11 +0200")
Message-ID: <je7ia6bhdd.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch <mb@bu3sch.de> writes:

> The following workaround seems to fix the crashes on powerpc.
> However, this patch is clearly not what we want for other architectures,
> as they might need -fno-omit-frame-pointer to function properly.

This has a better chance to be accepted. :-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8b5a7d3..f9a2e48 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -394,7 +394,7 @@ config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
 	select STACKTRACE
-	select FRAME_POINTER if !X86 && !MIPS
+	select FRAME_POINTER if !X86 && !MIPS && !PPC
 	select KALLSYMS
 	select KALLSYMS_ALL
 

> Index: linux-2.6/kernel/Makefile
> ===================================================================
> --- linux-2.6.orig/kernel/Makefile	2008-08-24 11:50:23.000000000 +0200
> +++ linux-2.6/kernel/Makefile	2008-08-24 12:15:54.000000000 +0200
> @@ -92,13 +92,13 @@ obj-$(CONFIG_SMP) += sched_cpupri.o
>  ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
>  # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
>  # needed for x86 only.  Why this used to be enabled for all architectures is beyond
>  # me.  I suspect most platforms don't need this, but until we know that for sure
>  # I turn this off for IA-64 only.  Andreas Schwab says it's also needed on m68k
>  # to get a correct value for the wait-channel (WCHAN in ps). --davidm
> -CFLAGS_sched.o := $(PROFILING) -fno-omit-frame-pointer
> +CFLAGS_sched.o := $(PROFILING)

CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is already enabled on powerpc.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
