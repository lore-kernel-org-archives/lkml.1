Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYCRDf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYCRDf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 23:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYCRDfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 23:35:19 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48663 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbYCRDfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 23:35:18 -0400
X-Sasl-enc: DjB0MQX7PDiGziWXA4D0mibWv6/SGnIrqRp0hcQP2NnZ 1205811315
Date: Tue, 18 Mar 2008 00:35:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: LED naming standard for LED class
Message-ID: <20080318033501.GA17147@khazad-dum.debian.net>
References: <1202380503.9519.21.camel@dax.rpnet.com> <20080207213845.GA27862@khazad-dum.debian.net> <1202422388.9519.123.camel@dax.rpnet.com> <20080316181840.GG19825@khazad-dum.debian.net> <1205695756.4524.20.camel@dax.rpnet.com> <20080316194823.GA31782@khazad-dum.debian.net> <20080317033458.GA20486@khazad-dum.debian.net> <1205747515.4552.15.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205747515.4552.15.camel@dax.rpnet.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008, Richard Purdie wrote:
> On Mon, 2008-03-17 at 00:34 -0300, Henrique de Moraes Holschuh wrote:
> > Richard, isn't there *any* way to change this new ABI?  It has not been in
> > any stable mainline release yet, so it is not too late if we do it now.
> 
> It is not an new ABI, its an extension as per the way it was documented
> to work.

It is a full ABI break for any drivers you change a LED name.  It is not
an ABI break for drivers which *add* new LEDs with the new names, but keep
the old naming on older leds.  And almost all of the changed drivers had a
stable release already.

There is no way we can pass a sysfs node name change like that as an
extension of the ABI, as it breaks all userspace scripts that used the old
node name.

Looking at the commit, the following drivers had ABI breaks to go
from "function" to "driver:color:function": nas100d, nslu2, wistron.
These can be considered bug-fixing, since "function" is clash-prone.

The following drivers had ABI breaks to add the middle ":" for the color
field: applesmc, ams-delta, net48, wrap, asus, b43.

The following drivers had ABI breaks to go from driver to
driver:color:function : corgi, locomo, spitz, tosa.

Looks like it was a hideous mess to me, and IMO we can pretty much say
that the naming guidelines were nothing but a dream before the commit.

Anyway, you did break ABI in 13 drivers, and only 3 could be considered a
bug fix.  And if you're going to break the ABI (I am *not* speaking
against it in this case), let's make the best of it, please.

> The problem is the "bad" ABI has existed in that form since somewhere
> around 2.6.15 and it is therefore too late to drop things from it or

LED drivers did whatever they wanted, no matter what docs said.  Each LED
driver had its own ABI, and only a few of those followed what was
described in the led class docs.

> rearrange it. The ABI described additions being allowed so we're taking
> advantage of that to gain something which should have really been there
> originally. Short term there is some complexity with some limits but
> they're going away so there is no problem.

Now that we have it clear that a widespread ABI break took place, the
above reasoning doesn't hold anymore, and there is no reason to fix the
"past mistake" in the led class documentation.

> The alternative is we throw the whole thing away and go to random
> numbers for the different LEDs and attributes. To work out which LED is
> which you then have to read up to 3 files per LED before you can even
> decide whether its the one you want. I don't like that idea...

I didn't suggest that.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
