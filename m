Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbYKQXFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbYKQXFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 18:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYKQXF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 18:05:28 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4002 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbYKQXF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 18:05:27 -0500
Date: Mon, 17 Nov 2008 23:05:24 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Fix locking for WM8350
Message-ID: <20081117230522.GA29916@sirena.org.uk>
References: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1226588269-17642-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081115173110.GD1523@ucw.cz> <20081115175050.GB12466@opensource.wolfsonmicro.com> <20081115185119.GA19900@elf.ucw.cz> <20081115191414.GA12907@opensource.wolfsonmicro.com> <1226935995.17109.22.camel@ted>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226935995.17109.22.camel@ted>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 03:33:15PM +0000, Richard Purdie wrote:

> I've not looked in detail at the code but it looks like a maximum of a
> 32 bit value where you don't actually care which write succeeds as long
> as it takes one of the values written? I don't see why that particular

Pretty much (it's an enum led_brightness) - it's just a standard LED
that can't be written without taking interrupts along the lines of the
GPIO LED driver.

> variable needs any locking or to be atomic?

I'd certainly be surprised if it were an issue in any practical system.
