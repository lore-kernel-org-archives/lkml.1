Return-Path: <linux-kernel-owner+w=401wt.eu-S965001AbXFGSfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965001AbXFGSfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 14:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762745AbXFGSe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 14:34:56 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:37775 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758480AbXFGSez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 14:34:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Thu, 7 Jun 2007 12:34:47 -0600
User-Agent: KMail/1.9.6
Cc: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       "Samuel Ortiz" <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706061309.28633.bjorn.helgaas@hp.com> <200706070045.14040.arvidjaar@mail.ru>
In-Reply-To: <200706070045.14040.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706071234.47517.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007 02:45:01 pm Andrey Borzenkov wrote:
> I am beginning to doubt whether drier 
> works on my system at all (i.e. before PnP change); have to find time to 
> test.

In 2.6.21, smsc-ircc2 at least found the device.  So we definitely have
a problem because in 2.6.22-rc, we don't find the device.

What laptop do you have?  Maybe I can find one to play with.

I think Windows always calls _SRS, even if it doesn't need to change
the current resource settings.  Linux doesn't do that, and my HP nw8240
firmware has a bug that leaves the IR device partly-enabled until _SRS
is called.  Maybe yours has a similar bug.

Can you set CONFIG_ACPI_DEBUG=y, make it so smsc-ircc2 isn't loaded
automatically, and try this (along with my previous patch to swap
FIR and SIR):

  # dmesg -n 8
  # echo 0x200 > /sys/module/acpi/parameters/debug_level
  # echo disable > /sys/bus/pnp/devices/00:0a/resources
  # echo activate > /sys/bus/pnp/devices/00:0a/resources
  # modprobe smsc-ircc2

If you try this, can you collect the whole dmesg log?

It's also possible that some other driver like i2c is messing with
the ISA/LPC bridge configuration and breaking the IR device config.
Your lspnp output doesn't show any other ISA devices down there,
but I know i2c likes to poke around and discover things that kinda,
sorta work, but the BIOS didn't expose.

Bjorn
