Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbZFWIit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbZFWIit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZFWIik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:38:40 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:52589 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZFWIii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:38:38 -0400
Date: Tue, 23 Jun 2009 10:37:23 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
In-reply-to: <200906230022.39040.david-b@pacbell.net>
To: "'David Brownell'" <david-b@pacbell.net>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com,
       "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Message-id: <002001c9f3dd$d7a24df0$86e6e9d0$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 8BIT
Thread-index: Acnz02cXuhg7XJ/LQ+aAs6BkBa+L/gACXJnw
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com>
 <200906222026.51511.david-b@pacbell.net>
 <001c01c9f3cd$ad02b1d0$07081570$%szyprowski@samsung.com>
 <200906230022.39040.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

On Tuesday, June 23, 2009 9:23 AM, David Brownell wrote:

> > > Like, oh, changing a spinlock to a mutex.   You might change the
> > > low_latency setting and review how that's now supposed to behave.
> >
> > In in gs_open() function in drivers/usb/gadget/u_serial.c, after the
> > line 780 I've added:
> >
> > tty->low_latency = 1;
> 
> That's already how it's set.  Try instead *REMOVING* the line
> which sets that flag.

My fault. I didn't notice that a few lines lower the low_latency flag is
alredy set and I thought I should set it. After removing that, g_serial
started working. :) Thanks a lot.

I noticed that there is also a comment:
/* low_latency means ldiscs work in tasklet context, without
 * needing a workqueue schedule ... easier to keep up.
 */

So in low latency mode calls are made from a tasklet. This is not true in
my case, as the S3C OTG UDC driver does all its job in interrupts. This
way also a (usb) packet_done callback is done from an interrupt. I expect
that g_serial driver interacts with tty layer in that packet_done callback,
so this is the source of the problems. I noticed that some other UDC
drivers also does all its job from an interrupt, so they also might be
affected. How this bug should be properly resolved?

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


