Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbXF3WDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbXF3WDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 18:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbXF3WDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 18:03:05 -0400
Received: from alephnull.demon.nl ([83.160.184.112]:45482 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbXF3WDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 18:03:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=Afb7Mvco0V8PR4Ts4RaN7nrDHdEL3iGSO4Efw22TMAp74lI2Oij/7tSPArhl5
	AJXjI1YUKOZCdv6qqzjznxuOQ==
Date: Sun, 1 Jul 2007 00:03:01 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: =?iso-8859-1?B?VPZy9ms=?= Edvin <edwintorok@gmail.com>,
       zambrano@broadcom.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, power@bughost.org
Subject: Re: [PATCH] b44: power down PHY when interface down
Message-ID: <20070630220301.GD2553@xi.wantstofly.org>
References: <4354d3270706300447ladcda4by987b1f87963112f9@mail.gmail.com> <200706302353.25426.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706302353.25426.mb@bu3sch.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 11:53:25PM +0200, Michael Buesch wrote:

> > When the interface is down (or driver removed), the BroadCom 44xx card remains
> > powered on, and both its MAC and PHY is using up power.
> > This patch makes the driver issue a MAC_CTRL_PHY_PDOWN when the interface
> > is halted, and does a partial chip reset turns off the activity LEDs too.
> > 
> > Applies to 2.6.22-rc6, or current git head.
> > 
> > Tested on a Broadcom BCM4401-B0 card, it saves ~0.5W (measured using powertop).
> 
> Hm, I was going to measure the real power advantage with a
> PCI-extender card. But my B44B0 card doesn't seem to work in
> that extender card. It works perfectly fine sticked directly into
> the motherboard, though, and other cards like a BCM4318 work in
> the extender, too.
> Not sure what this is.
> The extender has an application note about nonworking cards in the
> extender and a too big resistor on the board IDSEL pin being the
> cause of this.

Does the card show up in lspci at all?  IDSEL drive strength
issues should only affect config space accesses.

Does the extender board have a PCI-PCI bridge on it?  (If not,
there's not really any reason to resistively couple the IDSEL
line to the host, since the host should take care of that.)


> Maybe I can try with another machine tomorrow.

That would only make a difference if there is no PCI-PCI bridge on
the extender board.

If the extender resistively couples the host's IDSEL line, you might
see different results on a different host bridge, since different
host bridges can use different numbers of IDSEL stepping cycles.
