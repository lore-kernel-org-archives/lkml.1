Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0AONsV (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 08:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656Ab0AONsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 08:48:18 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:63313 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756602Ab0AONsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 08:48:15 -0500
Date: Fri, 15 Jan 2010 14:48:33 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org
Cc: siccegge@stud.informatik.uni-erlangen.de,
        Reinhard.Tartler@informatik.uni-erlangen.de
Subject: [PATCH] obsolete config in kernel source (USB_GADGET_*)
Message-ID: <20100115134833.GD3321@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZARJHfwaSJQLOEUz"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZARJHfwaSJQLOEUz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	The linux tree contains USB-Id assignment snippets for some
USB Gadget drivers, which, as far as I can tell, never worked on
mainline linux2.6 but either originate from seemingly long-dead
third-party trees or were never ported from linux2.4.

	As there has also seemingly never existed a way to select
these configs in the KConfig system it might be time to get rid of
them which would be done by the attached patch.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

--ZARJHfwaSJQLOEUz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-dropping-remainings-of-half-dead-usb-gadget-drivers.patch"

>From 7cd6adc0dd35931d54da47add31740943c34d5e9 Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Fri, 15 Jan 2010 14:13:15 +0100
Subject: [PATCH] dropping remainings of half-dead usb gadget drivers

This patch dropps 5 CONFIG_USB_GADGET items that haven't been
accessible for a long time (waiting to be ported from 2.4 to 2.6,
maybe relating to external trees with no activity in the last 2 years
etc). If one of these really shows up again it should be
straigt-forward to add them again.

This doesn't change USB IDs assigned to USB gadget drivers which
causes some holes in the ID namespace but changing public identifiers
isn't that good of an idea.

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
---
 drivers/usb/gadget/gadget_chips.h |   46 -------------------------------------
 1 files changed, 0 insertions(+), 46 deletions(-)

diff --git a/drivers/usb/gadget/gadget_chips.h b/drivers/usb/gadget/gadget_chips.h
index f2d270b..b1bca51 100644
--- a/drivers/usb/gadget/gadget_chips.h
+++ b/drivers/usb/gadget/gadget_chips.h
@@ -45,46 +45,18 @@
 #define	gadget_is_goku(g)	0
 #endif
 
-/* SH3 UDC -- not yet ported 2.4 --> 2.6 */
-#ifdef CONFIG_USB_GADGET_SUPERH
-#define	gadget_is_sh(g)		!strcmp("sh_udc", (g)->name)
-#else
-#define	gadget_is_sh(g)		0
-#endif
-
-/* not yet stable on 2.6 (would help "original Zaurus") */
-#ifdef CONFIG_USB_GADGET_SA1100
-#define	gadget_is_sa1100(g)	!strcmp("sa1100_udc", (g)->name)
-#else
-#define	gadget_is_sa1100(g)	0
-#endif
-
 #ifdef CONFIG_USB_GADGET_LH7A40X
 #define	gadget_is_lh7a40x(g)	!strcmp("lh7a40x_udc", (g)->name)
 #else
 #define	gadget_is_lh7a40x(g)	0
 #endif
 
-/* handhelds.org tree (?) */
-#ifdef CONFIG_USB_GADGET_MQ11XX
-#define	gadget_is_mq11xx(g)	!strcmp("mq11xx_udc", (g)->name)
-#else
-#define	gadget_is_mq11xx(g)	0
-#endif
-
 #ifdef CONFIG_USB_GADGET_OMAP
 #define	gadget_is_omap(g)	!strcmp("omap_udc", (g)->name)
 #else
 #define	gadget_is_omap(g)	0
 #endif
 
-/* not yet ported 2.4 --> 2.6 */
-#ifdef CONFIG_USB_GADGET_N9604
-#define	gadget_is_n9604(g)	!strcmp("n9604_udc", (g)->name)
-#else
-#define	gadget_is_n9604(g)	0
-#endif
-
 /* various unstable versions available */
 #ifdef CONFIG_USB_GADGET_PXA27X
 #define	gadget_is_pxa27x(g)	!strcmp("pxa27x_udc", (g)->name)
@@ -122,14 +94,6 @@
 #define gadget_is_fsl_usb2(g)	0
 #endif
 
-/* Mentor high speed function controller */
-/* from Montavista kernel (?) */
-#ifdef CONFIG_USB_GADGET_MUSBHSFC
-#define gadget_is_musbhsfc(g)	!strcmp("musbhsfc_udc", (g)->name)
-#else
-#define gadget_is_musbhsfc(g)	0
-#endif
-
 /* Mentor high speed "dual role" controller, in peripheral role */
 #ifdef CONFIG_USB_GADGET_MUSB_HDRC
 #define gadget_is_musbhdrc(g)	!strcmp("musb_hdrc", (g)->name)
@@ -203,20 +167,12 @@ static inline int usb_gadget_controller_number(struct usb_gadget *gadget)
 		return 0x02;
 	else if (gadget_is_pxa(gadget))
 		return 0x03;
-	else if (gadget_is_sh(gadget))
-		return 0x04;
-	else if (gadget_is_sa1100(gadget))
-		return 0x05;
 	else if (gadget_is_goku(gadget))
 		return 0x06;
-	else if (gadget_is_mq11xx(gadget))
-		return 0x07;
 	else if (gadget_is_omap(gadget))
 		return 0x08;
 	else if (gadget_is_lh7a40x(gadget))
 		return 0x09;
-	else if (gadget_is_n9604(gadget))
-		return 0x10;
 	else if (gadget_is_pxa27x(gadget))
 		return 0x11;
 	else if (gadget_is_s3c2410(gadget))
@@ -225,8 +181,6 @@ static inline int usb_gadget_controller_number(struct usb_gadget *gadget)
 		return 0x13;
 	else if (gadget_is_imx(gadget))
 		return 0x14;
-	else if (gadget_is_musbhsfc(gadget))
-		return 0x15;
 	else if (gadget_is_musbhdrc(gadget))
 		return 0x16;
 	else if (gadget_is_mpc8272(gadget))
-- 
1.6.3.3


--ZARJHfwaSJQLOEUz--
