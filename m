Return-Path: <linux-kernel-owner+w=401wt.eu-S933936AbYD3VAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936AbYD3VAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933528AbYD3VAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:00:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:46518 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933522AbYD3VAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:00:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=k6ixsa/k6949ZT4A+kCkk5LUix3qLe+NIQMkNnsjXG+CM/PJ+qIvDeMjkcu2L14CXQ6epDp5ihPNaiY/IC8s33CaUkR73qxPa+5rsu2R9kKZdX6iCJJ4P7OPGy6GigocPgmAq0bvfbwAHyKzi+uJ5v5r3MPJ1f33rZnlsNaBSys=
Date: Wed, 30 Apr 2008 17:00:23 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Jan Engelhardt <jengelh@gmx.de>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [patch, -git] input: CONFIG_INPUT_APANEL build fix
Message-ID: <20080430163924.ZZRA012@mailhub.coreip.homeip.net>
References: <20080430185345.GA27224@elte.hu> <20080430150021.ZZRA012@mailhub.coreip.homeip.net> <20080430202013.GB14164@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430202013.GB14164@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 10:20:13PM +0200, Ingo Molnar wrote:
> 
> * Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Wed, Apr 30, 2008 at 08:54:16PM +0200, Ingo Molnar wrote:
> > > 
> > > x86.git testing found this build failure in upstream -git:
> > > 
> > >  drivers/built-in.o: In function `apanel_detach_client':
> > >  apanel.c:(.text+0x3027af): undefined reference to `led_classdev_unregister'
> > >  drivers/built-in.o: In function `apanel_probe':
> > >  apanel.c:(.text+0x302ac9): undefined reference to `led_classdev_register'
> > > 
> > > with this config:
> > > 
> > >  http://redhat.com/~mingo/misc/config-Wed_Apr_30_20_22_20_CEST_2008.bad
> > > 
> > > this driver has a missing CONFIG_NEW_LEDS dependency.
> > 
> > Thank you Ingo. Isn't this a Kconfig issue though? I know that Roman 
> > is not willing to fix SELECT to evaluate the whole dependency chain, 
> > but in this case it is "depens on" that does not evaluate properly...
> 
> yes and no. It can be fixed in Kconfig but i'm not going to flame yet 
> another person about long-existing unfixed infrastructure bugs ;-)
> 
> The current (many years old) rule is to fix things up as much as we can 
> and never expose build errors, because 1) randconfig testing is way too 
> useful and because 2) users can stumble across that .config combination 
> as well and get rightfully grumpy at us about breaking their build. Most 
> of the thousands of drivers are fine - it's those with more complex 
> Kconfig dependencies that have trouble.
> 

I thought the many years old rule for Linux kernel is to fix the
issues properly and not turn kernel into patchwork of crappy code.
If we want to fix the randconfi issue I'd rather revert commit
66242f7ec531953fbc2f4040c5ffe1f1ffe6c5c9 for now (they only thing it
did was beautify menuconfig look) and wait for Kconfig to be fixed.
It is not driver's task to track through all dependencies.

-- 
Dmitry
