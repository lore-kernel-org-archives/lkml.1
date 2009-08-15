Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZHOWTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZHOWTr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 18:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZHOWTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 18:19:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47050 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZHOWTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 18:19:46 -0400
Date: Sun, 16 Aug 2009 00:19:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>
Subject: Re: [RFC patch 0/3] Support for irq chips on slow busses (i2c,
	spi) - V2
Message-ID: <20090815221921.GA27637@elf.ucw.cz>
References: <20090815174512.491425246@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090815174512.491425246@linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The support for irq chips on slow busses eg. i2c, spi has been
> discussed to great length several times. Most of the details can be
> found in this thread: http://lkml.org/lkml/2009/7/21/266
> 
> The following patch series is a round up of the various patch snippets
> sent out during the discussion and the ideas we agreed on.
> 
> This is version 2 of the patch series. The main changes vs. V1
> (http://lkml.org/lkml/2009/8/13/348)
> 
>  - patch 1/3: Provide a generic primary handler function which just
>    	      returns IRQ_WAKE_THREAD as this is all what oneshot
>    	      threaded handlers need to avoid useless copies of that
>    	      all over the place.
> 
>  - patch 2/3: Reverted to the initial idea of conditional locking to
>    	      allow drivers to be used for both slowbus and standard
>    	      interrupts without any magic in the driver code
> 
>  - patch 3/3: To avoid different driver code for nested or separate
>    	      thread handling a new function is provided which allows
>    	      to mark the interrupt nested. request_threaded_irq()
>    	      creates a separate thread only when the flag is not set.
> 
> Please have a thorough look and hopefully a test ride on your
> favourite slowbus irq chip implementation so we can get this into .32

FWIW, it looks ok to me.
					Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
