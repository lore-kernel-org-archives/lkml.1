Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbXIVTat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbXIVTat (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 15:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbXIVTan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 15:30:43 -0400
Received: from www.osadl.org ([213.239.205.134]:48918 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751549AbXIVTam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 15:30:42 -0400
Subject: Re: [PATCH] usb-gadget-ether: Prevent oops caused by error
	interrupt  race -V2 (comments update)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, bene@linutronix.de,
       akpm@osdl.org
In-Reply-To: <20070922191806.A2F59C2308@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <1190299611.3481.34.camel@chaos>
	 <200709211508.42968.david-b@pacbell.net> <1190482861.4035.59.camel@chaos>
	 <20070922191806.A2F59C2308@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Content-Type: text/plain
Date: Sat, 22 Sep 2007 21:30:40 +0200
Message-Id: <1190489440.4035.103.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-09-22 at 12:18 -0700, David Brownell wrote:
> I think you misread my comment.  Those requests are **NOT** pending!!
> So this update has a *MORE* incorrect description of the issue. 
> 
> That's just the freelist ... it's a fairly conventional model whereby
> there's a pool of "free" request slots which can be issued.  When the
> pool empties, the TX queue shuts down until one of the requests which
> is pending in the hardware completes, and makes a slot free.
> 
> The problem you're addressing is that there's a small window where a
> disconnect IRQ can shut down the TX queue (and empty that freelist)
> after upper layers in the network stack started a transmission on
> an active (pre-disconnect) TX queue.
> 
> That problem is *NOT* related to any pending requests at all!!

Sorry, I misunderstood your comment. Can you please add the correct
comment yourself before we play some more rounds of ping pong ? 

	tglx


