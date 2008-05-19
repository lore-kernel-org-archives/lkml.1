Return-Path: <linux-kernel-owner+w=401wt.eu-S1762394AbYESPtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762394AbYESPtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760817AbYESPr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:47:59 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:53384 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761991AbYESPrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fpcv6MkIoN+cGkiZKFfBogm3h8CaTtBQ9qPJ2YMbVIQkS+bw9NUOBkBakGv+ZEqaXm54Z0D2QiFEr/PtGm8CEN4XyByL4gI56yHKMpnA9ItyJU8GrpQO2hLIfO75fJGIngYLxwaTXqW60PpG04BzSw5fXFGTR7GyhfzzhjNqdD0=
Date: Mon, 19 May 2008 11:47:08 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>,
       Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       linux-sh <linux-sh@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: add support for SEGA Dreamcast controller as
	joystick
Message-ID: <20080519114515.ZZRA012@mailhub.coreip.homeip.net>
References: <1211138322.6354.5.camel@localhost.localdomain> <20080519010928.GA8797@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519010928.GA8797@linux-sh.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 10:09:28AM +0900, Paul Mundt wrote:
> On Sun, May 18, 2008 at 08:18:42PM +0100, Adrian McMenamin wrote:
> > +MODULE_AUTHOR("YAEGASHI Takeshi <t@keshi.org>");
> > +MODULE_DESCRIPTION("SEGA Dreamcast controller driver");
> > +MODULE_LICENSE("GPL");
> > +
> MODULE_AUTHOR() is a bit ambiguous here. As this is user-visible by way
> of modinfo, it really doesn't make any sense to list someone who has
> nothing to do with the driver in its present form here. Especially since
> it's been 7 years since their last contribution or even basic list
> activity, I think it's safe to say that you are going to be the only one
> that users wish to contact about this.
> 
> In this case, the copyright should suffice. You may wish to add a bit of
> a note there indicating where the driver came from, but there's not much
> point in going beyond that.
> 
> Note that if you aren't comfortable with being in MODULE_AUTHOR(), you
> can also make this more generic and attribute it to the LinuxDC or
> Linux/SH teams respectively, as that's a bit more true to form as far as
> all copyright holders are concerned, and gives people a pointer to a list
> to go to with problems.
> 
> It's probably more reasonable to treat MODULE_AUTHOR() as
> MODULE_MAINTAINER() rather than the literal original author, as the
> latter is of zero interest or relevance to users that are looking at
> this information on the other side of the fence.
> 
> > +struct dc_pad {
> > +	struct input_dev *dev;
> > +	struct maple_device *mdev;
> > +};
> > +
> This is pretty ugly, you should really fix up your private device
> pointer layering to get around having to use this structure at all.
> 
> > +static struct maple_driver dc_pad_driver = {
> > +	.function =	MAPLE_FUNC_CONTROLLER,
> > +	.connect =	dc_pad_connect,
> > +	.disconnect =	dc_pad_disconnect,
> > +	.drv = {
> > +		.name = "Dreamcast_controller",
> 
> Is there some particular reason why the driver name can't reflect the
> module name? There's no reason to have such sickeningly verbose driver
> names.
> 
> > +		.probe = probe_maple_controller,
> > +		.remove = remove_maple_controller,
> > +	},
> > +};
> > +
> These should be __devinit/__devexit at least, with the latter being
> __devexit_p() wrapped..
> 

In addition to Pauls comments - is there a reson why maple drivers
need to brovide both connect/disconnect and probe/remove functions?
Normally the layer has generic probe/remove defined on bus level and
individual drivers provide connect/disconnect (or their equivalent)
which is called from the bus's probe/remove.

-- 
Dmitry
