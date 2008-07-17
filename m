Return-Path: <linux-kernel-owner+w=401wt.eu-S932517AbYGQUuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbYGQUuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757933AbYGQUuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:50:00 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:12492 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262AbYGQUt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:49:59 -0400
Date: Thu, 17 Jul 2008 14:49:51 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Trent Piepho <tpiepho@freescale.com>
Cc: avorontsov@ru.mvista.com, Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080717204951.GD6894@secretlab.ca>
References: <1216133032.5345.73.camel@dax.rpnet.com> <20080715151917.GA30607@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp> <20080717041531.GA27243@secretlab.ca> <20080717140519.GA32617@polina.dev.rtsoft.ru> <20080717141335.GA2219@polina.dev.rtsoft.ru> <20080717150422.GC31932@secretlab.ca> <20080717152006.GA26120@polina.dev.rtsoft.ru> <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com> <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
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

Yes

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

I kind of like the second option better, because there is less chance
of doing bad stuff if the gpio specifier was buggered up; but I'm cool
with either.

However, if the second option is chosen then something like the following
might be better as it eliminates the meaningless @<number> specifier.

leds {
	compatible = "gpio-led";
	red {
		gpios = <&mpc8572 6 0>;
	};
	green {
		gpios = <&mpc8572 7 0>;
	};
};

Cheers,
g.
