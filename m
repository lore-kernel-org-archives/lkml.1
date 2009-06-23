Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbZFWJey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbZFWJey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZFWJep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:34:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16233 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZFWJep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:34:45 -0400
Date: Tue, 23 Jun 2009 11:33:35 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
In-reply-to: <20090623102129.3b58adbf@lxorguk.ukuu.org.uk>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: "'David Brownell'" <david-b@pacbell.net>,
       "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com
Message-id: <002101c9f3e5$b4dc5a10$1e950e30$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: Acnz49rBRb1x5B+XSDKJf5RAr5Gd1AAARAtg
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com>
 <200906222026.51511.david-b@pacbell.net>
 <001c01c9f3cd$ad02b1d0$07081570$%szyprowski@samsung.com>
 <200906230022.39040.david-b@pacbell.net>
 <002001c9f3dd$d7a24df0$86e6e9d0$%szyprowski@samsung.com>
 <20090623102129.3b58adbf@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, June 23, 2009 11:21 AM, Alan Cox wrote:

> > that g_serial driver interacts with tty layer in that packet_done
> callback,
> > so this is the source of the problems. I noticed that some other UDC
> > drivers also does all its job from an interrupt, so they also might
> be
> > affected. How this bug should be properly resolved?
> 
> Either by not setting ->low_latency or by running the data paths from a
> non IRQ context.
> 
> Basically: don't set tty->low_latency if you are handling the
> processing
> from the IRQ path. The only case low_latency is useful is handling data
> from a non-IRQ path where you have latency concerns for tx/rx
> switching.

I know that, but I wonder how this should be handled in g_serial gadget
driver, which might be working on top of both types of low level
drivers (doing callback from irq or tasklet).

Are there any drawbacks of disabling low_latency mode if callbacks are
done from tasklet not from interrupt? If no then the low latency mode
should be disabled in g_serial driver.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


