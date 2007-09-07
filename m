Return-Path: <linux-kernel-owner+w=401wt.eu-S965640AbXIGWEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965640AbXIGWEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 18:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758596AbXIGWEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 18:04:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57140 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758317AbXIGWEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 18:04:11 -0400
X-Sasl-enc: E2is3QjsAyBiJnIAYzA2Ggk7+uC17JHlOwlSA75uTEEY 1189202650
Date: Fri, 7 Sep 2007 19:04:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org, gregkh@suse.de,
       dmitry.torokhov@gmail.com
Subject: Re: Platform device id
Message-ID: <20070907220407.GE4357@khazad-dum.debian.net>
References: <20070907153559.17faf9d1@hyperion.delvare> <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com> <20070907164129.65816B9389@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20070907210029.GB4357@khazad-dum.debian.net> <20070907214116.5051B237214@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070907214116.5051B237214@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Sep 2007, David Brownell wrote:
> > > For that matter, a *driver* should never create its own device node(s)
> > > in the first place.  Device creation belongs elsewhere, like as part of
> > > platform setup or, for busses with integral enumeration support like
> > > PCI or USB, bus glue.  Linux is moving away from that legacy model.
> >
> > This assumes that we have a better bus than "platform" to dump drivers like
> > thinkpad-acpi, hdaps, and a host of other host-specific stuff.
> 
> I don't follow.  If it's host-specific, then it's easy enough to
> have a host-specific routine creating those platform devices.
> A different host wouldn't call that routine.

We do that in the module that also provides the device driver. E.g. hdaps or
thikpad-acpi will provide both the platform device (and register it), and
the driver.

> (Also, note that "platform", "host", and "board" are ambiguous.
> In some contexts each is synonymous; in others, not.  I avoid

In this specific case I am talking about, they're not.  ThinkPads are the
host.  The platform for a ThinkPad is either i386 or amd64.  But there are
many more hosts that are i386 or amd64 than ThinkPads, and the devices in my
example are thinkpad-specific.

I don't feel like drivers like hdaps, thinkpad-acpi, dock, bay, and many
others really belong in the platform bus.  But that's what happens right
now.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
