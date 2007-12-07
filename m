Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbXLGLZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbXLGLZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 06:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbXLGLY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 06:24:59 -0500
Received: from mail.polimi.it ([131.175.12.3]:34757 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbXLGLY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 06:24:58 -0500
From: stefano.brivio@polimi.it
Message-ID: <20071207122310.maqkoxlb4gsg4ggc@webmail.polimi.it>
Date: Fri, 07 Dec 2007 12:23:10 +0100
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
References: <20071207021952.6f0ac922@morte>
	<20071207084559.GA11162@elte.hu>
	<200712072213.06530.nickpiggin@yahoo.com.au>
In-Reply-To: <200712072213.06530.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.5)
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.6.30824
X-PerlMx-Spam: Gauge=IIIIII, Probability=26%, Report='RCVD_IN_CBL 3, BODY_SIZE_800_899 0, ECARD_KNOWN_DOMAINS 0, NO_REAL_NAME 0, __CD 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nick Piggin <nickpiggin@yahoo.com.au>:

> On Friday 07 December 2007 19:45, Ingo Molnar wrote:
>>
>> ah, printk_clock() still uses sched_clock(), not jiffies. So it's not
>> the jiffies counter that goes back and forth, it's sched_clock() - so
>> this is a printk timestamps anomaly, not related to jiffies. I thought
>> we have fixed this bug in the printk code already: sched_clock() is a
>> 'raw' interface that should not be used directly - the proper interface
>> is cpu_clock(cpu).
>
> It's a single CPU box, so sched_clock() jumping would still be
> problematic, no?

I guess so. Definitely, it didn't look like a printk issue. Drivers  
don't read logs, usually. But they got confused anyway (it seems that  
udelay's get scaled or fail or somesuch - I can't test it right now,  
will provide more feedback in a few hours).


--
Ciao
Stefano



