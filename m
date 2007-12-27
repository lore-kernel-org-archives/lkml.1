Return-Path: <linux-kernel-owner+w=401wt.eu-S1754520AbXL0WTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbXL0WTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 17:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbXL0WTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 17:19:04 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:30364 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753228AbXL0WTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 17:19:02 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OTjx3Bzav0Pyfytl/0FV775A4pvYBtSNs5fgtHMXAx0ccWd3wNpPGlBWXLaK9dnsK5ZYmf+k1vMH1zX1kABxVfsXVosKUu27QhzzCEUS+N2a8P+Jpt1CFcI7Lyv+fCfQBeSci4pVGw4QCfpmO2aufo8NWjKN8lxKLbstMwEJ4is=  ;
X-YMail-OSG: CTOpri8VM1lpb_4j.xL9IGMQgLu4qshL2HcFyPxOTIDc6fOj6sX3NjrKSR.219.OeOOpOkE60g--
From: David Brownell <david-b@pacbell.net>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH] USB Kconfig: Reorganize USB Kconfig Menu
Date: Thu, 27 Dec 2007 14:18:58 -0800
User-Agent: KMail/1.9.6
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
References: <200712231449.00862.a1426z@gawab.com>
In-Reply-To: <200712231449.00862.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271418.59156.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 December 2007, Al Boldi wrote:
> 
> Reogranize USB Kconfig Menu, and move USB_GADGET out into the Device Driver
> Menu.  This helps the USB Kconfig Menu to be more logical/usable.
> 
> Cc: David Brownell <david-b@pacbell.net>
> Cc: Greg KH <greg@kroah.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Al Boldi <a1426z@gawab.com>

Along those lines, sure ... but this particular patch can't quite
be the answer.  For one thing, it rather critially needs the appended,
else it won't work on ARM.  (And quite a lot of the ARM platforms
need the gadget stack!!)

There are ISTR a few other platforms which, for reasons unknown to
me, don't source drivers/Kconfig but recreate portions of it on
their own ... that's not something that this patch should change.

Also, looking at this in xconfig shows some oddness.  That "core"
submenu holds stuff that would logically be part of the toplevel
menu for host side USB.  While that toplevel menu has the USS720
driver, which seems more like a "miscellany" thing...

The comment about SCSI shouldn't show when SCSI is defined; and
the comment aboue "SCSI disk support" belongs with the mass storage
menu, not at the top level.  The way that the mass storage menu
is presented also hides the fact that you can get fully functional
mass storage support without checking *any* of the drivers there,
since the core already handles standard devices.

That "ARCH_HAS_HCD" mess has IMO outlived its utility, and should
vanish.

- Dave



--- a/arch/arm/Kconfig	2007-12-27 14:01:31.000000000 -0800
+++ b/arch/arm/Kconfig	2007-12-27 14:01:43.000000000 -0800
@@ -1068,6 +1068,8 @@ source "drivers/hid/Kconfig"
 
 source "drivers/usb/Kconfig"
 
+source "drivers/usb/gadget/Kconfig"
+
 source "drivers/mmc/Kconfig"
 
 source "drivers/leds/Kconfig"


