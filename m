Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbYGQXmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbYGQXmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757399AbYGQXmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:42:06 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:10211 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756666AbYGQXmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:42:05 -0400
Date: Fri, 18 Jul 2008 03:42:01 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080717234201.GA15745@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1216133032.5345.73.camel@dax.rpnet.com> <20080715151917.GA30607@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp> <20080717041531.GA27243@secretlab.ca> <20080717140519.GA32617@polina.dev.rtsoft.ru> <20080717141335.GA2219@polina.dev.rtsoft.ru> <20080717150422.GC31932@secretlab.ca> <20080717152006.GA26120@polina.dev.rtsoft.ru> <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com> <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 01:18:18PM -0700, Trent Piepho wrote:
> On Thu, 17 Jul 2008, Grant Likely wrote:
> > Alternately, I would also be okay with a scheme where all LED nodes
> > have a common parent and an of_platform driver would bind against the
> > parent node; not the individual children.  Then the leds-gpio driver
> > could be refactored to have both platform and of_platform bus
> > bindings.
> 
> Basically what I did then in my patch then, refactor leds-gpio so most of
> it is shared and there is a block of code that does platform binding and
> another block that does of_platform binding.

Ok. I must admit I'm quite burned out with OF gpio-leds. I was posting the
bindings since April, probably four or five times. Last time a week ago,
IIRC.

During the months I received just a few replies, one from Grant ("Looks
good to me."), few from Segher (with a lot of criticism, that I much
appreciated and tried to fix all spotted issues), and one from Laurent
(about active-low LEDs).

Of course, I know we're all busy etc and we don't always read or reply to
RFCs, so don't get me wrong, I'm not blaming or something. It just would be
great if all these ideas would be spoken up a bit earlier, i.e. not in the
middle of the merge window... But yes, we have what we have.

And the true thing is that I tend to agree with all your comments, and I
strongly believe that the issues you pointed out should be fixed prior to
merging. But I'm tired of these leds, they aren't _that_ interesting,
btw. ;-)

So..

Trent, I encourage you to collect your patch snippets into complete patch,
and post it so it could slip into 2.6.27 (the bad thing is that your
approach involves changes to the existing drivers, not just adding new
driver that could slip even into -rc9).

That is, I have a bunch of patches in my stg queue on which I can work
with more fun, so I'm somewhat glad that somebody will take care of the
notorious OF GPIO LEDs. ;-)


For what it's worth:

> I didn't change the OF platform binding syntax so as not to complicate the
> example, but that's easy to do.  Something like:
> 
> leds {
>  	compatible = "gpio-led";
>  	gpios = <&mpc8572 6 0
>  	         &mpc8572 7 0>;
>  	labels = "red", "green";
> };
> 

I don't like this.

> Or like this, which needs a little more code to parse:
> 
> leds {
>  	compatible = "gpio-led";
>  	led@6 {
>  		gpios = <&mpc8572 6 0>;
>  		label = "red";
>  	};
>  	led@7 {
>  		gpios = <&mpc8572 7 0>;
>  		label = "green";
>  	};
> };

I like this. Or better what Grant suggested, i.e. move label to node
name.

> I like the first better.  It follows the example from the docs about how
> devices with multiple gpios should work too.

IMO, each LED is a device. So, I would rather define compatible = <> for
each led.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
