Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZFBUd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZFBUd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZFBUdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:33:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751302AbZFBUdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:33:20 -0400
Date: Tue, 2 Jun 2009 13:33:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tobias_Mueller@twam.info
Cc: jordan@cosmicpenguin.net, dilinger@collabora.co.uk, david-b@pacbell.net,
       gardner.ben@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 001/001] gpio: AMD CS5535/CS5536 GPIO driver
Message-Id: <20090602133312.68158cd5.akpm@linux-foundation.org>
In-Reply-To: <17be05570906020114k7f2a3096h48335d509951cf90@mail.gmail.com>
References: <17be05570905230453i591eb83bnb359f6365c109718@mail.gmail.com>
	<20090526151621.a7446c60.akpm@linux-foundation.org>
	<17be05570905301105h395689ja33afa96e7751381@mail.gmail.com>
	<20090601165457.a1cc1025.akpm@linux-foundation.org>
	<20090601200821.62b04e43@mycelium.queued.net>
	<4A24965C.2020901@cosmicpenguin.net>
	<17be05570906020114k7f2a3096h48335d509951cf90@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jun 2009 10:14:45 +0200
Tobias M__ller <Tobias_Mueller@twam.info> wrote:

> 2009/6/2 Jordan Crouse <jordan@cosmicpenguin.net>:
> > Andres Salomon wrote:
> >> As far as Tobias's driver, one major difference between our drivers is
> >> that mine doesn't grab the entire PCI device.  This is because other
> >> drivers (ie, the MFGPT driver) will want to share the PCI device.
> >
> > Also SMBUS. In fact, they *must* share the PCI device if they all want to
> > play well together, so that alone would probably push us toward Andre's
> > patch, once it gets clean.
> 
> I had SMBUS and my driver tested in parallel and there I didn't found any
> problems. But I would be fine if we would use Andre's patch. I haven't know
> about, so that's why I tried my own. :)
> 
> I see some other problem's on Andre's patch:
> - He allows the use of PIN 23 which is reserved
> - No special handling is done for 28, which is a GPIO, but
>   serves as Power Button as well
> - OUT_AUX1/OUT_AUX2 should be disabled by default
>   if pin is configured as in output
> - IN_AUX should be disabled by default is pin is
>   configured as in input
> 
> And, if I request a GPIO by userspace via sysfs, on my system it's an
> input pin by default. So my driver initializes a GPIO as an input by default.
> But I don't know if this is default or system specific. I didn't found anything
> about this in the gpio docs.
> 
> So maybe we should decide whether we take Andre's or my approach
> and then adjust it.
> 

I think I'll drop gpio-amd-cs5535-cs5536-gpio-driver.patch while you
guys sort all this out, please.

