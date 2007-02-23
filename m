Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbXBWUVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbXBWUVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932643AbXBWUVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:21:25 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2545 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbXBWUVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:21:24 -0500
Date: Fri, 23 Feb 2007 20:21:16 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Rob Prowel <prowel@kuchera.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: questions about 8250 uart support for adhoc boards
Message-ID: <20070223202116.GA3000@flint.arm.linux.org.uk>
Mail-Followup-To: Rob Prowel <prowel@kuchera.com>,
	linux-kernel@vger.kernel.org
References: <45DF1EEC.4040602@kuchera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DF1EEC.4040602@kuchera.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23, 2007 at 12:05:48PM -0500, Rob Prowel wrote:
> At least now, with fourport compiled into the kernel,

You don't even need to do that.  Just configure SERIAL_8250_NR_UARTS
and SERIAL_8250_RUNTIME_UARTS appropriately for your system.  There's
absolutely no need to build any of the additional modules.

> I can use 
> setserial to see the uarts and correctly identify them...but the shared 
> interrupt vector doesn't seem to work.  I haven't even attempted yet to 
> try stty or echoing data our to an o-scope.

I dropped support for the shared interrupt vector - having multiple
different ISRs depending on the way the wind was blowing was extremely
complex, and in this day and age of GHz CPUs rather silly.

The serial driver can still share interrupts just fine.  Just omit
configuring the multiport address and masks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
