Return-Path: <linux-kernel-owner+w=401wt.eu-S934998AbZAOWJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934998AbZAOWJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933559AbZAOWCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:08 -0500
Received: from kroah.org ([198.145.64.141]:38169 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758080AbZAOWCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:04 -0500
Date: Thu, 15 Jan 2009 13:59:26 -0800
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
       alan@lxorguk.ukuu.org.uk, Daniel Drake <dsd@gentoo.org>,
       Kadianakis George <desnacked@gmail.com>, Phil Dibowitz <phil@ipom.com>
Subject: [patch 16/85] USB: unusual_devs.h additions for Pentax K10D
Message-ID: <20090115215926.GQ17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-unusual_devs.h-additions-for-pentax-k10d.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daniel Drake <dsd@gentoo.org>

commit e3f47f89a57ef115755184a8b3f03a47ee227418 upstream.

Jaak Ristioja reported problems with his Pentax K10D camera:
https://bugs.gentoo.org/show_bug.cgi?id=250406

/proc/bus/usb/devices:
T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0a17 ProdID=006e Rev= 1.00
S:  Manufacturer=PENTAX Corporation
S:  Product=K10D
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  2mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=  64 Ivl=100ms
The number of reported sectors is off-by-one.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
Cc: Kadianakis George <desnacked@gmail.com>
Signed-off-by: Phil Dibowitz <phil@ipom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1425,6 +1425,13 @@ UNUSUAL_DEV( 0x0a17, 0x006, 0x0000, 0xff
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY ),
 
+/* Reported by Jaak Ristioja <Ristioja@gmail.com> */
+UNUSUAL_DEV( 0x0a17, 0x006e, 0x0100, 0x0100,
+		"Pentax",
+		"K10D",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY ),
+
 /* These are virtual windows driver CDs, which the zd1211rw driver
  * automatically converts into WLAN devices. */
 UNUSUAL_DEV( 0x0ace, 0x2011, 0x0101, 0x0101,

