Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbZBXSaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbZBXSaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 13:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbZBXSaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 13:30:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57013 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbZBXSaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 13:30:07 -0500
Date: Tue, 24 Feb 2009 19:29:42 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: greg@kroah.com, s.hauer@pengutronix.de,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] platform_device: add init() exit() callbacks
Message-ID: <20090224182942.GA12372@pengutronix.de>
References: <20090224155731.28880.77132.stgit@Programuotojas>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090224155731.28880.77132.stgit@Programuotojas>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 24, 2009 at 05:57:31PM +0200, Paulius Zaleckas wrote:
> Some(many?) platform drivers needs board specific callbacks
> to initialize/deinitialize(request/release) GPIO pins,
> generic bus initialization, board specific configuration
> and etc.
Up to now I used clk_enable + clk_disable for this purpose in my code.
Isn't that a nice alternative?  One pro of it is that you don't need to
extend struct platform_device.

> Currently this is done by passing pointers to such functions
> through platform_data. It is common for such drivers to have
> init()/exit() functions declared in platform_data structure.
> 
> Using platform_data for this purpose has some drawbacks:
> 1. You have to write checks for platform_data and functions
>    pointers existance and ensure correct error path in every
>    platform driver.
I don't consider this a real drawback.  Kernel code is full of these
idioms.

> 2. Since part of the code is in driver and another in board
>    specific code, usually you have to push this code through
>    different maintainers. This also adds some not necessary work
>    to ensure that adding changes to the board code, while changes
>    to the driver are still pending, will not break this board
>    compilation.
I don't get this rationale.  Do you mean "As now all platform drivers
have init() and exit() you don't need to break compilation when
introducing them to the driver and the platform code."  This counts
hardly as an argument.

> 3. In my case, I am adding support for new ARM CPU, this needs
>    to be done for some already existing drivers like serial 8250,
>    mtd physmap and etc. this becomes pain in the ...
As far as I can see the 8250 driver doesn't currently support callbacks.
What exactly do you mean here?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
