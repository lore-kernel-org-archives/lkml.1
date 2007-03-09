Return-Path: <linux-kernel-owner+w=401wt.eu-S965805AbXCIUJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965805AbXCIUJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965516AbXCIUJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:09:15 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4307 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767471AbXCIUJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:09:14 -0500
Date: Fri, 9 Mar 2007 20:08:50 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Jean Delvare <khali@linux-fr.org>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070309200850.GA8444@flint.arm.linux.org.uk>
Mail-Followup-To: David Brownell <david-b@pacbell.net>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Jean Delvare <khali@linux-fr.org>, Bryan Wu <bryan.wu@analog.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
References: <200703090945.38880.david-b@pacbell.net> <11734661281633-git-send-email-hskinnemoen@atmel.com> <200703091130.13547.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703091130.13547.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 11:30:12AM -0800, David Brownell wrote:
> On Friday 09 March 2007 10:48 am, Haavard Skinnemoen wrote:
> > This is a very simple bitbanging i2c bus driver utilizing the new
> > arch-neutral GPIO API. Useful for chips that don't have a built-in
> > i2c controller, additional i2c busses, or testing purposes.
> 
> That's the right idea!  But remember that not all GPIOs support
> reading back the actual value on SCL (it's an OUT pin, so lacking
> multidrive capability the values "should" be what you wrote), so
> getscl() support should depend on a flag in platform data.  In
> the same vein, if SCL is an output-only pin, you won't be able
> to change its direction ... but then, I'm not sure why you were
> changing its direction in setscl() rather than just its value.

That's a more correct I2C implementation.  If you read the specs, the
SDA and SCL signals are supposed to be driven by open-collector or
open-drain drivers, such that devices only pull the bus low.  Pull-up
resistors pull the signals high when undriven.

This avoids the possibility of damage caused when one device drives
a signal low and another device tries to drive it high.

Therefore, the correct I2C GPIO implementation is one where you drive
both SDA and SCL low by using a combination of the data direction
register and the output level register, but avoid driving the output
high.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
