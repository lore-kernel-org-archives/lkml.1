Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbXBWJZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbXBWJZ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 04:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXBWJZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 04:25:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56593
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752153AbXBWJZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 04:25:55 -0500
Date: Fri, 23 Feb 2007 01:25:19 -0800 (PST)
Message-Id: <20070223.012519.48528691.davem@davemloft.net>
To: tglx@linutronix.de
Cc: jengelh@linux01.gwdg.de, kronos.it@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: NO_HZ: timer interrupt stuck
From: David Miller <davem@davemloft.net>
In-Reply-To: <1172165959.25076.192.camel@localhost.localdomain>
References: <1172159501.25076.182.camel@localhost.localdomain>
	<20070222.092652.55507017.davem@davemloft.net>
	<1172165959.25076.192.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 22 Feb 2007 18:39:19 +0100

> On Thu, 2007-02-22 at 09:26 -0800, David Miller wrote:
> > BTW, I'm adding support for sparc64, and before I get much further
> > will the code handle a oneshot-only device?  That's basically what I
> > have (sparc64 basically has a TSC and a "comparison" register, you
> > write the "comparison" register with the TSC value at which you'd like
> > the timer interrupt to occur, so it's one-shot and you have to write
> > it again to get the next timer).
> 
> Yes, all you need is to omit the CLOCK_EVT_FEAT_PERIODIC flag when you
> register your device.

Thanks a lot Thomas.

I noticed while doing this work that the generic clock code is
incompatible with the time interpolator, since both provide a
do_{get,set}timeofday() implementation.  Just FYI...
