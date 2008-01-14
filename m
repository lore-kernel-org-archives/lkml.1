Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYANOD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYANOD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbYANODW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:03:22 -0500
Received: from smtp1.int-evry.fr ([157.159.10.44]:33745 "EHLO
	smtp1.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYANODV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:03:21 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Marc Pignat <marc.pignat@hevs.ch>
Subject: Re: [RFC, PATCH, take 2] watchdog on generic gpio
Date: Mon, 14 Jan 2008 15:03:14 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200801141103.23744.marc.pignat@hevs.ch> <200801141206.39858.florian.fainelli@telecomint.eu> <200801141401.33783.marc.pignat@hevs.ch>
In-Reply-To: <200801141401.33783.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801141503.15359.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 14 janvier 2008, Marc Pignat a écrit :
> Hi Florian!
> I understand your wish, but...
> You told me that your plaform doesn't implement the generic gpio interface
> (yet?), so this driver can't work for you.

You understood me wrong, I told you that not all platforms, actually only 
AVR32 and ARM seem to make use of David Brownell's gpiolib, but the MIPS 
board I am working with supports the "old" generic GPIO API which required 
you to define your own wrappers for gpio_set/get_value and such. For both 
implementations the config symbol is GENERIC_GPIO, which can somehow be 
confusing.
>
> This is not the only function to be changed, start, stop and keepalive (and
> probably suspend/resume) should be changed, and when the 'Uniform Watchdog
> Device Driver' will be merged, writing your driver dealing with more gpio
> will be almost trivial.

I use only one gpio bit as well, only the keepalive function should be 
changed. And even if we need the other ones to be changed, let's assume we 
can pass the necessary callback to the platform driver, and checking wether 
they are defined and call them or not is just trivial. This will not bloat 
the driver.

>
> Please make sure to look a the right place, the git tree for the unified
> driver you have given is 17 month old... here is the latest:
> http://git.kernel.org/?p=linux/kernel/git/wim/linux-2.6-watchdog-mm.git;a=s
>ummary
>
> I'm trying to get this work merged because I use it, it works for me and
> I'm almost sure I haven't got the only embedded system using a max823
> connected to a gpio.

Yes, I understand, but having a max823-centric driver does not make it as 
general as it could be.

>
> Let me know if you want some help implementing your driver!

It already exists and his merged as mtx1_wdt, I just want to get rid of it if 
any generic gpio wathchdog driver can fit my needs and others.

As a general comments, Wim did not answer yet, I would like to hear from him.
-- 
Cordialement, Florian Fainelli
------------------------------
