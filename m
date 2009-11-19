Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbZKSKhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbZKSKhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 05:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZKSKhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 05:37:09 -0500
Received: from www.tglx.de ([62.245.132.106]:59836 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732AbZKSKhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 05:37:08 -0500
Date: Thu, 19 Nov 2009 11:36:42 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
cc: Ingo Molnar <mingo@elte.hu>, Jean Delvare <khali@linux-fr.org>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cleanup sched_yield (sys)call nesting.
In-Reply-To: <1258606116.25022.57.camel@sven.thebigcorporation.com>
Message-ID: <alpine.LFD.2.00.0911191122210.24119@localhost.localdomain>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com>  <20091107210147.3e754278@hyperion.delvare>  <4AF7148C.9090706@thebigcorporation.com>  <20091112211255.09cd884a@hyperion.delvare>  <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
  <20091116155606.GC29479@sirena.org.uk>  <c384c5ea0911171650t1c441dc4v746d31e4154fcb30@mail.gmail.com>  <20091118010520.4cd397d4@lxorguk.ukuu.org.uk>  <c384c5ea0911180828x7c857189w3316c93bb78100ab@mail.gmail.com>  <20091118175202.490989d8@hyperion.delvare>
  <1258577194.12429.86.camel@sven.thebigcorporation.com>  <alpine.LFD.2.00.0911182153010.24119@localhost.localdomain>  <1258578290.12429.108.camel@sven.thebigcorporation.com>  <alpine.LFD.2.00.0911182233510.24119@localhost.localdomain>
 <1258606116.25022.57.camel@sven.thebigcorporation.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009, Sven-Thorsten Dietrich wrote:
> We are trying to get rid of __sched_yield calls from-inside-the-Kernel,
> but sys_sched_yield() from user-space will remain.
> 
> This patch breaks out the in-Kernel interface for the yield()
> functionality and deprecates it explicitly.
> 
> The sys_sched_yield() variety, however is not deprecated.
> 
> The objective is to deprecate *only* the in-kernel calls to
> sched_yield(), in hopes of reducing new calls to sched_yield() being
> added.

Nothing in the kernel calls sched_yield() because there is no such
function.

> Eventually, when the in-Kernel calls are gone, the __sched_yield() would
> be removed, and the first 2 hunks would essentially be reverted, leaving
> only the user-space caller sys_sched_yield. 
> 
> For the time being we add 2 lines and 2 braces of bulk, in hopes that
> elsewhere this eliminates more __sched_yield() calls being added while
> we work to eliminate the ones that exist already.

Err ? WTF do you need to fiddle in sched.c to deprecate a function ?

Nothing in the kernel calls sys_sched_yield() except the syscall and
the implementation of yield() in sched.c. The drivers,... call yield()
nothing else.

To deprecate yield() all you need is adding __deprecated to the
function prototype in sched.h. And that's the only way you alert users
because it warns when compiling code which _calls_ yield() not when
compiling the implementation in sched.c.

Sigh,

	tglx
