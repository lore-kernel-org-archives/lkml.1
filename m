Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab0BWSDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:03:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48867 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab0BWSDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:03:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=TmnEcBdXtfUA:10 a=7U3hwN5JcxgA:10 a=CwPc2XfKizsTsBQkqyQA:9 a=axfCjyS7r7rSqQ-nA74YSFOJgpIA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 04/10] ARM: ftrace: allow building without frame
 pointers
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Rabin Vincent <rabin@rab.in>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
In-Reply-To: <20100223175807.GB5836@debian>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
	 <1266090518-31120-5-git-send-email-rabin@rab.in>
	 <20100222190516.GJ5055@nowhere> <1266931113.19540.5.camel@frodo>
	 <20100223171112.GC5357@nowhere>  <20100223175807.GB5836@debian>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 23 Feb 2010 13:03:05 -0500
Message-ID: <1266948185.24271.6079.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 23:28 +0530, Rabin Vincent wrote:

> The easiest option to have a more obvious message than a linker error
> would be to add something like this in entry-common.S:
> 
>   #if (__GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 4)) \
> 	&& !defined(OLD_MCOUNT)
>   #warning Ftrace on GCC < 4.4 requires frame pointers
>   #endif
> 
> Messages like this are also present in other places in ARM (for example
> arch/arm/kernel/unwind.c), so this wouldn't be this first.
> 
> Note that the above message would help in all cases except the one where
> someone builds the kernel with !fp and GCC 4.4+, and then builds a
> module with an older GCC.  That would still be only a linker error.

I was going to recommend the #if above. But shouldn't it be a #error
instead of a #warning?

-- Steve


