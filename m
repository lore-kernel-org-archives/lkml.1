Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbYFBXOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbYFBXOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbYFBXOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:14:04 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:57741
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbYFBXOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:14:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah8BAFsbREh8qN9Z/2dsb2JhbAAIrxM
X-IronPort-AV: E=Sophos;i="4.27,579,1204470000"; 
   d="scan'208";a="272161349"
Subject: Re: [RFC] generic GPIO parameter API
From: Ben Nizette <bn@niasdigital.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806021949210.30390@axis700.grange>
References: <Pine.LNX.4.64.0806021841500.30390@axis700.grange>
	 <Pine.LNX.4.64.0806021949210.30390@axis700.grange>
Content-Type: text/plain
Organization: Nias Digital
Date: Tue, 03 Jun 2008 09:13:57 +1000
Message-Id: <1212448437.5446.21.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-06-02 at 19:54 +0200, Guennadi Liakhovetski wrote:
> On Mon, 2 Jun 2008, Guennadi Liakhovetski wrote:
> > int gpio_register_parameter(struct gpio_chip *chip, struct gpio_parameter 
> > 				*param);
> > struct gpio_parameter *gpio_find_parameter(struct gpio_chip *chip, char 
> > 						*name);
> 
> Actually, I think, it would be even better to just add two fields
> 
> 	struct gpio_parameter	*param;
> 	int			param_n;
> 
> to struct gpio_chip.
> 

I like the idea in general.  The biggest worry I have is trying to find
the parameter for you to fiddle with.  The driver which is going to want
to set the parameters is going to have the gpio number, not the
gpio_chip.  Also, the fact that the parameters are uniquely identified
by strings is a bit awkward.  I can see people registering the same kind
of parameter for different chips like "pullup", "Pullup", "pu" etc
making the driver's task even harder.

So, I reckon if we're to do this we should stick with the current style
of gpio calls for the outside interface, maybe something more like

int gpio_set_param(int gpio, int param, int val);
int gpio_get_param(int gpio, int param);

with the different parameters defined as an enum in some gpio.h
somewhere.  Where to keep the gpio_parameters and how to search/find
them should be up to the implementation (though the gpiolib
implementation would probably look quite like what you've got above).

Note you'll probably want a char *name in there somewhere for the sysfs
interface, but I don't think it should be the primary mechanism for
identification.

Anyway, that's my $0.02  :-)

	--Ben.


