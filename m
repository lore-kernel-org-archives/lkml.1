Return-Path: <linux-kernel-owner+w=401wt.eu-S1030510AbXD2QUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510AbXD2QUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 12:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030476AbXD2QUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 12:20:36 -0400
Received: from neon.samage.net ([85.17.153.66]:37121 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030576AbXD2QUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 12:20:15 -0400
Message-ID: <4655.81.207.0.53.1177863612.squirrel@secure.samage.net>
Date: Sun, 29 Apr 2007 18:20:12 +0200 (CEST)
Subject: [2.6.21] BUG: clocksource_watchdog isn't reset after resume
From: "Indan Zupancic" <indan@nul.nu>
To: tglx@linutronix.de, johnstul@us.ibm.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: a350ae07b5350cdad28cef237d2e7179
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After s2ram, basically the following happens, which shouldn't happen:

[    0.880234] Clocksource tsc unstable (delta = 449782067799 ns)
[    0.881221] Time: pit clocksource has been installed.

Looking at the source, it seems that clocksource_watchdog isn't reset
after resume, while the clock source used is, and hence it thinks that
the clock is unstable.

So it appears that timekeeping_resume and/or timekeeping_suspend should
do something to prevent this from happening.

Maybe by somehow updating 'watchdog_last' after resume, but it's unclear
how that should happen, as the watchdog doesn't export any functions and
the only thing that's reachable which calls anything watchdog related is
clocksource_register().

This is a UP machine with no frequency changing CPU, so the tsc is good
to use (before someone complaints that I should use the pm timer).

An alternative would be to not select CONFIG_CLOCKSOURCE_WATCHDOG, but
it's unclear how or by what that's selected.

Greetings,

Indan


