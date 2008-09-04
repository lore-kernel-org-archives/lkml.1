Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbYIDUH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbYIDUH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYIDUHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:07:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:21666 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbYIDUHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:07:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JujiUmHaAO9s99qlO84fiwhpuF410sTM/OUIsqNcTKQfupjCYD7BJ5GObca0zlKadu
         AhtNYF9P5YFjxIHQSOZszXiCieAfsilnIMBJZ5EVGI5voWTvfgI3+V9MiC+JtKR2y0Lr
         IPis4taj0Wrrtl6+S30VwkZG5MNtF+Xe6rYrw=
Message-ID: <86802c440809041307i24cce782u4937d6fd2311c6f@mail.gmail.com>
Date: Thu, 4 Sep 2008 13:07:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: order functions in cpu/common.c and cpu/common_64.c
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080904200421.GA24295@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220331936-15100-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080904191205.GC24990@elte.hu> <20080904193733.GA25136@elte.hu>
	 <20080904194127.GA2542@elte.hu> <20080904200421.GA24295@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2008 at 1:04 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> > i've pushed out the broken tree into tip/tmp.master.broken (havent
>> > updated tip/master with the breakage). I've removed the broken
>> > printk in kernel/resource.c that Andrew found, see commit
>> > 06e44f6af324 - so that's not the cause.
>>
>> i've double checked that 06e44f6af324 is applied. I'll bisect this.
>
> bisection came up with:
>
>  # good: [8bfd9710] Merge branch 'x86/xsave'
>  # bad:  [06e44f6a] IO resources: fix/remove printk
>  # good: [282a5f84] Merge branch 'irq/sparseirq'
>  # bad:  [a0854a46] x86: make 32bit support show_msr like 64 bit
>  # good: [5031088d] x86: delay early cpu initialization until cpuid is
>  # good: [9d31d35b] x86: order functions in cpu/common.c and cpu/commo
>  # bad:  [10a434fc] x86: remove cpu_vendor_dev
>
> | 10a434fcb23a57c385177a0086955fae01003f64 is first bad commit
> | commit 10a434fcb23a57c385177a0086955fae01003f64
> | Author: Yinghai Lu <yhlu.kernel@gmail.com>
> | Date:   Thu Sep 4 21:09:45 2008 +0200
> |
> |     x86: remove cpu_vendor_dev
>
> and the thing is, 10a434fc is way too big:
>
> | 15 files changed, 106 insertions(+), 106 deletions(-)
>
> and it's not obvious at first (neither at second) sight what the problem
> is. You really need to start doing much smaller patches for such
> critical/hard-to-debug code areas.
>
could be alignment again...

YH
