Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbXF3O3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbXF3O3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 10:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbXF3O2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 10:28:55 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:47016 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756987AbXF3O2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 10:28:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=auknqg4WIKyWP6bYACu6yuWlGWGJHxyA8aMNdBmz0HF4AdTu4QpnC4+pUrODFBZmaEwqpuY/Q2JIQms8v8QvTpDaqMKMdCt/XttAZOZ1db0xE4Vaq2viVSD5MTLOsju23xx75oNg4DUGeYg+BZE2V0u67IF7ZZUrI6+tjAFHPDs=  ;
X-YMail-OSG: N9vaJzgVM1kiLCP.b_oflA17N90.agEs7GtiJL3wftGBw_iWWYTr0A7E5fqjLTtZO0sGUmpqGw--
From: David Brownell <david-b@pacbell.net>
To: Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCH] PXA27x UDC driver.
Date: Sat, 30 Jun 2007 07:25:35 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Yang-r58472 <LeoLi@freescale.com>
References: <20070628103619.GW13886@enneenne.com> <200706281453.23414.david-b@pacbell.net> <20070629085801.GH13886@enneenne.com>
In-Reply-To: <20070629085801.GH13886@enneenne.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706300725.35934.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 June 2007, Rodolfo Giometti wrote:
> On Thu, Jun 28, 2007 at 02:53:22PM -0700, David Brownell wrote:
> > 
> > Let's start with *JUST* a driver, not trying to update everything
> > else in the USB Gadget stack so that it looks like it's designed
> > specifically to handle all of Intel's design botches related to
> > endpoint config ... and work worse for essentially everything else.
> > 
> > (Unlike pretty much every other vendor, Intel wanted hardware config
> > management.  It was unusably buggy in pxa21x/25x/26x, and not much
> > better in pxa27x.)
> > 
> > 
> > So in technical terms, and to repeat what I've said before:  just
> > configure it to act more like a PXA 25x chip (no altsettings) and
> > get it so it passes all the tests [1], modulo errata which have no
> > workarounds ... then submit that.  No epautoconfig updates, no
> > patches to every gadget driver to cope with updated autoconfig.
> 
> This looks interesting... as you alredy told this driver derives from
> an older one, I just maintained it till now.
> 
> If I well understand I should remove usb_ep_autoconfig() and program
> into the controller only one (the default) configuration. Is that
> right?

Other than the fact that "configuration" means something very specific
in USB terms, so there would be three of them ... yes.  That's what the
PXA2[156]x UDC hardware does.


> Currently I tested the driver only with ether gadget, but if I do as
> above, should I get the driver working with all gadgets automagically?
> :)

There's not much point in merging a driver that only works with one
of what are currently six gadget drivers ... others are on the way.

Yes, the point of working more like PXA2[156]x hardware is that we
know that kind of hardware setup works with everything ... while we
know that every attempt to use the PXA27x magic has failed on some
of those drivers.  (By all reports, because of hardware bugs.)

- Dave


