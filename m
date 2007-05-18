Return-Path: <linux-kernel-owner+w=401wt.eu-S1757231AbXERHoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbXERHoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 03:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbXERHoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 03:44:23 -0400
Received: from www.osadl.org ([213.239.205.134]:48232 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753876AbXERHoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 03:44:23 -0400
Subject: RE: bug seen with dynticks from CONFIG_HARDIRQS_SW_RESEND
From: Thomas Gleixner <tglx@linutronix.de>
To: "Woodruff, Richard" <r-woodruff2@ti.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <3B6D69C3A9EBCA4BA5DA60D913027429010259ED@dlee13.ent.ti.com>
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com>
	 <1179396659.3764.40.camel@chaos>
	 <3B6D69C3A9EBCA4BA5DA60D913027429010258E8@dlee13.ent.ti.com>
	 <1179434296.12981.14.camel@chaos>
	 <3B6D69C3A9EBCA4BA5DA60D913027429010259ED@dlee13.ent.ti.com>
Content-Type: text/plain
Date: Fri, 18 May 2007 09:49:27 +0200
Message-Id: <1179474567.12981.53.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 17:24 -0500, Woodruff, Richard wrote:
> > This is the original ARM dyntick stuff, right ?
> 
> Yes this is a version is not using clocksource.
> 
> > The dyntick support on your architecture is broken. Why does it fiddle
> > with the timer, when the system is not idle ?
> 
> I can't yet run the test sequence on the latest kernel so I'll have to
> wait to experiment.  A brief look at the new code seems to show a
> similar path but I need to actually run though it to understand better.
> 
> 
> On the irq_resend() path handle_dynamic_tick() is still called as
> before. 

No. NOHZ makes handle_dynamic_tick() a NOP. handle_dynamic_tick()
depends on CONFIG_NO_IDLE_HZ, which is not used when NOHZ is active.

The problem could only arise, when something would disable/enable the
timer interrupt.

	tglx


