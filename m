Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbXBVReL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbXBVReL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 12:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXBVReL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 12:34:11 -0500
Received: from www.osadl.org ([213.239.205.134]:51265 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751727AbXBVReK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 12:34:10 -0500
Subject: Re: NO_HZ: timer interrupt stuck
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: David Miller <davem@davemloft.net>
Cc: jengelh@linux01.gwdg.de, kronos.it@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070222.092652.55507017.davem@davemloft.net>
References: <1172099859.25076.132.camel@localhost.localdomain>
	 <Pine.LNX.4.61.0702221334460.28624@yvahk01.tjqt.qr>
	 <1172159501.25076.182.camel@localhost.localdomain>
	 <20070222.092652.55507017.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 18:39:19 +0100
Message-Id: <1172165959.25076.192.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 09:26 -0800, David Miller wrote:
> BTW, I'm adding support for sparc64, and before I get much further
> will the code handle a oneshot-only device?  That's basically what I
> have (sparc64 basically has a TSC and a "comparison" register, you
> write the "comparison" register with the TSC value at which you'd like
> the timer interrupt to occur, so it's one-shot and you have to write
> it again to get the next timer).

Yes, all you need is to omit the CLOCK_EVT_FEAT_PERIODIC flag when you
register your device.

> I see logic in the generic code to do periodic events when the
> timer only provides one-shot ticks.  But as far as I can tell
> both the HPET and the local APIC support periodic timers so
> I can't tell how much testing that code has gotten :-)

Not much :)

> I, in fact, don't see any clockevent device in the current tree that
> does not set CLOCK_EVT_FEAT_PERIODIC.

There is an ARM patch which makes use of it.

> I guess you could clear that bit just to test those generic code
> paths. :-)

yep.

> BTW, sparc64 always did the trick where the do_timer() work was done
> by one of the per-cpu local timer interrupts, I'm glad the idea gained
> traction generically. :-)))

:)

	tglx


