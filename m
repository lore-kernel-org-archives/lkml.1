Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbYG3WAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbYG3WAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758028AbYG3WAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:00:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:19657 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758240AbYG3WAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TCTHN7dg0vjw0K0i1zWrNgp7zqPOasBAYOa2ENMbaTXI1CMXCmCaVRtyA4XrcLtOyY
         /8lsMj5D+wOMI2CpQXfw6nid//ETd0OrXqC8JQJSvtHxzjr+QQvJ2dLn/YmIgu42F7Is
         SaTXJz4M34Gu18BFQpw05LBpf7lZw6zSlPNGs=
Message-ID: <86802c440807301500t17108f4el2f4178154b8b164f@mail.gmail.com>
Date: Wed, 30 Jul 2008 15:00:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [GIT-PULL] time.c integration
Cc: "Glauber Costa" <gcosta@redhat.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <20080730185148.GA12336@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807290103.m6T13vt3000862@file.rdu.redhat.com>
	 <20080730185007.GB26389@elte.hu> <20080730185148.GA12336@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 11:51 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> Also, please do smaller steps while bringing both time_32.c and
>> time_64.c up into their final forms (and do it in multiple commits),
>> and make sure each step compiles on their respective defconfig. time.c
>> details are historically fragile, i'd not be surprised if this series
>> was the target of bisection efforts.
>
> i briefly put your current variant into tip/master, but it has build
> problems as well:
>
> arch/x86/kernel/io_apic_64.c: In function 'check_timer':
> arch/x86/kernel/io_apic_64.c:2016: error: 'timer_ack' undeclared (first use in this function)
> arch/x86/kernel/io_apic_64.c:2016: error: (Each undeclared identifier is reported only once
> arch/x86/kernel/io_apic_64.c:2016: error: for each function it appears in.)
>
> with:
>
>  http://redhat.com/~mingo/misc/config-Wed_Jul_30_20_50_17_CEST_2008.bad
>
>        Ingo
> --
diff --git a/include/asm-x86/timer.h b/include/asm-x86/timer.h
index d0babce..e4eb6ab 100644
--- a/include/asm-x86/timer.h
+++ b/include/asm-x86/timer.h
@@ -9,8 +9,8 @@
 unsigned long long native_sched_clock(void);
 unsigned long native_calibrate_tsc(void);

-#ifdef CONFIG_X86_32
 extern int timer_ack;
+#ifdef CONFIG_X86_32
 extern int recalibrate_cpu_khz(void);
 #endif /* CONFIG_X86_32 */
