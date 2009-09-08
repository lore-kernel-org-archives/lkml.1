Return-Path: <linux-kernel-owner+w=401wt.eu-S1751681AbZIHTJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbZIHTJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZIHTJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:09:47 -0400
Received: from mail.atheros.com ([12.36.123.2]:65277 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbZIHTJq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:09:46 -0400
Date: Tue, 8 Sep 2009 12:09:47 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "aquilaver@yahoo.com" <aquilaver@yahoo.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dan Williams <dcbw@redhat.com>, Kai Engert <kengert@redhat.com>,
       Jean Tourrilhes <jt@hpl.hp.com>, Tim de Waal <tim.dewaal@yahoo.com>,
       Roy Marples <uberlord@gentoo.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christian Lamparter <chunkeey@web.de>,
       =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Tim Gardner <tim.gardner@canonical.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] wireless: mark prism54 as deprecated and mark for
 removal
Message-ID: <20090908190947.GA9358@mosca>
References: <1251819116-10004-1-git-send-email-lrodriguez@atheros.com>
 <4A9D469B.9060005@lwfinger.net>
 <20090901161513.GD8261@mosca>
 <20090908183337.GD2617@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090908183337.GD2617@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 11:33:37AM -0700, John W. Linville wrote:
> On Tue, Sep 01, 2009 at 09:15:13AM -0700, Luis R. Rodriguez wrote:
> > On Tue, Sep 01, 2009 at 09:06:51AM -0700, Larry Finger wrote:
> 
> > > Otherwise, ACK.
> >
> > Thanks for the review, will resend with the changes.
> >
> >   Luis
> 
> Ahem? :-)

Thanks for the poke, here it is:

From: Luis R. Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH] wireless: mark prism54 as deprecated and mark for removal

The preferred module is p54pci which also supports FullMAC
PCI / Cardbus devices. We schedule removal for 2.6.34. Reason
to remove this is no one really is testing prism54 anymore,
and while it works p54pci provides support for the same hardware.
It should be noted I have been told some FullMAC devices may not
have worked with the SoftMAC driver but to date we have yet to
recieve a single bug report regarding this. If there are users
out there please let us know!

Cc: aquilaver@yahoo.com
Cc: linux-kernel@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>
Cc: Kai Engert <kengert@redhat.com>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Tim de Waal<tim.dewaal@yahoo.com>
Cc: Roy Marples <uberlord@gentoo.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christian Lamparter <chunkeey@web.de>
Cc: Björn Steinbrink <B.Steinbrink@gmx.de>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 Documentation/feature-removal-schedule.txt |   29 ++++++++++++++
 drivers/net/wireless/Kconfig               |   57 ++++++++--------------------
 2 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 09e031c..ad522e3 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,6 +6,35 @@ be removed from this file.
 
 ---------------------------
 
+What:	PRISM54
+When:	2.6.34
+
+Why:	prism54 FullMAC PCI / Cardbus devices used to be supported only by the
+	prism54 wireless driver. After Intersil stopped selling these
+	devices in preference for the newer more flexible SoftMAC devices
+	a SoftMAC device driver was required and prism54 did not support
+	them. The p54pci driver now exists and has been present in the kernel for
+	a while. This driver supports both SoftMAC devices and FullMAC devices.
+	The main difference between these devices was the amount of memory which
+	could be used for the firmware. The SoftMAC devices support a smaller
+	amount of memory. Because of this the SoftMAC firmware fits into FullMAC
+	devices's memory. p54pci supports not only PCI / Cardbus but also USB
+	and SPI. Since p54pci supports all devices prism54 supports
+	you will have a conflict. I'm not quite sure how distributions are
+	handling this conflict right now. prism54 was kept around due to
+	claims users may experience issues when using the SoftMAC driver.
+	Time has passed users have not reported issues. If you use prism54
+	and for whatever reason you cannot use p54pci please let us know!
+	E-mail us at: linux-wireless@vger.kernel.org
+
+	For more information see the p54 wiki page:
+
+	http://wireless.kernel.org/en/users/Drivers/p54
+
+Who:	Luis R. Rodriguez <lrodriguez@atheros.com>
+
+---------------------------
+
 What:	IRQF_SAMPLE_RANDOM
 Check:	IRQF_SAMPLE_RANDOM
 When:	July 2009
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index a8871a8..ad89d23 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -275,51 +275,26 @@ config PCMCIA_WL3501
 	 micro support for ethtool.
 
 config PRISM54
-	tristate 'Intersil Prism GT/Duette/Indigo PCI/Cardbus' 
+	tristate 'Intersil Prism GT/Duette/Indigo PCI/Cardbus (DEPRECATED)'
 	depends on PCI && EXPERIMENTAL && WLAN_80211
 	select WIRELESS_EXT
 	select FW_LOADER
 	---help---
-	  Enable PCI and Cardbus support for the following chipset based cards:
-
-	  ISL3880 - Prism GT            802.11 b/g
-	  ISL3877 - Prism Indigo        802.11 a
-	  ISL3890 - Prism Duette        802.11 a/b/g
-	  
-	  For a complete list of supported cards visit <http://prism54.org>.
-	  Here is the latest confirmed list of supported cards:
-
-	  3com OfficeConnect 11g Cardbus Card aka 3CRWE154G72 (version 1)
-	  Allnet ALL0271 PCI Card
-	  Compex WL54G Cardbus Card
-	  Corega CG-WLCB54GT Cardbus Card
-	  D-Link Air Plus Xtreme G A1 Cardbus Card aka DWL-g650
-	  I-O Data WN-G54/CB Cardbus Card
-	  Kobishi XG-300 aka Z-Com Cardbus Card
-	  Netgear WG511 Cardbus Card
-	  Ovislink WL-5400PCI PCI Card
-	  Peabird WLG-PCI PCI Card
-	  Sitecom WL-100i Cardbus Card
-	  Sitecom WL-110i PCI Card
-	  SMC2802W -    EZ Connect g 2.4GHz 54 Mbps Wireless PCI Card
-	  SMC2835W -    EZ Connect g 2.4GHz 54 Mbps Wireless Cardbus Card
-	  SMC2835W-V2 - EZ Connect g 2.4GHz 54 Mbps Wireless Cardbus Card
-	  Z-Com XG-900 PCI Card
-	  Zyxel G-100 Cardbus Card
-
-	  If you enable this you will need a firmware file as well.
-	  You will need to copy this to /usr/lib/hotplug/firmware/isl3890.
-	  You can get this non-GPL'd firmware file from the Prism54 project page:
-	  <http://prism54.org>
-	  You will also need the /etc/hotplug/firmware.agent script from
-	  a current hotplug package.
-
-	  Note: You need a motherboard with DMA support to use any of these cards 
-	  
-	  If you want to compile the driver as a module ( = code which can be
-	  inserted in and removed from the running kernel whenever you want),
-	  say M here and read <file:Documentation/kbuild/modules.txt>.
-	  The module will be called prism54.
+	  This enables support for FullMAC PCI/Cardbus prism54 devices. This
+	  driver is now deprecated in favor for the SoftMAC driver, p54pci.
+	  p54pci supports FullMAC PCI/Cardbus devices as well. For details on
+	  the scheduled removal of this driver on the kernel see the feature
+	  removal schedule:
+
+	  Documentation/feature-removal-schedule.txt
+
+	  For more information refer to the p54 wiki:
+
+	  http://wireless.kernel.org/en/users/Drivers/p54
+
+	  Note: You need a motherboard with DMA support to use any of these cards
+
+	  When built as module you get the module prism54
 
 config USB_ZD1201
 	tristate "USB ZD1201 based Wireless device support"
-- 
1.6.3.3

