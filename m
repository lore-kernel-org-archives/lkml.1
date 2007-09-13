Return-Path: <linux-kernel-owner+w=401wt.eu-S1765713AbXIMU3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765713AbXIMU3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbXIMU3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:29:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:43700 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753997AbXIMU3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:29:04 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX186RNkURdU6SPAx2n5Xgrxx2dZfVmqB86osuVTRaf
	+fEZJZD81ahUx3
Date: Thu, 13 Sep 2007 22:29:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Mauch <michael.mauch@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: wake up from a serial port
In-Reply-To: <20070912210639.GA10172@elmicha>
Message-ID: <Pine.LNX.4.60.0709132221540.18773@poirot.grange>
References: <200709100831.l8A8VUH6015446@imap1.linux-foundation.org>
 <20070910132703.2dd92485@the-village.bc.nu> <Pine.LNX.4.60.0709102251250.5200@poirot.grange>
 <20070911081220.GA20847@flint.arm.linux.org.uk> <Pine.LNX.4.60.0709111217470.19259@poirot.grange>
 <20070911121057.34b9e066@the-village.bc.nu> <Pine.LNX.4.60.0709122019100.5909@poirot.grange>
 <20070912210639.GA10172@elmicha>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007, Michael Mauch wrote:

> Guennadi Liakhovetski wrote:
> 
> > Enable wakeup from serial ports, make it run-time configurable over sysfs, 
> > e.g.,
> > 
> > echo enabled > /sys/devices/platform/serial8250.0/tty/ttyS0/power/wakeup
> 
> Interesting, but how does that work from a user's/hardware perspective?
> 
> Do I have to pull DSR/RI to +12V? Can I use one of the other pins to get
> these +12V (i.e. a switch and a resistor to shorten these pins is
> enough)?
> 
> And probably in the BIOS I have to enable "wake on modem ring" (or
> something similar)?

It depends on the hardware. In principle, with this patch _if_ your system 
can suspend while keeping the UART powered on and the interrupt from this 
UART can wake up your system, then using this patch and the command above 
you'll be able to also keep the UART configured, i.e., prevent the driver 
from suspending it during suspend and then an interrupt from this UART 
will wake up the system. How you generate this interrupt - doesn't matter. 
Whether it is a received byte, or a modem line toggle, as long as it 
produces an interrupt, the system will wake up.

Don't know whether "normal" PCs can do that and if yes - how.

Thanks
Guennadi
---
Guennadi Liakhovetski
