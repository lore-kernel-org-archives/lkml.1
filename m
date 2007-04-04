Return-Path: <linux-kernel-owner+w=401wt.eu-S966229AbXDDBV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966229AbXDDBV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966233AbXDDBV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:21:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43253
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966229AbXDDBVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:21:25 -0400
Date: Tue, 03 Apr 2007 18:21:25 -0700 (PDT)
Message-Id: <20070403.182125.77058566.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: paulus@samba.org, dwmw2@infradead.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070404021924.71e87580@the-village.bc.nu>
References: <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	<20070403.165518.55726194.davem@davemloft.net>
	<20070404021924.71e87580@the-village.bc.nu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Wed, 4 Apr 2007 02:19:24 +0100

> > I totally agree with Paul, the onboard serial device should get
> > ttyS0 regardless of what hardare is used to drive it.
> 
> Thats between you and udev.

That might be true when udev exists, but it doesn't for the console
specification on the kernel command line.

I don't care about ordering, but the name matters just like "eth%d"
is the default name for all ethernet devices.

Using different majors for different instances of the exact same kind
of device is really not smart.  It's a serial port, and if you try
to dress it up to be something else you run into all kinds of problems.

Not the least of which is the user has to scratch his head figuring
out what kind of chip drives his serial console, he just wants the
first serial port and he should have a way to say just that even
on the kernel command line.

