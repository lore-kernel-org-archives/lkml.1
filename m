Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbZHMTl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbZHMTl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZHMTl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:41:26 -0400
Received: from www.tglx.de ([62.245.132.106]:56307 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792AbZHMTlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:41:25 -0400
Message-Id: <20090813191535.945521006@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 13 Aug 2009 19:40:35 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: [RFC patch 0/3] Support for irq chips on slow busses (i2c, spi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The support for irq chips on slow busses eg. i2c, spi has been
discussed to great length several times. Most of the details can be
found in this thread: http://lkml.org/lkml/2009/7/21/266

The following patch series is a round up of the various patch snippets
sent out during the discussion and the ideas we agreed on.

There are some subtle differences to the initial test patches:

1) Instead of using a separate flow handler we allow to request the
one shot feature with a flag on request_irq and integrate the oneshot
feature into the existing level/edge handlers.

2) Instead of conditional locking which makes the patch smaller but
hides the already known fact that a device sits behind a slow irq chip
I implemented a set of separate management functions (see patch
2/3). The initial idea with the conditional locking can be found here:
http://lkml.org/lkml/2009/7/22/163

3) patch 3/3 implements a helper function which allows the
demultiplexing thread to call the demux handlers in its own thread
context with out creating a separate thread for each subdevice
interrupt. The device driver needs to request the interrupt via
request_nested_slowbus_irq() to prevent the creation of the extra
thread.

Please have a thorough look and hopefully a test ride on your
favourite slowbus irq chip implementation so we can get this into .32

Thanks,

	tglx

