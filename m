Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbYFCGmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbYFCGmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYFCGl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:41:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:41635 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753101AbYFCGl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:41:56 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/Mk7gZubDMezIiCDiNV/4fdEeapvcgxuzjlMIO65
	VrdVW/YaoG/KYj
Date: Tue, 3 Jun 2008 08:42:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ben Nizette <bn@niasdigital.com>
cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] generic GPIO parameter API
In-Reply-To: <1212448437.5446.21.camel@moss.renham>
Message-ID: <Pine.LNX.4.64.0806030834440.19323@axis700.grange>
References: <Pine.LNX.4.64.0806021841500.30390@axis700.grange> 
 <Pine.LNX.4.64.0806021949210.30390@axis700.grange> <1212448437.5446.21.camel@moss.renham>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008, Ben Nizette wrote:

> On Mon, 2008-06-02 at 19:54 +0200, Guennadi Liakhovetski wrote:
> > On Mon, 2 Jun 2008, Guennadi Liakhovetski wrote:
> > > int gpio_register_parameter(struct gpio_chip *chip, struct gpio_parameter 
> > > 				*param);
> > > struct gpio_parameter *gpio_find_parameter(struct gpio_chip *chip, char 
> > > 						*name);
> > 
> > Actually, I think, it would be even better to just add two fields
> > 
> > 	struct gpio_parameter	*param;
> > 	int			param_n;
> > 
> > to struct gpio_chip.
> 
> I like the idea in general.  The biggest worry I have is trying to find
> the parameter for you to fiddle with.

Oh, this doesn't worry me - I have a driver here for a controller with 
switchable pullups.

> The driver which is going to want
> to set the parameters is going to have the gpio number, not the
> gpio_chip.

Sure, right.

> Also, the fact that the parameters are uniquely identified
> by strings is a bit awkward.  I can see people registering the same kind
> of parameter for different chips like "pullup", "Pullup", "pu" etc
> making the driver's task even harder.

Well, I thought about that too, but then I decided there would have to be 
too many of those macros. But we can try it that way too.

> So, I reckon if we're to do this we should stick with the current style
> of gpio calls for the outside interface, maybe something more like
> 
> int gpio_set_param(int gpio, int param, int val);
> int gpio_get_param(int gpio, int param);

For the get I would rather pass it "int *val" because we don't know which 
values are valid and which are an error code for this specific parameter.

> with the different parameters defined as an enum in some gpio.h
> somewhere.  Where to keep the gpio_parameters and how to search/find
> them should be up to the implementation (though the gpiolib
> implementation would probably look quite like what you've got above).
> 
> Note you'll probably want a char *name in there somewhere for the sysfs
> interface, but I don't think it should be the primary mechanism for
> identification.
> 
> Anyway, that's my $0.02  :-)

Thanks for the comments
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
