Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYGWO5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYGWO5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 10:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYGWO4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 10:56:55 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:10141 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752810AbYGWO4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:56:54 -0400
Date: Wed, 23 Jul 2008 18:56:50 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: PIXIS gpio controller and gpio flags
Message-ID: <20080723145650.GA13792@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080717150422.GC31932@secretlab.ca> <20080717152006.GA26120@polina.dev.rtsoft.ru> <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com> <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp> <20080717234201.GA15745@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807171807420.29856@t2.domain.actdsltmp> <20080718100549.GA28741@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807191352040.27586@t2.domain.actdsltmp> <20080721175357.GA1773@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807211340460.26456@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807211340460.26456@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 02:12:20PM -0700, Trent Piepho wrote:
> On Mon, 21 Jul 2008, Anton Vorontsov wrote:
> > On Sat, Jul 19, 2008 at 02:08:01PM -0700, Trent Piepho wrote:
> >> It doesn't look like you have any way to unset the active low flag.  What if
> >> I unload the leds-gpio driver (or another gpio user) and then try to use the
> >> gpio with something else?  The active low flag is stuck on!
> >
> > Why would you want to unset the flags? It is specified in the device
> > tree, and can't be changed. Specifying different flags for the same GPIO
> > would be an error (plus, Linux forbids shared gpios, so you simply can't
> > specify one gpio for several devices).
> 
> You can't use the same gpio for two different things at the same time, but you
> can load a driver, unload it, and then load another.

Hm.. yeah, this might happen. Now I tend to think that transparent
active-low handling wasn't that good idea after all. So, something like
of_gpio_is_active_low(device_node, gpioidx) should be implemented
instead. This function will parse the gpio's = <> flags. Please speak up
if you have any better ideas though.


Thanks for bringing this up,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
