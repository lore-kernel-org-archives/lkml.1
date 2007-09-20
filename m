Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbXITAKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbXITAKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 20:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXITAKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 20:10:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965AbXITAKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 20:10:07 -0400
Date: Wed, 19 Sep 2007 17:09:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: jfannin@gmail.com (Joseph Fannin)
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: 2.6.23-rc6-mm1
Message-Id: <20070919170934.84f44e05.akpm@linux-foundation.org>
In-Reply-To: <20070919235828.GA31759@nineveh.local>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<20070919235828.GA31759@nineveh.local>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 19:58:28 -0400
jfannin@gmail.com (Joseph Fannin) wrote:

> On Tue, Sep 18, 2007 at 01:18:41AM -0700, Andrew Morton wrote:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc6/2.6.23-rc6-mm1/
> >
> > 2.6.23-rc6-mm1
> 
>     [patch submitter cc'd]
> 
>     I had to reverse
> convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch (and the
> fix on top of it) to get past this error on 32bit powerpc:
> 
> make[1]: Entering directory `/usr/src/ctesiphon/linux-2.6.23-rc6-mm1'
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CC      arch/powerpc/kernel/asm-offsets.s
> In file included from include/linux/smp.h:19,
>                  from include/linux/sched.h:67,
>                  from arch/powerpc/kernel/asm-offsets.c:17:
> include/asm/smp.h:63: error: expected declaration specifiers or ___...___ before ___cpu_sibling_map___
> include/asm/smp.h:63: warning: data definition has no type or storage class
> include/asm/smp.h:63: warning: type defaults to ___int___ in declaration of ___DECLARE_PER_CPU___
> make[2]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1
> 
>     I dunno if this will build or work with these reverted (I'm still
> looking at other build failures) but backing these out got the build
> moving again.

This, methinks.

--- a/include/asm-powerpc/smp.h~convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2
+++ a/include/asm-powerpc/smp.h
@@ -25,8 +25,8 @@
 
 #ifdef CONFIG_PPC64
 #include <asm/paca.h>
-#include <asm/percpu.h>
 #endif
+#include <asm/percpu.h>
 
 extern int boot_cpuid;
 


(conditional includes are evil)
