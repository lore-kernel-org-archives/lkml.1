Return-Path: <linux-kernel-owner+w=401wt.eu-S934435AbYBHFng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435AbYBHFng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:43:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbYBHFn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:43:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:47930 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbYBHFnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:43:24 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
Subject: Re: ACPI_WMI: worst config description of all times
Date: Fri, 8 Feb 2008 00:43:02 -0500
User-Agent: KMail/1.9.5
Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Pavel Machek" <pavel@ucw.cz>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       linux-acpi@vger.kernel.org
References: <20080207214715.GA15211@elf.ucw.cz> <2c0942db0802071738g2f426d4y6ee9ab58b62d8174@mail.gmail.com> <200802080202.41355.carlos@strangeworlds.co.uk>
In-Reply-To: <200802080202.41355.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802080043.03126.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2008 21:02, Carlos Corbacho wrote:
> On Friday 08 February 2008 01:38:01 Ray Lee wrote:
> > <nod> That's clear to me (whereas the original wasn't), though I would
> > still argue for this driver being select'ed by the drivers that
> > require it. As you note, other laptop specific drivers do so, and
> > Linus has come down in favor of that as well in the past, so you have
> > a friend in high places :-).
> 
> I have some other patches lined up to do so. Unless I hear some arguments
> against it, or some better alternatives, I'll put them together with this
> and get Len to apply them to the ACPI tree (and then hopefully push back
> out before the -rc1 release).

done.

cheers,
-Len

>From 4a507d93fac78ecd37d18343c57c564f6a126f01 Mon Sep 17 00:00:00 2001
From: Len Brown <len.brown@intel.com>
Date: Fri, 8 Feb 2008 00:37:16 -0500
Subject: [PATCH] acer-wmi, tc1100-wmi: select ACPI_WMI
Organization: Intel Open Source Technology Center

It is safe for these Kconfig entries to use select because
they select ACPI_WMI, which already has its dependencies
satisfied.  This makes Kconfig more user friendly, since
the user selects the driver they want and the dependency
is met for them.  Otherwise, the user would have to find
and enable ACPI_WMI to make enabling these drivers possible.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/misc/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 218c65a..e19343e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -97,9 +97,9 @@ config ACER_WMI
 	depends on X86
 	depends on EXPERIMENTAL
 	depends on ACPI
-	depends on ACPI_WMI
 	depends on LEDS_CLASS
 	depends on BACKLIGHT_CLASS_DEVICE
+	select ACPI_WMI
 	---help---
 	  This is a driver for newer Acer (and Wistron) laptops. It adds
 	  wireless radio and bluetooth control, and on some laptops,
@@ -146,7 +146,7 @@ config TC1100_WMI
 	tristate "HP Compaq TC1100 Tablet WMI Extras"
 	depends on X86 && !X86_64
 	depends on ACPI
-	depends on ACPI_WMI
+	select ACPI_WMI
 	---help---
 	  This is a driver for the WMI extensions (wireless and bluetooth power
 	  control) of the HP Compaq TC1100 tablet.
-- 
1.5.4.34.g053d9

