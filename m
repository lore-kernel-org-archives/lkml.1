Return-Path: <linux-kernel-owner+w=401wt.eu-S1751310AbZHORtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbZHORtH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 13:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZHORtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 13:49:07 -0400
Received: from www.tglx.de ([62.245.132.106]:49826 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbZHORtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 13:49:06 -0400
Message-Id: <20090815174512.491425246@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 15 Aug 2009 17:48:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: [RFC patch 0/3] Support for irq chips on slow busses (i2c, spi) - V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The support for irq chips on slow busses eg. i2c, spi has been
discussed to great length several times. Most of the details can be
found in this thread: http://lkml.org/lkml/2009/7/21/266

The following patch series is a round up of the various patch snippets
sent out during the discussion and the ideas we agreed on.

This is version 2 of the patch series. The main changes vs. V1
(http://lkml.org/lkml/2009/8/13/348)

 - patch 1/3: Provide a generic primary handler function which just
   	      returns IRQ_WAKE_THREAD as this is all what oneshot
   	      threaded handlers need to avoid useless copies of that
   	      all over the place.

 - patch 2/3: Reverted to the initial idea of conditional locking to
   	      allow drivers to be used for both slowbus and standard
   	      interrupts without any magic in the driver code

 - patch 3/3: To avoid different driver code for nested or separate
   	      thread handling a new function is provided which allows
   	      to mark the interrupt nested. request_threaded_irq()
   	      creates a separate thread only when the flag is not set.

Please have a thorough look and hopefully a test ride on your
favourite slowbus irq chip implementation so we can get this into .32

Thanks,

	tglx




