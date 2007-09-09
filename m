Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbXIIEtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbXIIEtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 00:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbXIIEs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 00:48:57 -0400
Received: from 1wt.eu ([62.212.114.60]:2440 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbXIIEs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 00:48:56 -0400
Date: Sun, 9 Sep 2007 06:48:32 +0200
From: Willy Tarreau <w@1wt.eu>
To: Kyle Rose <krose@krose.org>
Cc: Adrian Bunk <bunk@kernel.org>, Bill Davidsen <davidsen@tmr.com>,
       James Corey <ploversegg@yahoo.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Rob Sims <lkml-z@robsims.com>, linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
Message-ID: <20070909044832.GA9941@1wt.eu>
References: <20070905102230.10b0bdcf@oldman> <782111.42803.qm@web90413.mail.mud.yahoo.com> <46E2DF74.7040307@tmr.com> <20070908191132.GD3563@stusta.de> <46E35D8C.1070909@krose.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E35D8C.1070909@krose.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 08, 2007 at 10:42:20PM -0400, Kyle Rose wrote:
> 
> > You are a regular reader of linux-kernel, and therefore the sk98lin 
> > removal can hardly be a surprise for you. If you prefer whining over 
> > helping to improve the kernel that's your choice...
> >   
> In my case the issue is simply one of practicality: I cannot go to the
> data center 5 times per day to reboot my colo box.  Therefore, I run
> sk98lin.  It's really that simple.

Adrian generally wants to force "normal" users to test new drivers in order
to quickly find bugs and fade out older ones. While this is often possible
on the desktop, it's not possible for production servers. And not everyone
can run 2.6.16.x to get a long-term stable kernel.

I think that what is really needed is to add the opposite of "experimental"
in the config options. Something like "deprecated drivers" which would be
disabled by default. Desktop users would normally not care about that and
rely only on newer drivers. Server users would have to enable the option if
they want their old driver to be present because they have no other choice.

With each driver's help text, it would be wise to add some text indicating
what will replace the driver in question, so that their users know how to
test it on non-production machines.

But I agree with Kyle that on production systems, it is not acceptable to
have a driver hang even once a month. This generally implies loss of service
and customers going away. Ideology has no place in this area, is is quickly
replaced by pragmatism.

It was the same reason I spent time trying to get sky2 to reliably work in
2.4 ; sk98lin v8 was horribly unstable. Sky2 was fairly better but did not
support some basic operations such as ifdown/ifup. sk98lin v10 finally worked
fine, and I upgraded my customer's system with it because I needed anything
which would reliably work. It was not acceptable anymore to have the customer
phone twice a week complaining that their server had crashed again.

In the long term, I would really like to get sky2 to work well in 2.4
because I'm more confident it in, it's cleaner, less obscure and less
bloated. Having passed terabytes of data through both drivers I have
not observed any glitch with sky2 as I had with sk98lin v8.

Fortunately, sky2 chips are mostly found on desktop motherboards, so that
helps the driver stabilize very quickly. It should not take as long as
the transition from eepro100 to e100.

Willy

