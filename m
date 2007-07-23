Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXGWL0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXGWL0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 07:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758684AbXGWL0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 07:26:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38582 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbXGWL0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 07:26:00 -0400
Date: Mon, 23 Jul 2007 12:25:57 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, acpi4asus-u@pimp.vs19.net,
       Gabriel C <nix.or.die@googlemail.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       Corentin Chary <corentincj@iksaif.net>
Subject: Re: [1/2] 2.6.23-rc1: known regressions
Message-ID: <20070723112557.GG21668@ftp.linux.org.uk>
References: <46A47932.8000709@googlemail.com> <Pine.LNX.4.58.0707230404290.5535@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0707230404290.5535@shell2.speakeasy.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 04:17:05AM -0700, Trent Piepho wrote:
 
> Here's a trivial patch for this one.
> ------------------------------------------------------------------------
> asus-laptop: Sync with changes to led class
> 
> Driver was broken by commit f8a7c6fe14f556ca8eeddce258cb21392d0c3a2f
> 	leds: Convert from struct class_device to struct device
> 
> 	Convert the LEDs class from struct class_device to struct device
> 	since class_device is scheduled for removal.
> 
> Use (struct led_classdev).dev instead of (struct led_classdev).class_dev

It doesn't fix the real bug in there - if you look carefully at the code,
you'll see that we don't get to these checks if allocation fails halfway
through (and we leak in that case) *and* these checks are not needed at
all if failure happens elsewhere.
