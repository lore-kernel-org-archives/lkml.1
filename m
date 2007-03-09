Return-Path: <linux-kernel-owner+w=401wt.eu-S1767641AbXCIX0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767641AbXCIX0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767643AbXCIX0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:26:43 -0500
Received: from gw.goop.org ([64.81.55.164]:48986 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767642AbXCIX0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:26:42 -0500
Message-ID: <45F1ED30.5070402@goop.org>
Date: Fri, 09 Mar 2007 15:26:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: question about periodic clocks
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

How does the clock period get set on periodic timers?  In my clock
driver, I'm seeing a call to ->set_mode(CLOCK_EVT_MODE_PERIODIC, evt),
but then... nothing.  I was expecting a call to set_next_event to set
the timer period.

The calltrace is:

#0  xen_new_set_mode (mode=CLOCK_EVT_MODE_PERIODIC, evt=0xc10a2ac0)
    at arch/i386/xen/time.c:275
#1  0xc01323da in clockevents_set_mode (dev=0xc10a2ac0, 
    mode=CLOCK_EVT_MODE_PERIODIC) at kernel/time/clockevents.c:64
#2  0xc0132854 in tick_setup_periodic (dev=0xc10a2ac0, 
    broadcast=<value optimized out>) at kernel/time/tick-common.c:111

and tick_setup_periodic does just call clockevents_set_mode, but nothing
to set a period.

Am I supposed to assume some default period?  HZ?  (That's what hpet
seems to do.)

Is set_next_event only ever called if the timer is in ONESHOT mode?

Thanks,
    J
