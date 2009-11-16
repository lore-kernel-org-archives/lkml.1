Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbZKPPVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbZKPPVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZKPPVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:21:18 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:51148 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZKPPVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:21:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=R5JEBSf3aZ0SChe1IcUpEcCX6b79HYiJ2qeqveam8KKOJIF1dY7lm6OGx/KnTXUD9/
         YffOBsWfhtO7YF1gI1McUSAyWy6KYpEND5mm0YDuPJVAo7sqljoiHxp0+DeDqe2w4HIM
         vxviFnV0pFB6RBWtRZ2b5ysGsYcYcH0qLUbfU=
Subject: Re: [PATCH v8 01/16] tracing: convert trace_clock_local() as weak
 function
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rostedt@goodmis.org, Ralf Baechle <ralf@linux-mips.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       David Daney <ddaney@caviumnetworks.com>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Michal Simek <monstr@monstr.eu>,
       "Maciej W . Rozycki" <macro@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, zhangfx@lemote.com, zhouqg@gmail.com
In-Reply-To: <alpine.LFD.2.00.0911161559280.24119@localhost.localdomain>
References: <cover.1258177321.git.wuzhangjin@gmail.com>
	 <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1258177321.git.wuzhangjin@gmail.com>
	 <alpine.LFD.2.00.0911161559280.24119@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Mon, 16 Nov 2009 23:21:08 +0800
Message-ID: <1258384868.15821.9.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 16:07 +0100, Thomas Gleixner wrote:
> On Sat, 14 Nov 2009, Wu Zhangjin wrote:
> 
> > From: Wu Zhangjin <wuzhangjin@gmail.com>
> > 
> > trace_clock_local() is based on the arch-specific sched_clock(), in X86,
> > it is tsc(64bit) based, which can give very high precision(about 1ns
> > with 1GHz). but in MIPS, the sched_clock() is jiffies based, which can
> > give only 10ms precison with 1000 HZ. which is not enough for tracing,
> > especially for Real Time system.
> > 
> > so, we need to implement a MIPS specific sched_clock() to get higher
> > precision. There is a tsc like clock counter register in MIPS, whose
> > frequency is half of the processor, so, if the cpu frequency is 800MHz,
> > the time precision reaches 2.5ns, which is very good for tracing, even
> > for Real Time system.
> > 
> > but 'Cause it is only 32bit long, which will rollover quickly, so, such
> > a sched_clock() will bring with extra load, which is not good for the
> > whole system. so, we only need to implement a arch-specific
> > trace_clock_local() for tracing. as a preparation, we convert it as a
> > weak function.
> 
> Hmm, I'm not convinced that this is really a huge overhead. 
> 
> First of all the rollover happens once every 10 seconds on a 800MHz
> machine. 
> 
> Secondly we have a lockless implementation of extending 32bit counters
> to 63 bit which is used at least by ARM to provide a high resolution
> sched_clock implementation. See include/linux/cnt32_63.h and the users
> in arch/
> 
> But that's a problem which can be discussed seperately and does not
> affect the rest of the tracing infrastructure. I really would
> recommend that you implement a sched_clock for the r4k machines based
> on cnt32_63 and measure the overhead. Having a fine granular
> sched_clock in general is probably not a bad thing.
> 

Thanks very much for your prompt, 

Will have a look at cnt32_to_63() in include/linux/cnt32_to_63.h later.

Thanks & Regards,
	Wu Zhangjin

