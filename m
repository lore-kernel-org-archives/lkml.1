Return-Path: <linux-kernel-owner+w=401wt.eu-S932698AbXBKWtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbXBKWtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932700AbXBKWtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:49:21 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:33391 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698AbXBKWtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:49:20 -0500
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Willy Tarreau <w@1wt.eu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Daniel Barkalow <barkalow@iabervon.org>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
In-Reply-To: <20070211121339.GB4204@srcf.ucam.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <200702101130.44471.rjw@sisk.pl>
	 <Pine.LNX.4.64.0702101231281.20138@iabervon.org>
	 <200702102050.28218.rjw@sisk.pl> <20070211065404.GA943@1wt.eu>
	 <20070211121339.GB4204@srcf.ucam.org>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 09:49:05 +1100
Message-Id: <1171234145.4493.91.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, 2007-02-11 at 12:13 +0000, Matthew Garrett wrote:
> On Sun, Feb 11, 2007 at 07:54:04AM +0100, Willy Tarreau wrote:
> 
> > instead of modifying all drivers to explicitly state that they don't support
> > it, we should start with a test of the NULL pointer for .suspend which should
> > mean exactly the same without modifying the drivers. I find it obvious that
> > a driver which does provide a suspend function will not support it. And if
> > some drivers (eg /dev/null) can support it anyway, it's better to change
> > *those* drivers to explicitly mark them as compatible.
> 
> No, that doesn't work. In the absence of suspend/resume methods, the PCI 
> layer will implement basic PM itself. In some cases, this works. In 
> others, it doesn't. There's no way to automatically determine which is 
> which without modifying the drivers.

I think we have it backwards there. Power management support for a
driver should always start with the driver itself. If there's a generic
routine that can be used for the bus, the driver should explicitly set
the routine to the generic routine.

Regards,

Nigel

