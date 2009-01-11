Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbZAKL5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbZAKL5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 06:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZAKL5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 06:57:31 -0500
Received: from web.keli.cz ([77.48.235.227]:40892 "EHLO web.keli.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZAKL5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 06:57:31 -0500
Message-ID: <4969DEA0.5020301@century.cz>
Date: Sun, 11 Jan 2009 12:57:20 +0100
From: Petr Titera <P.Titera@century.cz>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Build error on latest git
References: <4969C096.9060909@century.cz>
In-Reply-To: <4969C096.9060909@century.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Going through source it seems to me (still building) that it is caused 
by including asm/smp.h only if build with CONFIG_SMP. This patch seems 
to fix this

diff --git a/include/linux/smp.h b/include/linux/smp.h
index b824669..fd51bb9 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -11,6 +11,8 @@
 #include <linux/list.h>
 #include <linux/cpumask.h>
 
+#include <asm/smp.h>
+
 extern void cpu_idle(void);
 
 struct call_single_data {
@@ -30,7 +32,6 @@ extern unsigned int total_cpus;
 #include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <linux/thread_info.h>
-#include <asm/smp.h>
 
 /*
  * main cross-CPU interfaces, handles INIT, TLB flush, STOP, etc.


Petr Titera napsal(a):
> Hello,
>
> I'm getting this build error in arch/x86/kernel/mpparse.c using latest 
> git:
>
> arch/x86/kernel/mpparse.c: In function ‘MP_processor_info’:
> arch/x86/kernel/mpparse.c:57: error: ‘disabled_cpus’ undeclared (first 
> use in this function)
> arch/x86/kernel/mpparse.c:57: error: (Each undeclared identifier is 
> reported only once
> arch/x86/kernel/mpparse.c:57: error: for each function it appears in.)
> arch/x86/kernel/mpparse.c: In function ‘MP_bus_info’:
> arch/x86/kernel/mpparse.c:85: error: implicit declaration of function 
> ‘apic_printk’
> arch/x86/kernel/mpparse.c:85: error: ‘APIC_VERBOSE’ undeclared (first 
> use in this function)
> arch/x86/kernel/mpparse.c: In function ‘print_MP_intsrc_info’:
> arch/x86/kernel/mpparse.c:156: error: ‘APIC_VERBOSE’ undeclared (first 
> use in this function)
> arch/x86/kernel/mpparse.c: In function ‘print_mp_irq_info’:
> arch/x86/kernel/mpparse.c:164: error: ‘APIC_VERBOSE’ undeclared (first 
> use in this function)
> arch/x86/kernel/mpparse.c: In function ‘MP_lintsrc_info’:
> arch/x86/kernel/mpparse.c:236: error: ‘APIC_VERBOSE’ undeclared (first 
> use in this function)
> arch/x86/kernel/mpparse.c: In function ‘smp_read_mpc’:
> arch/x86/kernel/mpparse.c:395: error: ‘num_processors’ undeclared 
> (first use in this function)
> arch/x86/kernel/mpparse.c: In function ‘__get_smp_config’:
> arch/x86/kernel/mpparse.c:670: error: ‘num_processors’ undeclared 
> (first use in this function)
> arch/x86/kernel/mpparse.c: In function ‘smp_scan_config’:
> arch/x86/kernel/mpparse.c:692: error: ‘APIC_VERBOSE’ undeclared (first 
> use in this function)
> make[1]: *** [arch/x86/kernel/mpparse.o] Error 1
> make: *** [arch/x86/kernel] Error 2
>
> Petr Titera

