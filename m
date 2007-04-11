Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbXDKBZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbXDKBZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 21:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964792AbXDKBZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 21:25:15 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55040 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964784AbXDKBZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 21:25:13 -0400
Date: Tue, 10 Apr 2007 18:25:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Subject: Re: Build error : 2.6.21-rc6-mm1 for arm
Message-Id: <20070410182502.a09632b2.akpm@linux-foundation.org>
In-Reply-To: <20070411005420.GF15262@Krystal>
References: <20070411005420.GF15262@Krystal>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 20:54:20 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> I get the following build error when compiling 2.6.21-rc6-mm1 for arm
> "footbridge" :
> 
> ...
>
> make -f /home/compudj/git/linux-2.6-lttng/scripts/Makefile.build obj=init
>   /opt/crosstool/gcc-4.0.2-glibc-2.3.6/arm-unknown-linux-gnu/bin/arm-unknown-linux-gnu-gcc -Wp,-MD,init/.main.o.d  -nostdinc -isystem /opt/crosstool/gcc-4.0.2-glibc-2.3.6/arm-unknown-linux-gnu/lib/gcc/arm-unknown-linux-gnu/4.0.2/include -D__KERNEL__ -Iinclude -Iinclude2 -I/home/compudj/git/linux-2.6-lttng/include -include include/linux/autoconf.h -mlittle-endian -I/home/compudj/git/linux-2.6-lttng/init -Iinit -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Os -marm -fno-omit-frame-pointer -mapcs -mno-sched-prolog -mabi=apcs-gnu -mno-thumb-interwork -D__LINUX_ARM_ARCH__=4 -march=armv4 -mtune=strongarm110 -msoft-float -Uarm -fno-omit-frame-pointer -fno-optimize-sibling-calls -Wdeclaration-after-statement -Wno-pointer-sign  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(main)"  -D"KBUILD_MODNAME=KBUILD_STR(main)" -c -o init/main.o /home/compudj/git/linux-2.6-lttng/init/main.c
> In file included from /home/compudj/git/linux-2.6-lttng/include/linux/dma-mapping.h:34,
>                  from /home/compudj/git/linux-2.6-lttng/include/linux/dmaengine.h:29,
>                  from /home/compudj/git/linux-2.6-lttng/include/linux/skbuff.h:30,
>                  from /home/compudj/git/linux-2.6-lttng/include/linux/netlink.h:140,
>                  from /home/compudj/git/linux-2.6-lttng/include/linux/genetlink.h:4,
>                  from /home/compudj/git/linux-2.6-lttng/include/net/genetlink.h:4,
>                  from /home/compudj/git/linux-2.6-lttng/include/linux/taskstats_kern.h:12,
>                  from /home/compudj/git/linux-2.6-lttng/init/main.c:45:
> include2/asm/dma-mapping.h: In function 'dma_sync_single_range_for_cpu':
> include2/asm/dma-mapping.h:320: warning: implicit declaration of function 'dma_sync_single_for_cpu'
> include2/asm/dma-mapping.h: In function 'dma_sync_single_range_for_device':
> include2/asm/dma-mapping.h:329: warning: implicit declaration of function 'dma_sync_single_for_device'
> include2/asm/dma-mapping.h: At top level:
> include2/asm/dma-mapping.h:352: warning: conflicting types for 'dma_sync_single_for_cpu'
> include2/asm/dma-mapping.h:352: error: static declaration of 'dma_sync_single_for_cpu' follows non-static declaration
> include2/asm/dma-mapping.h:320: error: previous implicit declaration of 'dma_sync_single_for_cpu' was here
> include2/asm/dma-mapping.h:360: warning: conflicting types for 'dma_sync_single_for_device'
> include2/asm/dma-mapping.h:360: error: static declaration of 'dma_sync_single_for_device' follows non-static declaration
> include2/asm/dma-mapping.h:329: error: previous implicit declaration of 'dma_sync_single_for_device' was here
> make[2]: *** [init/main.o] Error 1
> make[1]: *** [init] Error 2
> make: *** [_all] Error 2

Dan, this is caused by git-md-accel.patch
 
> 
> my .config :
