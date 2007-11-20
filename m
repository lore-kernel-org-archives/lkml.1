Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbXKTPU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbXKTPU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbXKTPUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:20:51 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:63167 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757146AbXKTPUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:20:50 -0500
Date: Tue, 20 Nov 2007 16:20:47 +0100
From: Jean Delvare <khali@linux-fr.org>
To: David Brownell <david-b@pacbell.net>
Cc: "eric miao" <eric.y.miao@gmail.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Kevin Hilman" <khilman@mvista.com>,
       "Paul Mundt" <lethal@linux-sh.org>, "Ben Dooks" <ben@trinity.fluff.org>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Message-ID: <20071120162047.277c1ccd@hyperion.delvare>
In-Reply-To: <200711170936.25524.david-b@pacbell.net>
References: <200710291809.29936.david-b@pacbell.net>
	<200711132036.14927.david-b@pacbell.net>
	<20071117113855.7532e477@hyperion.delvare>
	<200711170936.25524.david-b@pacbell.net>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sat, 17 Nov 2007 09:36:24 -0800, David Brownell wrote:
> On Saturday 17 November 2007, Jean Delvare wrote:
> > On Tue, 13 Nov 2007 20:36:13 -0800, David Brownell wrote:
> > > On Tuesday 13 November 2007, eric miao wrote:
> > > >  	if (!requested)
> > > > -		printk(KERN_DEBUG "GPIO-%d autorequested\n",
> > > > -				chip->base + offset);
> > > > +		pr_debug("GPIO-%d autorequested\n", gpio);
> > > 
> > > Leave the printk in ... this is the sort of thing we want
> > > to see fixed, which becomes unlikely once you hide such
> > > diagnostics.  And for that matter, what would be enabling
> > > the "-DDEBUG" that would trigger a pr_debug() message?
> > 
> > The original code isn't correct either.
> 
> It's perfectly correct.  That it's an idiom you don't
> seem to *like* but is distinct from correctness.
> 
> > Either this is a debug message 
> > and indeed pr_debug() should be used, or it's not and KERN_DEBUG should
> > be replaced by a lower log level.
> 
> KERN_DEBUG is what says the message level is "debug".
> Both styles log messages at that priority level.
> 
> Which is distinct from saying that the message should
> vanish from non-debug builds ... that's what pr_debug
> and friends do, by relying implicitly on "-DDEBUG".

Were you trying to be funny or something? You aren't really suggesting
that I don't know what a debug level is, and how pr_debug() works, are
you?

> In this case, the original code was saying that the
> message should NOT just vanish.  One reason the patch
> was incorrect was that even on its own terms, it was
> wrong ... since it used the "-DDEBUG" mechanism wrong,
> and prevented the message from *EVER* appearing.

It's perfectly correct: developers can add "#define DEBUG" manually
before they build the code. That it's an idiom you don't seem to *like*
is distinct from correctness.

OK, can we stop now? David, you need to learn how to work with the
community. The way you keep discussing every word of every reply is
very unpleasant and not constructive at all. Whenever someone reviews
your code, he or she is giving you something. You should be thankful
for the help you received. Instead of that, it looks like you try to
defend yourself against him/her. Please stop working against people
reviewing your code, and start working _with_ them.

Thanks,
-- 
Jean Delvare
