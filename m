Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYFCI3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYFCI3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 04:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYFCI26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 04:28:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:50551 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751163AbYFCI25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 04:28:57 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+KPYpIktiKTUgEKiRyLxQPqcGhNUywCC7lEYXwqF
	O/+ZT/SGyP69Ix
Date: Tue, 3 Jun 2008 10:29:07 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ben Nizette <bn@niasdigital.com>
cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] generic GPIO parameter API
In-Reply-To: <1212478370.5446.58.camel@moss.renham>
Message-ID: <Pine.LNX.4.64.0806031023530.20715@axis700.grange>
References: <Pine.LNX.4.64.0806021841500.30390@axis700.grange> 
 <Pine.LNX.4.64.0806021949210.30390@axis700.grange>  <1212448437.5446.21.camel@moss.renham>
  <Pine.LNX.4.64.0806030834440.19323@axis700.grange> <1212478370.5446.58.camel@moss.renham>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008, Ben Nizette wrote:

> 
> On Tue, 2008-06-03 at 08:42 +0200, Guennadi Liakhovetski wrote:
> > On Tue, 3 Jun 2008, Ben Nizette wrote:
> > 
> > > On Mon, 2008-06-02 at 19:54 +0200, Guennadi Liakhovetski wrote:
> > > > On Mon, 2 Jun 2008, Guennadi Liakhovetski wrote:
> > > > > int gpio_register_parameter(struct gpio_chip *chip, struct gpio_parameter 
> > > > > 				*param);
> > > > > struct gpio_parameter *gpio_find_parameter(struct gpio_chip *chip, char 
> > > > > 						*name);
> > > > 
> > > > Actually, I think, it would be even better to just add two fields
> > > > 
> > > > 	struct gpio_parameter	*param;
> > > > 	int			param_n;
> > > > 
> > > > to struct gpio_chip.
> > > 
> > > I like the idea in general.  The biggest worry I have is trying to find
> > > the parameter for you to fiddle with.
> > 
> > Oh, this doesn't worry me - I have a driver here for a controller with 
> > switchable pullups.
> 
> You're talking about a gpio chip driver?

Yes.

> How does the end user go about turning the pullups on and off?

Either using the in-kernel API or over sysfs, if it's a user-space app.

> How does the end user know that that's what they want to do?

That's their problem, isn't it? We are talking about an embedded system, 
where applications are written with datasheets and schematics in hand. So, 
you will know whether or not you want to switch pullups.

> > > So, I reckon if we're to do this we should stick with the current style
> > > of gpio calls for the outside interface, maybe something more like
> > > 
> > > int gpio_set_param(int gpio, int param, int val);
> > > int gpio_get_param(int gpio, int param);
> > 
> > For the get I would rather pass it "int *val" because we don't know which 
> > values are valid and which are an error code for this specific parameter.
> 
> Well everything else in the world just uses negative returns for errors,
> I'm sure that any parameter get/set routines can conform with that, no?
> This way is more consistent with, gpio_{get,set}_val etc not to mention
> the rest of the kernel.

gpio_get_val() is easy - you can only get a 0 or a 1 in success case 
there. Whereas with an arbitrary gpio parameter you don't know what valid 
values it can return. Ok, practically, I can hardly imagine a GPIO 
parameter with 2^32 valid values, but who knows...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
