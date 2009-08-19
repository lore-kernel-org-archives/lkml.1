Return-Path: <linux-kernel-owner+w=401wt.eu-S1751925AbZHSL6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbZHSL6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 07:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbZHSL6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 07:58:00 -0400
Received: from mail2.shareable.org ([80.68.89.115]:36142 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZHSL57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 07:57:59 -0400
Date: Wed, 19 Aug 2009 12:57:52 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: David Miller <davem@davemloft.net>, r.schwebel@pengutronix.de,
       vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, arjan@linux.intel.com,
       kernel@pengutronix.de, netdev@vger.kernel.org
Subject: Re: new ipdelay= option for faster netboot
Message-ID: <20090819115752.GA25052@shareable.org>
References: <4A89DB15.6060101@am.sony.com> <20090817.180323.253692704.davem@davemloft.net> <4A8A02CA.7040305@am.sony.com> <20090817.182754.50348941.davem@davemloft.net> <4A8A06A0.2070402@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8A06A0.2070402@am.sony.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Bird wrote:
> David Miller wrote:
> > From: Tim Bird <tim.bird@am.sony.com>
> > Date: Mon, 17 Aug 2009 18:24:26 -0700
> >
> >> David Miller wrote:
> >>> I have card/switch combinations that take up to 10 seconds to
> >>> negotiate a proper link.
> >> What types of delays are these timeouts supposed to
> >> cover?
> >
> > The problem is that if you don't first give at least some time for the
> > link to come up, the remaining time it takes the link to come up will
> > end up chewing into the actual bootp/dhcp protocol timeouts.  And
> > that's what we're trying to avoid.
> 
> What link?  I'm not that familiar with networking.
> 
> Assuming I'm using ethernet, what link needs to come up?

When you plug an ethernet cable in, you may have noticed it takes a
short time before the signal light comes on.  That's negotiation time.
Some are slower than others, but none of them do it instantly.

> Is this something to do with power propagation to the
> physical wire?

Not really.

> Is there some MAC layer negotiation between the card and the switch?
> Is it the time for the switch to do speed detection?

Yes and yes.

> And, can any of this be more accurately determined
> or guessed-at with knowledge of the onboard hardware?
> Or is it dependent on external conditions?

It can be accurately determined with most cards (all modern ones)
because you get a notification when it's done, or you can poll the card.

That's why on the desktop it's able to detect when you plug in an
ethernet cable and start DHCP as soon as link negotiation is complete.

So the right thing to do, as David Miller suggested too, isn't a fixed
timeout.  It should wait for link state UP and then start DHCP
immediately.

-- Jamie
