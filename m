Return-Path: <linux-kernel-owner+w=401wt.eu-S965457AbYCSVEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965457AbYCSVEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760695AbYCSTyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:54:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:56789 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760686AbYCSTyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:54:18 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18D0/Y0qEoDw14HcnHD4WVoBxGjHEfpkZSt5o83vh
	9qKauQCDgJubt+
Date: Tue, 18 Mar 2008 17:31:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: gpio patches in mmotm
In-Reply-To: <20080318160316.GA31588@digi.com>
Message-ID: <Pine.LNX.4.64.0803181717240.5022@axis700.grange>
References: <20080317173134.GA27282@digi.com> <Pine.LNX.4.64.0803171915020.8640@axis700.grange>
 <20080318160316.GA31588@digi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, do not trim the CC: list. I've also added lkml.

On Tue, 18 Mar 2008, Uwe Kleine-König wrote:

> Guennadi Liakhovetski wrote:
> > On Mon, 17 Mar 2008, Uwe Kleine-König wrote:
> > 
> > > I'm nure sure if I like gpio_is_valid().  When do you think it should be
> > > used?  (i.e. in which situations gpio_request doesn't do the right
> > > thing?)
> > 
> > For example, in situations similar to what I have in mt9m001 and mt9v022 
> > camera drivers. Those cameras can be built with an i2c gpio extender, 
> > which can be used to switch between 8 and 10 bit data bus widths. But that 
> > extender is not always available. So, those drivers request a gpio, and if 
> > it is not available on the system, the gpio_is_valid() test fails.
> I found your patch, but no tree where it applies.  Can you point me to a
> tree where it applies?

These drivers are currently in the v4l-dvb tree 
http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=summary in 
the devel branch.

> Why isn't it enough that gpio_request fails in such a situation?

I'm storing the GPIO number locally, and if the system doesn't have a 
valid GPIO for me, I'm storing an invalid GPIO number. Then at any time if 
the GPIO has to be used, I just verify if gpio_is_valid(), and if not, 
return an error code for this request, but the driver remains otherwise 
functional.

Thanks
Guennadi
---
Guennadi Liakhovetski
