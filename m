Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbYA3S4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbYA3S4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 13:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYA3S4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 13:56:16 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:42147 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753719AbYA3S4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 13:56:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CHoVp1c3q4zsIS7cOp87ZLWijcZvnaPVQDJZjFohC0nOtjfqJfTSqijfRgyYNa2pvh5Fg3fO1oyVxzzKFZ+YsZ83KPR1Dkof8GkDQaVmwoCFWszkynvJb2+xf0Y6ssFBdKB4A3CEnc+8L5Zomxm1IxWqrDbwFi6ebyLCXeapSog=  ;
X-YMail-OSG: wYHzFOEVM1mJh1q_MaP42mqF9VR2nfD0OCVZcNuK_RSHBY_7
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: at91sam9260 wakeup on serial port
Date: Wed, 30 Jan 2008 10:56:12 -0800
User-Agent: KMail/1.9.6
Cc: michael <trimarchi@gandalf.sssup.it>, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>
References: <479DB934.6090806@gandalf.sssup.it> <200801291944.53591.david-b@pacbell.net> <20080130124754.70f5b218@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080130124754.70f5b218@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801301056.13186.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008, Haavard Skinnemoen wrote:
> On Tue, 29 Jan 2008 19:44:53 -0800
> David Brownell <david-b@pacbell.net> wrote:
> 
> > On Monday 28 January 2008, Haavard Skinnemoen wrote:
> > > 
> > > > What will AVR32 (AP7) need to do, when it supports system sleep states?
> > > 
> > > Not sure. The PIOs seem to require a clock in order to detect a pin
> > > change, so I don't think we can enter very deep sleep states if we want
> > > to be woken up by the USART.
> > 
> > Right; if no DMA is pending, then the HSB matrix clock can be idled, DRAM put
> > into self-refresh, and most peripherals can issue wakeups ... AP7 "Frozen"
> > state, very analagous to AT91 "standby" on Linux.  UARTs and GPIOs can wake.
> 
> Yeah, although the nasty thing about UARTs is that you never know when
> DMA really is idle.

If the UART isn't open, its DMA should be inactive.  :)

Also, after suspend() it should normally be inactive.
(That latter is somewhat platform-specific.)


> > The closest analogue to the AT91 support would map /sys/power/state:
> > 
> > 	standby --> to AP7 "Frozen"
> > 	mem --> to AP7 "Stop"
> 
> Yes, that looks reasonable. We can also do something in between by
> stopping most peripherals and busses. For example, keep one peripheral
> bus and one USART running from OSC0 with everything else stopped.

Wouldn't that just be a variant of "Frozen"?  The clock API should
be fully capable of disabling unused clocks, PLLs, and oscillators
when the platform supports it.  It's common for lots of clocks to be
disable even in non-suspended system states.


> I think we need some chip- or family-specific sleep code that knows how
> to enter a given power state. But the specifics about how to wake the
> system up must necessarily be board-specific (or even run-time
> configurable.)

The sysfs wakeup attributes are the runtiime config mechanism for all
events associated with a single device.

- Dave
