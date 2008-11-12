Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbYKLUAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbYKLUAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYKLUAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:00:10 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2647 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYKLUAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:00:09 -0500
Date: Wed, 12 Nov 2008 20:00:07 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28] mfd: Correct WM8350 I2C return code usage
Message-ID: <20081112200007.GA31451@sirena.org.uk>
References: <1226324477-21022-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081112184956.GA17382@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112184956.GA17382@sortiz.org>
X-Cookie: Be cautious in your daily affairs.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 07:49:57PM +0100, Samuel Ortiz wrote:
> On Mon, Nov 10, 2008 at 01:41:17PM +0000, Mark Brown wrote:

> > The vendor BSP used for the WM8350 development provided an I2C driver
> > which incorrectly returned zero on succesful sends rather than the
> > number of transmitted bytes, an error which was then propagated into the
> > WM8350 I2C accessors.

> Shouldnt we fix the accessors behaviour instead ?
> Currently, that would mean fixing some of the wm8350-core static functions.
> Slightly bigger patch, but that would keep the i2c interface consistent.

I don't really understand what you mean by "keep the i2c interface
consistent" here?  The purpose of this abstraction is to abstract away
the control interface used to communicate with the chip since it
supports both I2C and SPI.

> What do you think ?

That would expose the details of the I2C API and the wire format used to
access the device over I2C to the WM8350 core which would mean the SPI
control code would have to jump through hoops to emulate it.  If the
device only had I2C control it would be better to just remove this
abstraction entirely and use the I2C API directly in the register access
functions.
