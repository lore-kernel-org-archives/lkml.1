Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbXLGLN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbXLGLN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 06:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbXLGLNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 06:13:17 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:33637 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753433AbXLGLNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 06:13:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QmMajNerMXji2nTDZoX/YADqCUHDIs+yyFxL42TPddndP3MNIRRcBJCiYjAnLERs6yYI9m0opT0BeIQwE5RyubzDIUlYCgEghFyvp+uP82yUd5aEhN3Ba0SGMaye0D7r/PYMdnCMbusXTMniShUsNiX7jrrjiJn40srW1ncqWnE=  ;
X-YMail-OSG: t3IVOlcVM1lUnM9ZJwt_XksCd9389s5YxYIPy9s_e3YpfmKBP23F7Fwb5J1uDxwxceLClDd6jA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] scheduler: fix x86 regression in native_sched_clock
Date: Fri, 7 Dec 2007 22:13:05 +1100
User-Agent: KMail/1.9.5
Cc: Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
References: <20071207021952.6f0ac922@morte> <20071207084559.GA11162@elte.hu>
In-Reply-To: <20071207084559.GA11162@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712072213.06530.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 December 2007 19:45, Ingo Molnar wrote:
> * Stefano Brivio <stefano.brivio@polimi.it> wrote:
> > This patch fixes a regression introduced by:
> >
> > commit bb29ab26863c022743143f27956cc0ca362f258c
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Mon Jul 9 18:51:59 2007 +0200
> >
> > This caused the jiffies counter to leap back and forth on cpufreq
> > changes on my x86 box. I'd say that we can't always assume that TSC
> > does "small errors" only, when marked unstable. On cpufreq changes
> > these errors can be huge.
>
> ah, printk_clock() still uses sched_clock(), not jiffies. So it's not
> the jiffies counter that goes back and forth, it's sched_clock() - so
> this is a printk timestamps anomaly, not related to jiffies. I thought
> we have fixed this bug in the printk code already: sched_clock() is a
> 'raw' interface that should not be used directly - the proper interface
> is cpu_clock(cpu).

It's a single CPU box, so sched_clock() jumping would still be
problematic, no?

My patch should fix the worst cpufreq sched_clock jumping issue
I think.
