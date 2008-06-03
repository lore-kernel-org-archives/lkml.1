Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYFCHdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYFCHdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 03:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbYFCHcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 03:32:54 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:35377
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbYFCHcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 03:32:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnsBAJuPREh8qN9Z/2dsb2JhbAAIrxc
X-IronPort-AV: E=Sophos;i="4.27,582,1204470000"; 
   d="scan'208";a="338123069"
Subject: Re: [RFC] generic GPIO parameter API
From: Ben Nizette <bn@niasdigital.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806030834440.19323@axis700.grange>
References: <Pine.LNX.4.64.0806021841500.30390@axis700.grange>
	 <Pine.LNX.4.64.0806021949210.30390@axis700.grange>
	 <1212448437.5446.21.camel@moss.renham>
	 <Pine.LNX.4.64.0806030834440.19323@axis700.grange>
Content-Type: text/plain
Organization: Nias Digital
Date: Tue, 03 Jun 2008 17:32:49 +1000
Message-Id: <1212478370.5446.58.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-06-03 at 08:42 +0200, Guennadi Liakhovetski wrote:
> On Tue, 3 Jun 2008, Ben Nizette wrote:
> 
> > On Mon, 2008-06-02 at 19:54 +0200, Guennadi Liakhovetski wrote:
> > > On Mon, 2 Jun 2008, Guennadi Liakhovetski wrote:
> > > > int gpio_register_parameter(struct gpio_chip *chip, struct gpio_parameter 
> > > > 				*param);
> > > > struct gpio_parameter *gpio_find_parameter(struct gpio_chip *chip, char 
> > > > 						*name);
> > > 
> > > Actually, I think, it would be even better to just add two fields
> > > 
> > > 	struct gpio_parameter	*param;
> > > 	int			param_n;
> > > 
> > > to struct gpio_chip.
> > 
> > I like the idea in general.  The biggest worry I have is trying to find
> > the parameter for you to fiddle with.
> 
> Oh, this doesn't worry me - I have a driver here for a controller with 
> switchable pullups.

You're talking about a gpio chip driver?  How does the end user go about
turning the pullups on and off?  How does the end user know that that's
what they want to do?

> 
> > The driver which is going to want
> > to set the parameters is going to have the gpio number, not the
> > gpio_chip.
> 
> Sure, right.
> 
> > Also, the fact that the parameters are uniquely identified
> > by strings is a bit awkward.  I can see people registering the same kind
> > of parameter for different chips like "pullup", "Pullup", "pu" etc
> > making the driver's task even harder.
> 
> Well, I thought about that too, but then I decided there would have to be 
> too many of those macros. But we can try it that way too.
> 
> > So, I reckon if we're to do this we should stick with the current style
> > of gpio calls for the outside interface, maybe something more like
> > 
> > int gpio_set_param(int gpio, int param, int val);
> > int gpio_get_param(int gpio, int param);
> 
> For the get I would rather pass it "int *val" because we don't know which 
> values are valid and which are an error code for this specific parameter.

Well everything else in the world just uses negative returns for errors,
I'm sure that any parameter get/set routines can conform with that, no?
This way is more consistent with, gpio_{get,set}_val etc not to mention
the rest of the kernel.

	--Ben.


