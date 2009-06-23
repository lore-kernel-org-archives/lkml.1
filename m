Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbZFWJUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbZFWJUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbZFWJU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:20:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42445 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758054AbZFWJU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:20:26 -0400
Date: Tue, 23 Jun 2009 10:21:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "'David Brownell'" <david-b@pacbell.net>,
       "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com,
       "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Subject: Re: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
Message-ID: <20090623102129.3b58adbf@lxorguk.ukuu.org.uk>
In-Reply-To: <002001c9f3dd$d7a24df0$86e6e9d0$%szyprowski@samsung.com>
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com>
	<200906222026.51511.david-b@pacbell.net>
	<001c01c9f3cd$ad02b1d0$07081570$%szyprowski@samsung.com>
	<200906230022.39040.david-b@pacbell.net>
	<002001c9f3dd$d7a24df0$86e6e9d0$%szyprowski@samsung.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> that g_serial driver interacts with tty layer in that packet_done callback,
> so this is the source of the problems. I noticed that some other UDC
> drivers also does all its job from an interrupt, so they also might be
> affected. How this bug should be properly resolved?

Either by not setting ->low_latency or by running the data paths from a
non IRQ context.

Basically: don't set tty->low_latency if you are handling the processing
from the IRQ path. The only case low_latency is useful is handling data
from a non-IRQ path where you have latency concerns for tx/rx switching.

