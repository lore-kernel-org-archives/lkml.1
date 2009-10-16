Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbZJPMAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbZJPMAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 08:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758801AbZJPMAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 08:00:21 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:54026 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbZJPMAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 08:00:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Kvnug8mUJfUSWq+jaZFnlXqb+EKNmIsFQ1MuEdMb9MsVD9hZCFyzwGmEoSEczNfzjP
         lRzVRDHVAF+2G5QoW+XZFQKkahElOdGW+xQgE9ALhK+ypo5k/nrNJKIyB8yFVvyzCx6K
         Z/UFelIz1Iu6KEGhudQTlAFy3j3q+lsBDo0Tc=
Subject: Re: [PATCH 1/2] tracing: convert trace_clock_local() as weak
 function
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mips <linux-mips@linux-mips.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Manuel Lauss <manuel.lauss@googlemail.com>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20091016115214.GA3159@hack>
References: <4205779ae74d7c4144ee6cbf4e3f15f833646356.1255692619.git.wuzhangjin@gmail.com>
	 <20091016115214.GA3159@hack>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Fri, 16 Oct 2009 19:59:32 +0800
Message-Id: <1255694372.7084.3.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 19:52 +0800, Américo Wang wrote:
> On Fri, Oct 16, 2009 at 07:38:24PM +0800, Wu Zhangjin wrote:
> >trace_clock_local() is based on the arch-specific sched_clock(), in X86,
> >it is tsc(64bit) based, which can give very high precision(about 1ns
> >with 1GHz). but in MIPS, the sched_clock() is jiffies based, which can
> >give only 10ms precison with 1000 HZ. which is not enough for tracing,
> >especially for Real Time system.
> >
> >so, we need to implement a MIPS specific sched_clock() to get higher
> >precision. There is a tsc like clock counter register in MIPS, whose
> >frequency is half of the processor, so, if the cpu frequency is 800MHz,
> >the time precision reaches 2.5ns, which is very good for tracing, even
> >for Real Time system.
> >
> >but 'Cause it is only 32bit long, which will rollover quickly, so, such
> >a sched_clock() will bring with extra load, which is not good for the
> >whole system. so, we only need to implement a arch-specific
> >trace_clock_local() for tracing. as a preparation, we convert it as a
> >weak function.
> >
> >The MIPS specific trace_clock_local() is coming in the next patch.
> >
> >Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> >---
> > kernel/trace/trace_clock.c |    2 +-
> > 1 files changed, 1 insertions(+), 1 deletions(-)
> >
> >diff --git a/kernel/trace/trace_clock.c b/kernel/trace/trace_clock.c
> >index 20c5f92..a04dc18 100644
> >--- a/kernel/trace/trace_clock.c
> >+++ b/kernel/trace/trace_clock.c
> >@@ -26,7 +26,7 @@
> >  * Useful for tracing that does not cross to other CPUs nor
> >  * does it go through idle events.
> >  */
> >-u64 notrace trace_clock_local(void)
> >+u64 __attribute__((weak)) notrace trace_clock_local(void)
> 
> We have __weak.
> 

Thanks, will use it in the next version.

Regards,
	Wu Zhangjin

