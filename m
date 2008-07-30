Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbYG3VYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbYG3VYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYG3VYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:24:31 -0400
Received: from relay1.sgi.com ([192.48.171.29]:37428 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751899AbYG3VYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:24:30 -0400
Message-ID: <4890DC09.2020700@sgi.com>
Date: Wed, 30 Jul 2008 14:24:25 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
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
References: <20080723171841.815234000@polaris-admin.engr.sgi.com> <20080723171841.997896000@polaris-admin.engr.sgi.com> <4890C8E4.50503@am.sony.com>
In-Reply-To: <4890C8E4.50503@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> Mike Travis wrote:
>>   * The previous "lvalue replacement for cpumask_of_cpu()" was not usable
>>     in certain situations and generally added unneeded complexity.  So
>>     this patch replaces the cpumask_of_cpu_ptr* macros with a generic
>>     cpumask_of_cpu_map[].  The only config option is whether this is a
>>     static map, or allocated at boot up time:
> I'm having trouble compiling 2.6.27-rc1 for ARM OMAP.
> 
> I'm using gcc 3.4.4 (specifically, one used for
> cross-compiling for ARM)
> 
> The file that fails to compile is kernel/time/tick-common.c
> 
> Here is the compiler message:
>   arm-sony-linux-gcc -Wp,-MD,kernel/time/.tick-common.o.d  -nostdinc -isystem /a/home/usr/local/arm-sony-linux/devel/bin/../lib/gcc/arm-sony-linux/3.4.4/include -D__KERNEL__ -Iinclude -Iinclude2
> -I/a/home/tbird/work/console-translations/linux/include -I/a/home/tbird/work/console-translations/linux/arch/arm/include -include include/linux/autoconf.h -mlittle-endian
> -I/a/home/tbird/work/console-translations/linux/kernel/time -Ikernel/time -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Os
> -marm -fno-omit-frame-pointer -mapcs -mno-sched-prolog -mapcs-32 -mno-thumb-interwork -D__LINUX_ARM_ARCH__=5 -march=armv5te -mtune=arm9tdmi -malignment-traps -msoft-float -Uarm -fno-omit-frame-pointer
> -fno-optimize-sibling-calls -Wdeclaration-after-statement  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(tick_common)"  -D"KBUILD_MODNAME=KBUILD_STR(tick_common)" -c -o kernel/time/tick-common.o
> /a/home/tbird/work/console-translations/linux/kernel/time/tick-common.c
> /a/home/tbird/work/console-translations/linux/kernel/time/tick-common.c: In function `tick_check_new_device':
> /a/home/tbird/work/console-translations/linux/kernel/time/tick-common.c:210: error: invalid lvalue in unary `&'
> /a/home/tbird/work/console-translations/linux/kernel/time/tick-common.c:223: error: invalid lvalue in unary `&'
> /a/home/tbird/work/console-translations/linux/kernel/time/tick-common.c:255: error: invalid lvalue in unary `&'
> make[3]: *** [kernel/time/tick-common.o] Error 1
> make[2]: *** [kernel/time] Error 2
> make[1]: *** [kernel] Error 2
> make: *** [sub-make] Error 2
> 
> This seems to be related to commit 0bc3cc03fa6e in Linus' 2.6 tree.
> 
> Any assistance you can provide would be appreciated.
> 
> Thanks,
>  -- Tim
> 
> =============================
> Tim Bird
> Architecture Group Chair, CE Linux Forum
> Senior Staff Engineer, Sony Corporation of America
> =============================

There was a later update that fixed this.  You should have the following
in include/linux/cpumask.h particularly line 291.


e56b3bc7 (Linus Torvalds         2008-07-28 11:32:33 -0700 285) /*
e56b3bc7 (Linus Torvalds         2008-07-28 11:32:33 -0700 286)  * In cases where we take the address of the cpumask immediately,
e56b3bc7 (Linus Torvalds         2008-07-28 11:32:33 -0700 287)  * gcc optimizes it out (it's a constant) and there's no huge stack
e56b3bc7 (Linus Torvalds         2008-07-28 11:32:33 -0700 288)  * variable created:
e56b3bc7 (Linus Torvalds         2008-07-28 11:32:33 -0700 289)  */
1eddd657 (Stephen Rothwell       2008-07-29 16:07:37 +1000 290) #define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
^1da177e (Linus Torvalds         2005-04-16 15:20:36 -0700 291)

If 1eddd657 is there, would you send the config?

Dave - I just re-verified that allyesconfig builds with lot's of warnings but no errors.

Thanks,
Mike
