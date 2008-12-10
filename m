Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbYLJX0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbYLJX0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 18:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYLJX0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 18:26:08 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51987 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614AbYLJX0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 18:26:06 -0500
X-Sasl-enc: Ga15gWFF+WeXm8uofA0GYTV/8hi1lU/FBvTlKGm8KktZ 1228951564
Date: Wed, 10 Dec 2008 21:26:02 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Oliver Neukum <oliver@neukum.org>
Cc: Witold Szczeponik <Witold.Szczeponik@gmx.net>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Adam Belay <abelay@mit.edu>, rjw@sisk.pl
Subject: Re: [PATCH] PNPACPI: Enable Power Support
Message-ID: <20081210232602.GC7589@khazad-dum.debian.net>
References: <493D8A1F.2090907@gmx.net> <20081210095315.GA20627@khazad-dum.debian.net> <200812101123.00055.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200812101123.00055.oliver@neukum.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008, Oliver Neukum wrote:
> Am Mittwoch, 10. Dezember 2008 10:53:15 schrieb Henrique de Moraes Holschuh:
> > Although I do wonder WTF we don't do that on our USB UHCI/EHCI kernel
> > drivers, that ACPI needs to step in to fix it.  If it is not a wake
> 
> EHCI/UHCI have no way to power down host controllers.
> It needs external means, namely ACPI.

I see.  So we can't just set the pci devices to D0 to cut power to the USB
ports and USB controller while in STR?  Must be the EC stuff I just noticed
in the ACPI AML, then.

> > device, why are we leaving it powered up?  It is bad enough we don't
> > have any sort of proper USB power control, but to leave the entire USB
> > subsystem powered up without reason?!
> 
> We don't. If you unplug all devices, USB will power down as much as is
> compatible with detecting new devices.

Thanks for the update.

> > Vista not only powers down the USB HCIs and ports on STR, it also
> > powers down ports when you "safely remove the USB device", and seems
> > to leave the port powered down until you insert a device (or remove
> > the device already in there, whatever).
> 
> If you cut power to a port, you cannot detect a hotplugging. You can
> suspend it, which Linux does do.

Hmm, probably it is just suspend, then (outside of STR.  On STR, it *is*
somehow powering down the ports when no wake devices are there, but that
might be done using extra stuff, and not just the PCI functions of the Intel
ICH6 EHCI/UHCI controllers).

I guess our userspace is not doing the suspend on "safely remove" then?
Because at least here, it is not behaving as Windows does when I tell KDE to
"safely eject" (which probably ends up being a HAL request of some sort).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
