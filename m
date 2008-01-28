Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbYA1Svo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbYA1Svo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYA1Sve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:51:34 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56444 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752476AbYA1Svd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:51:33 -0500
Date: Mon, 28 Jan 2008 19:51:14 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: michael <trimarchi@gandalf.sssup.it>, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: at91sam9260 wakeup on serial port
Message-ID: <20080128195114.33d7616d@dhcp-252-066.norway.atmel.com>
In-Reply-To: <200801281021.57317.david-b@pacbell.net>
References: <479DB934.6090806@gandalf.sssup.it>
	<20080128145615.1d756025@dhcp-252-066.norway.atmel.com>
	<200801281021.57317.david-b@pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 10:21:57 -0800
David Brownell <david-b@pacbell.net> wrote:

> What will AVR32 (AP7) need to do, when it supports system sleep states?

Not sure. The PIOs seem to require a clock in order to detect a pin
change, so I don't think we can enter very deep sleep states if we want
to be woken up by the USART.

But I suppose we can still disable the HSB (system) bus, all the
peripherals we don't care about, switch the remaining ones over to an
oscillator and keep that oscillator running. In order to be able to
actually respond to something happening on the serial line, we need to
keep a relatively-high-speed oscillator or PLL running anyway (32 kHz
won't do.)

There's a separate WAKE_N pin that is completely asynchronous, so with
some external logic, we can probably wake up the CPU all the way from
Static mode if a given input state is present. But that's definitely
"board specific" territory, and starting the oscillators take a _long_
time on the AP7000 (especially the 32 kHz, but then again, it barely
consumes any power, so we might as well keep it running and keep the
RTC going as well.)

So on AP7000, I think we'll just need to keep clocking the USART and
let it generate the interrupt that wakes up the rest of the system.
With the rest of the system effectively stopped, I don't think this is
very expensive power-wise, but it remains to be seen.

Haavard
