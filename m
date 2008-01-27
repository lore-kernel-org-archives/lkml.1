Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYA0ATn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYA0ATn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 19:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbYA0ATe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 19:19:34 -0500
Received: from simmts7-srv.bellnexxia.net ([206.47.199.165]:56179 "EHLO
	simmts7-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755181AbYA0ATR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 19:19:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAMNcm0ecIsJH/2dsb2JhbAAIrA4
Message-ID: <479BCE03.6070603@gmail.com>
Date: Sat, 26 Jan 2008 20:19:15 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: X fails to start with latest Linus git
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

Starting X (autostarted with GDM) manages to lock up my system
(requiring a hard reset) after the first few tree merges of the window,
and bisection shows:

-----------------

19ef9309273d26cb005cb23e6a370353dca91099 is first bad commit
commit 19ef9309273d26cb005cb23e6a370353dca91099
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jan 25 21:08:34 2008 +0100

    printk: use ktime_get()

    printk timestamps: use ktime_get().

    Some platforms have a functioning clocksource function only after
    they are done with early bootup, so delay this until out of
    SYSTEM_BOOTING state.

    it's also inherently safe now, as any bugs in this area will be
    caught by the printk recursion checks.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

-----------------

as the first bad commit.  I have no idea why that would cause problems,
so it could also be some timing-related problem that just happened to
bisect to this patch.

I will try advancing to the head of Linus' tree and then reverting this
patch to make sure it fixes the problem, but I figured I'd send this
first to see if it is obvious to anyone.

-- 
Kevin Winchester

