Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbXJIFYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbXJIFYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 01:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbXJIFYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 01:24:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60113
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbXJIFX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 01:23:59 -0400
Date: Mon, 08 Oct 2007 22:23:58 -0700 (PDT)
Message-Id: <20071008.222358.133742279.davem@davemloft.net>
To: david-b@pacbell.net
Cc: greg@kroah.com, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071009050019.C6C6023718A@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20071008.204236.92016616.davem@davemloft.net>
	<20071009043909.GA4940@kroah.com>
	<20071009050019.C6C6023718A@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Mon, 08 Oct 2007 22:00:19 -0700

> Assuming PCI is present, /sys/bus/pci/devices/*/class can tell
> if EHCI is present (0x0c0320) ... if so, load that driver.
> Then repeat for OHCI (0x0c0310) and UHCI (0x0c0300).

These are facts all of us know very well, but implementing this in
userspace in a failsafe manner isn't practical.  That's what we're
discussing.

There are things that autoload USB drivers way before udev or similar
even get started.

For example, the first thing some distributions do is try to load the
correct keyboard maps.  Guess what that can do?  It triggers a load of
all of the modular USB host controller drivers in case we have a USB
keyboard.

The only real solution is in the kernel, because it is the only
clean place to trap all of the potential module load events.
