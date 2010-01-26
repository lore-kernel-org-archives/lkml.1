Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357Ab0AZPou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0AZPou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004Ab0AZPot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:44:49 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:46541 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753586Ab0AZPos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:44:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=N7q79/mvxBkt1+vWvqL/++/jEXv9VW/7/c8jcqfh1BCX8c5niGInWiekdktpEwBuQxeDlGFWjTVAUYAELAqawHMsEvKMPBDKogClZm6wBZYyyPdHS9wToco7eSBRzB13hR/sXgMEm4YtyVqM6ZvlrmvqUkW7cy5qjx9SEQkitiw=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: HP5hP6AVM1mhvUv97VUfiFfHierj4_Mt5dLr_HH9n8aOst.oDJb2xf_Sv9tV7WlQLfgykaTzSN4s70l.ZLs96EibpGGg6zHOPyUH_sN8DblTeKbtbSlaWd74hTOuUBE5B1nXCqihj.TFUkxcZZjPN3K1kZVv8AB4Cw9dwFNQgfECQGMjruTrLzYRstnYCIkB43rIP1e8Hbl_46Qj4mltUYnGDefrIBTjRxCxuqdLuRMhhgRtvvDVQ..lDBHv95Oo
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Date: Tue, 26 Jan 2010 07:44:46 -0800
User-Agent: KMail/1.9.10
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>, linux-omap@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com> <201001260535.21689.david-b@pacbell.net> <20100126142102.GU15759@rakim.wolfsonmicro.main>
In-Reply-To: <20100126142102.GU15759@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201001260744.46780.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010, Mark Brown wrote:
> > > Yes please - it's not just chargers either, this can also be used by
> > > PMICs which do power path management that includes USB.
> 
> > Color me confused ... what do you mean by "power path"?
> 
> In the sort of design I'm talking about there is generally a system
> power rail which is generated from the various power sources available
> to the system, which might include a combination of batteries, USB and
> wall adaptors.

Just as an example:  drivers/mfd/tps6510.c supports exactly
that trio of power sources.  More than one system rail though,
which (as you know) is pretty common -- core != I/O.

It's *way* simpler than e.g. the TWL6030.  :)


> The power path management logic is the hardware which 
> controls which of these are actually being used as supplies, and may
> also include battery charger management.
> 
> > Do you mean something like "the board as a whole can take N mA of
> > current from USB", rather than specifically addressing a charger?
> 
> Pretty much, from this point of view.

OK -- clear now.


> > It's not uncommon to do things like use VBUS current to power the
> > USB circuitry, too.  That can leave less for other purposes.  All
> > of that being rather board-specific.
> 
> In this sort of design either VBUS goes through the power path
> management logic before anything else gets to use it or the hardware
> will know about the headroom it needs to leave.  The power path
> management will usually do things like try to suppliment VBUS with any
> battery that's available to generate the main system supply rail.
> 
> This all needs to function without software since it tends to get used
> to decide things like if the system is able to begin power up at all, .

Yep.  That's part of the reason the USB specs have hard
rules about having 100 mA available (for some period)
even before software can come up.

Bus powered devices can come up on that 100mA, running
enough to enumerate ... and request more power, if they
need it.

Not all Linux systems can boot with that little power!

- Dave


