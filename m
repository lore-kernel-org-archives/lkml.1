Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbXEPH4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbXEPH4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 03:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbXEPH4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 03:56:22 -0400
Received: from www.osadl.org ([213.239.205.134]:43321 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753066AbXEPH4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 03:56:21 -0400
Subject: Re: clockevent questions
From: Thomas Gleixner <tglx@linutronix.de>
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <38b2ab8a0705160042o350d429ct72c43749ff6bcbb8@mail.gmail.com>
References: <38b2ab8a0705120754l281f54eevd1e91e2f01fff6f2@mail.gmail.com>
	 <1178982892.22481.183.camel@localhost.localdomain>
	 <38b2ab8a0705121313k37be467cy55402b490101ac9c@mail.gmail.com>
	 <1179001391.22481.216.camel@localhost.localdomain>
	 <38b2ab8a0705150147s4ce72914qfa30d543ed8a4839@mail.gmail.com>
	 <1179267014.12838.38.camel@chaos>
	 <38b2ab8a0705160042o350d429ct72c43749ff6bcbb8@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 16 May 2007 10:00:32 +0200
Message-Id: <1179302432.12838.62.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 09:42 +0200, Francis Moreau wrote:
> > On Tue, 2007-05-15 at 10:47 +0200, Francis Moreau wrote:
> > > My question is about the clock resolution field which is equal to 1ns.
> > > How is this possible since my timer's frequency is only 100Mhz ?
> >
> > you are right. It is a bit strange. The resolution info is not really
> > reflecting the clock event source capability. I look if there is a sane
> > solution for that.
> >
> 
> Doesn't that make hrtimer_get_res() and its callers buggy since they
> return this 1ns value which is not reflecting the correct clock event
> capability ?

Well, it's not really buggy. It's just not telling the truth.

> Another question about the output of '/proc/timer_list':
> 
> [...]
> active timers:
>  #0: <c03fde10>, tick_sched_timer, S:01
>  # expires at 64696546875000 nsecs [in 2514469 nsecs]
>  .expires_next   : 64696546875000 nsecs
> [...]
> 
> Doesn't the 2 expire time lines give the same information ? If so,
> couldn't we merge them into : ".expires_next   : 64696546875000 nsecs
> [in 2514469 nsecs]" ?

No. The timers are taken from the hrtimer queue and the expires_next
value is the clock events code internal value of the next timer event.
The expiry time of the first timer and the clock events code should
match of course, but we definitely want to have them seperate.

	tglx


