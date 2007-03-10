Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbXCJIel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbXCJIel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933296AbXCJIel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:34:41 -0500
Received: from www.osadl.org ([213.239.205.134]:33987 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933004AbXCJIek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:34:40 -0500
Subject: Re: question about periodic clocks
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45F1ED30.5070402@goop.org>
References: <45F1ED30.5070402@goop.org>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 09:41:00 +0100
Message-Id: <1173516061.24738.1148.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-09 at 15:26 -0800, Jeremy Fitzhardinge wrote:
> How does the clock period get set on periodic timers?  In my clock
> driver, I'm seeing a call to ->set_mode(CLOCK_EVT_MODE_PERIODIC, evt),
> but then... nothing.  I was expecting a call to set_next_event to set
> the timer period.

Good point. I never thought about that and we set the period in the
clock event device itself. You are right, the clockevents layer should
hand over the period either with the set_mode call or seperately.
Probably with the set_mode call, as it is needed exactly there and we
don't want to have a "if (dev->mode == XXX)" check in set_next_event().

I look into this.

Thanks,

	tglx


