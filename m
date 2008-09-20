Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbYITRHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbYITRHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 13:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbYITRHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 13:07:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49138 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750903AbYITRHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 13:07:41 -0400
Date: Sat, 20 Sep 2008 18:01:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Felipe Balbi <felipe.balbi@nokia.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
Subject: Re: [PATCH 3/5] watchdog: cleanup a bit omap_wdt.c
Message-ID: <20080920180110.18f6205b@lxorguk.ukuu.org.uk>
In-Reply-To: <200809200832.15440.david-b@pacbell.net>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com>
	<200809191741.44986.david-b@pacbell.net>
	<20080920081326.GB11114@flint.arm.linux.org.uk>
	<200809200832.15440.david-b@pacbell.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One could argue that this idiom is ugly ... and fix it by having
> misc_open() in drivers/char/misc.c initialize i_private before
> delegating to the miscdevice->fops->open().  Even just setting
> it to the miscdevice pointer would suffice with this driver;
> container_of(i_private, struct omap_wdt_dev, omap_wdt_miscdev)
> would then return what get_drvdata() returns, sans global.
> 
> But that wouldn't be just cleaning up this watchdog.

There are a couple of takes are reworking all the watchdog core code to
get rid of that stuff - so its probably not worth worrying about as
pretty soon I'd hope watchdogs are mostly using one of the new interfaces
and taking struct watchdog for ops (and in the case of the watchdog core
code I proposed don't even usually need open methods at all)

Alan
--
#include <stdsig.h>
