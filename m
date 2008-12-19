Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYLSHar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYLSHar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 02:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYLSHai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 02:30:38 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:7294 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbYLSHah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 02:30:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OYzlGqcZyWc2tIFLMo34gsjsiPTx0olJbWTAVu/iF4onldWEh1Igv0KRj2KtcNJw4+
         Zt3LqrgEr2pjHsuK/soCu3rVPFZpPijT1U5PQCHHcNc95ZDlumVK52et8ErOxMEl/ot7
         SS8sQNUyw7pPPX/iKwZRZ9++mVCm8uTmA6oys=
Message-ID: <aec7e5c30812182330u6e907867i971396923c167ddf@mail.gmail.com>
Date: Fri, 19 Dec 2008 16:30:36 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] clocksource: pass clocksource to read() callback
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
In-Reply-To: <20081217175658.0706a07f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211114802.17622.54609.sendpatchset@rx1.opensource.se>
	 <20081217175658.0706a07f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 10:56 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 11 Dec 2008 20:48:02 +0900
> Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> Pass clocksource pointer to the read() callback for clocksources.
>> This allows us to share the callback between multiple instances.
>
> sparc64 allmodconfig:
>
>
>  CHK     include/linux/version.h
>  CHK     include/linux/utsrelease.h
>  SYMLINK include/asm -> include/asm-sparc
>  CC      arch/sparc/kernel/asm-offsets.s
> In file included from include/linux/ktime.h:25,
>                 from include/linux/timer.h:5,
>                 from include/linux/clocksource.h:16,
>                 from /usr/src/devel/arch/sparc/include/asm/timer_64.h:11,
>                 from /usr/src/devel/arch/sparc/include/asm/timer.h:4,
>                 from /usr/src/devel/arch/sparc/include/asm/timex_64.h:9,
>                 from /usr/src/devel/arch/sparc/include/asm/timex.h:4,
>                 from include/linux/timex.h:170,
>                 from include/linux/sched.h:54,
>                 from arch/sparc/kernel/asm-offsets.c:13:
> include/linux/jiffies.h:247:31: warning: "CLOCK_TICK_RATE" is not defined
[lot's of warning snipped]

How about the (unfortunately most likely mangled) patch below? Does it
help? If not then i'll setup a cross compiler.

Dave, do you want me to rework the patch somehow?

Thanks!

/ magnus

--- 0001/arch/sparc/include/asm/timex_64.h
+++ work/arch/sparc/include/asm/timex_64.h	2008-12-19 16:21:53.000000000 +0900
@@ -6,10 +6,10 @@
 #ifndef _ASMsparc64_TIMEX_H
 #define _ASMsparc64_TIMEX_H

-#include <asm/timer.h>
-
 #define CLOCK_TICK_RATE	1193180 /* Underlying HZ */

+#include <asm/timer.h>
+
 /* Getting on the cycle counter on sparc64. */
 typedef unsigned long cycles_t;
 #define get_cycles()	tick_ops->get_tick()
