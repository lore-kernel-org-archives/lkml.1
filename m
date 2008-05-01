Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYEAB3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYEAB3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYEAB3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:29:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47998 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYEAB3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:29:40 -0400
Date: Thu, 1 May 2008 03:29:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Jan Engelhardt <jengelh@gmx.de>,
       Richard Purdie <rpurdie@rpsys.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch, -git] input: CONFIG_INPUT_APANEL build fix
Message-ID: <20080501012922.GB27574@elte.hu>
References: <20080430185345.GA27224@elte.hu> <20080430150021.ZZRA012@mailhub.coreip.homeip.net> <20080430202013.GB14164@elte.hu> <20080430163924.ZZRA012@mailhub.coreip.homeip.net> <20080430212029.GA28813@elte.hu> <20080430222645.GB2629@anvil.corenet.prv> <20080430223828.GA31878@elte.hu> <20080430224701.GC2629@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430224701.GC2629@anvil.corenet.prv>
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

> On Thu, May 01, 2008 at 12:38:29AM +0200, Ingo Molnar wrote:
> > 
> > * Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > 
> > > > i'm not suggesting this is your fault in any way - but nevertheless 
> > > > many other subsystems have to deal with the same Kconfig issues and 
> > > > they manage to limp along.
> > > 
> > > I believe I see a steady stream of breakage for leds dependencies from 
> > > all subsystems.
> > 
> > they limp along by adding "depends on NEW_LEDS". 99% of the users 
> > will use some pre-cooked distro kernel where all these options are 
> > turned on, so the flattening and coupling of the dependencies is not 
> > a real issue in practice.
> 
> You still did not answer to the main question - do you think we should 
> revert the commit that actually introduced breakage in the sense that 
> anything depending on LEDS_CLASS should also add NEW_LEDS dependancy? 
> That will take care of the problem (as far as LEDs are concerned) for 
> _all_ subsystems and drivers at once.

do you mean this one:

| commit 66242f7ec531953fbc2f4040c5ffe1f1ffe6c5c9
| Author: Jan Engelhardt <jengelh@gmx.de>
| Date:   Thu May 10 10:44:11 2007 +0100
|
|    leds: Use menuconfig objects II - LED
|
|    Change Kconfig objects from "menu, config" into "menuconfig" so
|    that the user can disable the whole feature without having to
|    enter the menu first.

?

that split option definitely looks a bit weird, and the sprinkling of 
LEDS_CLASS+NEW_LEDS dependencies to all affected drivers feels broken as 
well. I'm all for fixing it right and can test any patch.

	Ingo
