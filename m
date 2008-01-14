Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbYANO7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbYANO7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYANO7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:59:46 -0500
Received: from mail.hevs.ch ([153.109.23.15]:52530 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYANO7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:59:45 -0500
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: Re: [RFC, PATCH, take 2] watchdog on generic gpio
Date: Mon, 14 Jan 2008 15:59:38 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200801141103.23744.marc.pignat@hevs.ch> <200801141401.33783.marc.pignat@hevs.ch> <200801141503.15359.florian.fainelli@telecomint.eu>
In-Reply-To: <200801141503.15359.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801141559.38781.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2008, Florian Fainelli wrote:
> Le lundi 14 janvier 2008, Marc Pignat a écrit :
> > Hi Florian!
> > I understand your wish, but...
> > You told me that your plaform doesn't implement the generic gpio interface
> > (yet?), so this driver can't work for you.
> 
> You understood me wrong, I told you that not all platforms, actually only 
> AVR32 and ARM seem to make use of David Brownell's gpiolib, but the MIPS 
> board I am working with supports the "old" generic GPIO API which required 
> you to define your own wrappers for gpio_set/get_value and such. For both 
> implementations the config symbol is GENERIC_GPIO, which can somehow be 
> confusing.
The gpiolib isn't merged yet and it's purpose it to let use any gpio in the
system independently of how they are connected (directly, or through spi, ...).
So I don't use it!

...
> I use only one gpio bit as well, only the keepalive function should be 
> changed. And even if we need the other ones to be changed, let's assume we 
> can pass the necessary callback to the platform driver, and checking wether 
> they are defined and call them or not is just trivial. This will not bloat 
> the driver.
Okay, so what do you do with this single pin?

...
> Yes, I understand, but having a max823-centric driver does not make it as 
> general as it could be.
Sure. Another solution is to make add a .type in the gpio_wdt struct to choose
which function to use for keepalive -> support for more chips in the driver
itself.

> 
> >
> > Let me know if you want some help implementing your driver!
> 
> It already exists and his merged as mtx1_wdt, I just want to get rid of it if 
> any generic gpio wathchdog driver can fit my needs and others.
I just had a look at it. It has additionnal restrictions like 'It should not
be triggered more often than 1.6 seconds', ..., and works with a timer, it
is really very differrent of what I'm doing...

Can you please tell me what is connected to this gpio?

> 
> As a general comments, Wim did not answer yet, I would like to hear from him.
Me too :)

Regards

Marc
