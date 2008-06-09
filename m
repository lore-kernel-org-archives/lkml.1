Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbYFIQXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbYFIQXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 12:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYFIQXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 12:23:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:57037 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752577AbYFIQXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 12:23:30 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18QfNQA3xQQCAhg/bzGWIRxEkpKxA/k+MsvRu2ENV
	UWyuU8SWlsVAW2
Date: Mon, 9 Jun 2008 18:23:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] generic GPIO parameter API
In-Reply-To: <200806052229.37143.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0806091109120.21876@axis700.grange>
References: <Pine.LNX.4.64.0806021841500.30390@axis700.grange>
 <200806052229.37143.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008, David Brownell wrote:

> On Monday 02 June 2008, Guennadi Liakhovetski wrote:
> > Hi,
> > 
> > as far as I understand, the current GPIO API only presents very basic GPIO 
> > functionality: direction and level reading and writing. Whereas many GPIO 
> > controllers have many further configurable parameters: pull-ups and 
> > pull-downs, drive strength, slew rate, etc.
> 
> Not at all how I'd describe it.  Those omitted mechanisms are part
> of pin configuration, in the same way as function multiplexing is.
> (That is, assigning a given pin for use as a GPIO, vs hooking it up
> to an I2C, MMC, SPI, LCD, I2S, or memory controller.)

Yes, on the one hand you're right, this belongs to pin-configuration. But, 
otoh, will anyone ever want to change these parameters on non-generic 
pins? And should this be allowed? Whereas for GPIOs it clearly makes a 
sense - on a test-board you have a header with free-hanging GPIOs. How do 
you want to configure them? This depends on what the user connects to them 
and you don't necessarily want to modify your kernel to reconfigure them.

As for various difficulties - they should be solvable, I think. For 
example, for GPIO pins, that can only be configured in groups - you just 
first verify that the other GPIOs in this group are either free or 
configured compatibly, or you fail. Of course these functions are 
hardware-specific, so we let every specific driver handle them.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
