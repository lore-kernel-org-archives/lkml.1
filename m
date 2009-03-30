Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbZC3Qzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbZC3Qzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbZC3Qz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:55:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33876 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649AbZC3QzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:55:25 -0400
Date: Mon, 30 Mar 2009 12:55:16 -0400
From: Dave Jones <davej@redhat.com>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] P4 clock mod: recalibrate_cpu_khz on ia32 only
Message-ID: <20090330165516.GA11902@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
	linux-kernel@vger.kernel.org
References: <20090330164153.GA13777@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090330164153.GA13777@gambetta>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 04:41:53PM +0000, Frederik Deweerdt wrote:
 > Hello Dave,
 > 
 > I just triggered the following compile error with an old .config on
 > x86_64, (latest git):
 > 
 >   CHK     include/linux/version.h
 >   CHK     include/linux/utsrelease.h
 >   SYMLINK include/asm -> include/asm-x86
 >   CALL    scripts/checksyscalls.sh
 >   CHK     include/linux/compile.h
 >   CC [M]  arch/x86/kernel/cpu/cpufreq/p4-clockmod.o
 > arch/x86/kernel/cpu/cpufreq/p4-clockmod.c: In function ‘cpufreq_p4_cpu_init’:
 > arch/x86/kernel/cpu/cpufreq/p4-clockmod.c:232: error: implicit declaration of function ‘recalibrate_cpu_khz’
 > make[3]: *** [arch/x86/kernel/cpu/cpufreq/p4-clockmod.o] Error 1
 > make[2]: *** [arch/x86/kernel/cpu/cpufreq] Error 2
 > make[1]: *** [arch/x86/kernel/cpu] Error 2
 > make: *** [arch/x86/kernel] Error 2
 > 
 > The attached patch calls recalibrate_cpu_khz on ia32 only

Wrong fix.  It needs to be called on 64 bit too.
The real fix is to reinstate this diff which the recent x86 merge reverted..

diff --git a/arch/x86/include/asm/timer.h b/arch/x86/include/asm/timer.h
index 2bb6a83..4f5c247 100644
--- a/arch/x86/include/asm/timer.h
+++ b/arch/x86/include/asm/timer.h
@@ -11,8 +11,8 @@ unsigned long native_calibrate_tsc(void);
 
 #ifdef CONFIG_X86_32
 extern int timer_ack;
+#endif
 extern int recalibrate_cpu_khz(void);
-#endif /* CONFIG_X86_32 */
 
 extern int no_timer_check;
 

