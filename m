Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZHIJn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZHIJn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 05:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbZHIJn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 05:43:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49125 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZHIJn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 05:43:26 -0400
Date: Sun, 9 Aug 2009 10:43:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Wim Van Sebroeck <wim@iguana.be>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH RT 8/6] [ARM, WATCHDOG] davinci: include mach/timex.h
	in davinci_wdt.c
Message-ID: <20090809094306.GA26591@n2100.arm.linux.org.uk>
References: <20090807203939.GA19374@pengutronix.de> <1249810600-21946-1-git-send-email-u.kleine-koenig@pengutronix.de> <1249810600-21946-2-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1249810600-21946-2-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 11:36:39AM +0200, Uwe Kleine-König wrote:
> This fixes a a build failure for 2.6.31-rc4-rt1 (ARCH=arm,
> davinci_all_defconfig):
> 
> 	drivers/watchdog/davinci_wdt.c: In function 'wdt_enable':
> 	drivers/watchdog/davinci_wdt.c:102: error: 'CLOCK_TICK_RATE' undeclared (first use in this function)
> 	drivers/watchdog/davinci_wdt.c:102: error: (Each undeclared identifier is reported only once
> 	drivers/watchdog/davinci_wdt.c:102: error: for each function it appears in.)

It should not be using CLOCK_TICK_RATE - there was a move to clean
up the use of that symbol and restrict it just to the i8253 PIT.
Please create something else like DAVINCI_TICK_RATE instead.
