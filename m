Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbXEJBjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbXEJBjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 21:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbXEJBi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 21:38:58 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42980 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbXEJBi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 21:38:58 -0400
Date: Wed, 9 May 2007 21:38:55 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net
Subject: [git patch] move USB net drivers to drivers/net
Message-ID: <20070510013855.GA3402@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This was ACK'd by Greg, as you see in the sign-offs.  See the commit
below for rationale.

USB is now treated like other buses, for network drivers:
* USB network driver patches should go to me and netdev
* Just like in PCI or PCMCIA land, bus-specific code may
  originate from the USB side of the house (Greg's tree).



Please pull from 'usb-move' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git usb-move

to receive the following update:


commit 5b2fc499917e5897a13add780e181b4cef197072
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed May 9 21:31:55 2007 -0400

    Move USB network drivers to drivers/net/usb.
    
    It is preferable to group drivers by usage (net, scsi, ATA, ...) than
    by bus.  When reviewing drivers, the [PCI|USB|PCMCIA|...] maintainer
    is probably less qualified on networking issues than a networking
    maintainer.  Also, from a practical standpoint, chips often
    appear on multiple buses, which is why we do not put drivers into
    drivers/pci/net.
    
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>


 drivers/net/Kconfig                       |    2 ++
 drivers/net/Makefile                      |    8 ++++++++
 drivers/{usb/net => net/usb}/Kconfig      |    0 
 drivers/{usb/net => net/usb}/Makefile     |    0 
 drivers/{usb/net => net/usb}/asix.c       |    0 
 drivers/{usb/net => net/usb}/catc.c       |    0 
 drivers/{usb/net => net/usb}/cdc_ether.c  |    0 
 drivers/{usb/net => net/usb}/cdc_subset.c |    0 
 drivers/{usb/net => net/usb}/dm9601.c     |    0 
 drivers/{usb/net => net/usb}/gl620a.c     |    0 
 drivers/{usb/net => net/usb}/kaweth.c     |    0 
 drivers/{usb/net => net/usb}/kawethfw.h   |    0 
 drivers/{usb/net => net/usb}/mcs7830.c    |    0 
 drivers/{usb/net => net/usb}/net1080.c    |    0 
 drivers/{usb/net => net/usb}/pegasus.c    |    0 
 drivers/{usb/net => net/usb}/pegasus.h    |    0 
 drivers/{usb/net => net/usb}/plusb.c      |    0 
 drivers/{usb/net => net/usb}/rndis_host.c |    0 
 drivers/{usb/net => net/usb}/rtl8150.c    |    0 
 drivers/{usb/net => net/usb}/usbnet.c     |    0 
 drivers/{usb/net => net/usb}/usbnet.h     |    0 
 drivers/{usb/net => net/usb}/zaurus.c     |    0 
 drivers/usb/Kconfig                       |    2 --
 drivers/usb/Makefile                      |    7 -------
 24 files changed, 10 insertions(+), 9 deletions(-)
 rename drivers/{usb/net => net/usb}/Kconfig (100%)
 rename drivers/{usb/net => net/usb}/Makefile (100%)
 rename drivers/{usb/net => net/usb}/asix.c (100%)
 rename drivers/{usb/net => net/usb}/catc.c (100%)
 rename drivers/{usb/net => net/usb}/cdc_ether.c (100%)
 rename drivers/{usb/net => net/usb}/cdc_subset.c (100%)
 rename drivers/{usb/net => net/usb}/dm9601.c (100%)
 rename drivers/{usb/net => net/usb}/gl620a.c (100%)
 rename drivers/{usb/net => net/usb}/kaweth.c (100%)
 rename drivers/{usb/net => net/usb}/kawethfw.h (100%)
 rename drivers/{usb/net => net/usb}/mcs7830.c (100%)
 rename drivers/{usb/net => net/usb}/net1080.c (100%)
 rename drivers/{usb/net => net/usb}/pegasus.c (100%)
 rename drivers/{usb/net => net/usb}/pegasus.h (100%)
 rename drivers/{usb/net => net/usb}/plusb.c (100%)
 rename drivers/{usb/net => net/usb}/rndis_host.c (100%)
 rename drivers/{usb/net => net/usb}/rtl8150.c (100%)
 rename drivers/{usb/net => net/usb}/usbnet.c (100%)
 rename drivers/{usb/net => net/usb}/usbnet.h (100%)
 rename drivers/{usb/net => net/usb}/zaurus.c (100%)


diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index b86ccd2..d9842d8 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2499,6 +2499,8 @@ source "drivers/net/tokenring/Kconfig"
 
 source "drivers/net/wireless/Kconfig"
 
+source "drivers/net/usb/Kconfig"
+
 source "drivers/net/pcmcia/Kconfig"
 
 source "drivers/net/wan/Kconfig"
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 59c0459..c5d8423 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -206,6 +206,14 @@ obj-$(CONFIG_TR) += tokenring/
 obj-$(CONFIG_WAN) += wan/
 obj-$(CONFIG_ARCNET) += arcnet/
 obj-$(CONFIG_NET_PCMCIA) += pcmcia/
+
+obj-$(CONFIG_USB_CATC)          += usb/
+obj-$(CONFIG_USB_KAWETH)        += usb/
+obj-$(CONFIG_USB_PEGASUS)       += usb/
+obj-$(CONFIG_USB_RTL8150)       += usb/
+obj-$(CONFIG_USB_USBNET)        += usb/
+obj-$(CONFIG_USB_ZD1201)        += usb/
+
 obj-y += wireless/
 obj-$(CONFIG_NET_TULIP) += tulip/
 obj-$(CONFIG_HAMRADIO) += hamradio/

[SNIP ADD PATCHES AS OBVIOUS]

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index b847bbc..278a22c 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -87,8 +87,6 @@ source "drivers/usb/storage/Kconfig"
 
 source "drivers/usb/image/Kconfig"
 
-source "drivers/usb/net/Kconfig"
-
 source "drivers/usb/mon/Kconfig"
 
 comment "USB port drivers"
diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index 0ef090b..72464b5 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -23,13 +23,6 @@ obj-$(CONFIG_USB_PRINTER)	+= class/
 obj-$(CONFIG_USB_STORAGE)	+= storage/
 obj-$(CONFIG_USB)		+= storage/
 
-obj-$(CONFIG_USB_CATC)		+= net/
-obj-$(CONFIG_USB_KAWETH)	+= net/
-obj-$(CONFIG_USB_PEGASUS)	+= net/
-obj-$(CONFIG_USB_RTL8150)	+= net/
-obj-$(CONFIG_USB_USBNET)	+= net/
-obj-$(CONFIG_USB_ZD1201)	+= net/
-
 obj-$(CONFIG_USB_MDC800)	+= image/
 obj-$(CONFIG_USB_MICROTEK)	+= image/
 
[SNIP REMOVE PATCHES AS OBVIOUS]
