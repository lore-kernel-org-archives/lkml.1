Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYG3VAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYG3VAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYG3VAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:00:04 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:6469 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYG3VAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:00:00 -0400
X-BigFish: VPS-9(z1857rz98dR936eQ4015M7cf0izz10d3izz2b68kz2fh6bh64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
Message-ID: <4890C8E4.50503@am.sony.com>
Date: Wed, 30 Jul 2008 13:02:44 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Dave Jones <davej@codemonkey.org.uk>, Paul Jackson <pj@sgi.com>,
       Tony Luck <tony.luck@intel.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robert Richter <robert.richter@amd.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sam Creasey <sammy@sammy.net>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use cpumask_of_cpu_map
 - build breakage
References: <20080723171841.815234000@polaris-admin.engr.sgi.com> <20080723171841.997896000@polaris-admin.engr.sgi.com>
In-Reply-To: <20080723171841.997896000@polaris-admin.engr.sgi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2008 19:59:52.0505 (UTC) FILETIME=[D4807A90:01C8F27E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
>   * The previous "lvalue replacement for cpumask_of_cpu()" was not usable
>     in certain situations and generally added unneeded complexity.  So
>     this patch replaces the cpumask_of_cpu_ptr* macros with a generic
>     cpumask_of_cpu_map[].  The only config option is whether this is a
>     static map, or allocated at boot up time:
I'm having trouble compiling 2.6.27-rc1 for ARM OMAP.

I'm using gcc 3.4.4 (specifically, one used for
cross-compiling for ARM)

The file that fails to compile is kernel/time/tick-common.c

Here is the compiler message:
  arm-sony-linux-gcc -Wp,-MD,kernel/time/.tick-common.o.d  -nostdinc -isystem /a/home/usr/local/arm-sony-linux/devel/bin/../lib/gcc/arm-sony-linux/3.4.4/include -D__KERNEL__ -Iinclude -Iinclude2
-I/a/home/tbird/work/console-translations/linux/include -I/a/home/tbird/work/console-translations/linux/arch/arm/include -include include/linux/autoconf.h -mlittle-endian
-I/a/home/tbird/work/console-translations/linux/kernel/time -Ikernel/time -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Os
-marm -fno-omit-frame-pointer -mapcs -mno-sched-prolog -mapcs-32 -mno-thumb-interwork -D__LINUX_ARM_ARCH__=5 -march=armv5te -mtune=arm9tdmi -malignment-traps -msoft-float -Uarm -fno-omit-frame-pointer
-fno-optimize-sibling-calls -Wdeclaration-after-statement  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(tick_common)"  -D"KBUILD_MODNAME=KBUILD_STR(tick_common)" -c -o kernel/time/tick-common.o
/a/home/tbird/work/console-translations/linux/kernel/time/tick-common.c
/a/home/tbird/work/console-translations/linux/kernel/time/tick-common.c: In function `tick_check_new_device':
/a/home/tbird/work/console-translations/linux/kernel/time/tick-common.c:210: error: invalid lvalue in unary `&'
/a/home/tbird/work/console-translations/linux/kernel/time/tick-common.c:223: error: invalid lvalue in unary `&'
/a/home/tbird/work/console-translations/linux/kernel/time/tick-common.c:255: error: invalid lvalue in unary `&'
make[3]: *** [kernel/time/tick-common.o] Error 1
make[2]: *** [kernel/time] Error 2
make[1]: *** [kernel] Error 2
make: *** [sub-make] Error 2

This seems to be related to commit 0bc3cc03fa6e in Linus' 2.6 tree.

Any assistance you can provide would be appreciated.

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

