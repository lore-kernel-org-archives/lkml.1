Return-Path: <linux-kernel-owner+w=401wt.eu-S1751192AbXAXLgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbXAXLgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 06:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbXAXLgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 06:36:51 -0500
Received: from www.osadl.org ([213.239.205.134]:44989 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751192AbXAXLgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 06:36:50 -0500
Subject: Re: [PATCH query] arm: i.MX/MX1 clock event source
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <200701240300.27497.pisa@cmp.felk.cvut.cz>
References: <200701210101.27345.pisa@cmp.felk.cvut.cz>
	 <20070122195924.GD21277@elte.hu> <200701230352.57380.pisa@cmp.felk.cvut.cz>
	 <200701240300.27497.pisa@cmp.felk.cvut.cz>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 12:37:06 +0100
Message-Id: <1169638626.21181.170.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 03:00 +0100, Pavel Pisa wrote:
> stays NULL after clock event registration. Interrupts
> runs, but my code doesnot call any function. The notification
> chain and clock events list seems to be filled correctly.
> I have added 
> 
>         clockevent_imx.cpumask = cpumask_of_cpu(0);

Correct. I probably should disable the check for UP.

> to ensure that clock are not used for affinity
> mask reasons. I have tried even exchange clock 
> event forcibly at the end of clockevent_imx initialization.
> But it only resulted in asking timer to switch off
> into unused mode.
> 
> I have added next hack into IRQ
>                                 write_seqlock(&xtime_lock);
>                                 timer_tick();
>                                 write_sequnlock(&xtime_lock);
> which stays enabled until imx_set_mode() is called first time,
> The system boots after this modification, but imx_set_mode()
> is never called and there is no switch to high resolution mode.

You should not set up the timer at all. The setup of the timer happens
from the registration. 

We need to know, why the timer is not picked from the tick code in the
first place and why set_mode() is not called.

	tglx




