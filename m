Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbYFCWC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbYFCWC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYFCWCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:02:49 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:40051
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753274AbYFCWCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:02:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjYBAK9cRUh8qNtz/2dsb2JhbAAIsSo
X-IronPort-AV: E=Sophos;i="4.27,585,1204470000"; 
   d="scan'208";a="230520991"
Subject: Re: [RFC] generic GPIO parameter API
From: Ben Nizette <bn@niasdigital.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806031023530.20715@axis700.grange>
References: <Pine.LNX.4.64.0806021841500.30390@axis700.grange>
	 <Pine.LNX.4.64.0806021949210.30390@axis700.grange>
	 <1212448437.5446.21.camel@moss.renham>
	 <Pine.LNX.4.64.0806030834440.19323@axis700.grange>
	 <1212478370.5446.58.camel@moss.renham>
	 <Pine.LNX.4.64.0806031023530.20715@axis700.grange>
Content-Type: text/plain
Organization: Nias Digital
Date: Wed, 04 Jun 2008 08:02:44 +1000
Message-Id: <1212530564.5446.70.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 10:29 +0200, Guennadi Liakhovetski wrote:
> On Tue, 3 Jun 2008, Ben Nizette wrote:
> > On Tue, 2008-06-03 at 08:42 +0200, Guennadi Liakhovetski wrote:
> > > On Tue, 3 Jun 2008, Ben Nizette wrote:
> > > > 
> > > > I like the idea in general.  The biggest worry I have is trying to find
> > > > the parameter for you to fiddle with.
> > > 
> > > Oh, this doesn't worry me - I have a driver here for a controller with 
> > > switchable pullups.
> > 
> > You're talking about a gpio chip driver?
> 
> Yes.
> 
> > How does the end user go about turning the pullups on and off?
> 
> Either using the in-kernel API 

I guess it's this bit I was wondering about more precisely.  _Which_ in
kernel API?  The gpio_find_parameter thing you had above?  If so, how
are you discovering the gpio_chip?  (Note that if you are indeed
discovering the gpio_chip, this isn't portable. gpio chips shouldn't be
known outside of gpiolib, gpiolib's optional and separate from the gpio
framework).

> or over sysfs, if it's a user-space app.
> 
> > How does the end user know that that's what they want to do?
> 
> That's their problem, isn't it? We are talking about an embedded system, 
> where applications are written with datasheets and schematics in hand. So, 
> you will know whether or not you want to switch pullups.
> 
> > > > So, I reckon if we're to do this we should stick with the current style
> > > > of gpio calls for the outside interface, maybe something more like
> > > > 
> > > > int gpio_set_param(int gpio, int param, int val);
> > > > int gpio_get_param(int gpio, int param);
> > > 
> > > For the get I would rather pass it "int *val" because we don't know which 
> > > values are valid and which are an error code for this specific parameter.
> > 
> > Well everything else in the world just uses negative returns for errors,
> > I'm sure that any parameter get/set routines can conform with that, no?
> > This way is more consistent with, gpio_{get,set}_val etc not to mention
> > the rest of the kernel.
> 
> gpio_get_val() is easy - you can only get a 0 or a 1 in success case 
> there. Whereas with an arbitrary gpio parameter you don't know what valid 
> values it can return. Ok, practically, I can hardly imagine a GPIO 
> parameter with 2^32 valid values, but who knows...
> 

Hmm, in the absence of a solid use case I'm a fan of sticking with
tradition.  I can just see people forgetting to put an &foo in get but
just foo in set (I know I would).  But so long as it's solidly
documented then I guess I wouldn't be able to complain :-)

Just so long as we agree that there should be this kind of interface in
the gpio framework, quite apart from how it's implemented inside
gpiolib.

Cheers,
	--Ben.

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
