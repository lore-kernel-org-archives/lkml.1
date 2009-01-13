Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbZAMBa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbZAMBa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbZAMB25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:28:57 -0500
Received: from kroah.org ([198.145.64.141]:35910 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757043AbZAMB2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:28:55 -0500
Date: Mon, 12 Jan 2009 17:26:54 -0800
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
       alan@lxorguk.ukuu.org.uk, Phil Dibowitz <phil@ipom.com>
Subject: [patch 03/21] USB: storage: unusual_devs.h: Nokia 3109c addition
Message-ID: <20090113012654.GD4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="usb-storage-unusual_devs.h-nokia-3109c-addition.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: CSÉCSY László <boobaa@frugalware.org>

commit 1393fce7189427bdb4d6115ca5566ca8d0fc86f3 upstream.

2.6.26(.x, cannot remember) could handle the microSD card in my Nokia
3109c attached via USB as mass storage, 2.6.27(.x, up to and included
2.6.27.8) cannot. Please find the attached patch which fixes this
regression, and a copy of /proc/bus/usb/devices with my phone plugged in
running with this patch on Frugalware.

T:  Bus=02 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  4 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0421 ProdID=0063 Rev= 6.01
S:  Manufacturer=Nokia
S:  Product=Nokia 3109c
S:  SerialNumber=359561013742570
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

From: CSÉCSY László <boobaa@frugalware.org>
Cc: Phil Dibowitz <phil@ipom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -253,6 +253,13 @@ UNUSUAL_DEV(  0x0421, 0x04fa, 0x0550, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by CSECSY Laszlo <boobaa@frugalware.org> */
+UNUSUAL_DEV(  0x0421, 0x0063, 0x0001, 0x0601,
+		"Nokia",
+		"Nokia 3109c",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY ),
+
 /* Patch for Nokia 5310 capacity */
 UNUSUAL_DEV(  0x0421, 0x006a, 0x0000, 0x0591,
 	"Nokia",

