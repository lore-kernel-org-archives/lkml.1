Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbXBOXgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbXBOXgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbXBOXgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:36:15 -0500
Received: from tim.rpsys.net ([194.106.48.114]:34054 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbXBOXgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:36:14 -0500
Subject: Re: [PATCH] input: extend EV_LED
From: Richard Purdie <rpurdie@rpsys.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20070215232438.GB4176@elf.ucw.cz>
References: <freemail.20070115234756.58787@fm13.freemail.hu>
	 <1171580944.5839.38.camel@localhost.localdomain>
	 <20070215232438.GB4176@elf.ucw.cz>
Content-Type: text/plain
Date: Thu, 15 Feb 2007 23:36:04 +0000
Message-Id: <1171582564.5839.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-02-16 at 00:24 +0100, Pavel Machek wrote:
> > The led framework is generic. If you can write a function to turn it
> > on/off you can drive it with the LED framework.
> 
> Even if that function is slow and sleeps?

The LED class itself can call in interrupt context so you'd have to
schedule a workqueue if you need to sleep.

> > One way I've come up with is adds capability to the class to have LED
> > specific triggers and you can then expose these hardware capabilities as
> > an extra trigger specific to the LED.
> > 
> > Another proposal more specific to this use case was to have some
> > information behind the scenes which the software timer based trigger
> > could use to turn on the "hardware acceleration" if present and capable
> > of the requested mode. This might just need a function pointer in the
> > core so could be quite neat.
> 
> I do not think we want to permit this led to run in "not accelerated"
> mode. I believe i8042 accesses are pretty expensive.

Which means they probably won't work well with the standard triggers.
Not something we can do much about though...

> > Nether patch exists yet.
> 
> Yep, interested party should create one of them :-). (And I'd prefer
> the first one, due to i8042 slowness).

Right, patches welcome :)

Cheers,

Richard


