Return-Path: <linux-kernel-owner+w=401wt.eu-S1763816AbZCTXd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763816AbZCTXd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762991AbZCTXYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:41 -0400
Received: from kroah.org ([198.145.64.141]:48661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762975AbZCTXYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:39 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:26 2009
Message-Id: <20090320222926.440885637@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Thomas Bartosik <tbartdev@gmx-topmail.de>
Subject: [patch 22/43] USB: storage: Unusual USB device Prolific 2507 variation added
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=usb-storage-unusual-usb-device-prolific-2507-variation-added.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Bartosik <tbartdev@gmx-topmail.de>

commit 8a0845c51b2e300f5204a323b874f7f58ea0eff7 upstream.

The "c-enter" USB to Toshiba 1.8" IDE enclosure needs special treatment
to work flawlessly. This patch is absolutely trivial, as the integrated
USB-IDE bridge is already identified to be an "unusual" device, only the
bcdDevice is different (lower) to the bcdDeviceMin already included in
the kernel.
It is a Prolific 2507 bridge.

T:  Bus=02 Lev=01 Prnt=01 Port=02 Cnt=01 Dev#=  4 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=067b ProdID=2507 Rev= 0.01
S:  Manufacturer=Prolific Technology Inc.
S:  Product=ATAPI-6 Bridge Controller
S:  SerialNumber=00000272
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms


Signed-off-by: Thomas Bartosik <tbartdev@gmx-topmail.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -913,7 +913,9 @@ UNUSUAL_DEV( 0x066f, 0x8000, 0x0001, 0x0
 		US_FL_FIX_CAPACITY ),
 
 /* Reported by Richard -=[]=- <micro_flyer@hotmail.com> */
-UNUSUAL_DEV( 0x067b, 0x2507, 0x0100, 0x0100,
+/* Change to bcdDeviceMin (0x0100 to 0x0001) reported by
+ * Thomas Bartosik <tbartdev@gmx-topmail.de> */
+UNUSUAL_DEV( 0x067b, 0x2507, 0x0001, 0x0100,
 		"Prolific Technology Inc.",
 		"Mass Storage Device",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,


