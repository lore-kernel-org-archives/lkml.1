Return-Path: <linux-kernel-owner+w=401wt.eu-S932706AbYD3UUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbYD3UUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbYD3UU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:20:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33350 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbYD3UU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:20:27 -0400
Date: Wed, 30 Apr 2008 22:20:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch, -git] input: CONFIG_INPUT_APANEL build fix
Message-ID: <20080430202013.GB14164@elte.hu>
References: <20080430185345.GA27224@elte.hu> <20080430150021.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430150021.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> On Wed, Apr 30, 2008 at 08:54:16PM +0200, Ingo Molnar wrote:
> > 
> > x86.git testing found this build failure in upstream -git:
> > 
> >  drivers/built-in.o: In function `apanel_detach_client':
> >  apanel.c:(.text+0x3027af): undefined reference to `led_classdev_unregister'
> >  drivers/built-in.o: In function `apanel_probe':
> >  apanel.c:(.text+0x302ac9): undefined reference to `led_classdev_register'
> > 
> > with this config:
> > 
> >  http://redhat.com/~mingo/misc/config-Wed_Apr_30_20_22_20_CEST_2008.bad
> > 
> > this driver has a missing CONFIG_NEW_LEDS dependency.
> 
> Thank you Ingo. Isn't this a Kconfig issue though? I know that Roman 
> is not willing to fix SELECT to evaluate the whole dependency chain, 
> but in this case it is "depens on" that does not evaluate properly...

yes and no. It can be fixed in Kconfig but i'm not going to flame yet 
another person about long-existing unfixed infrastructure bugs ;-)

The current (many years old) rule is to fix things up as much as we can 
and never expose build errors, because 1) randconfig testing is way too 
useful and because 2) users can stumble across that .config combination 
as well and get rightfully grumpy at us about breaking their build. Most 
of the thousands of drivers are fine - it's those with more complex 
Kconfig dependencies that have trouble.

	Ingo
