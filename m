Return-Path: <linux-kernel-owner+w=401wt.eu-S932872AbZD3R3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872AbZD3R3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764647AbZD3RIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:08:06 -0400
Received: from kroah.org ([198.145.64.141]:56609 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764627AbZD3RH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:07:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Apr 30 09:57:45 2009
Message-Id: <20090430165745.480231629@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 30 Apr 2009 09:56:37 -0700
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 48/88] USB: usb-storage: augment unusual_devs entry for Simple Tech/Datafab
References: <20090430165549.117010404@mini.kroah.org>
Content-Disposition: inline; filename=0080-USB-usb-storage-augment-unusual_devs-entry-for-Sim.patch
In-Reply-To: <20090430170122.GA16015@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

upstream commit: e4813eec8d47c8299d968bd5349dc881fa481c26

This patch (as1227) adds the MAX_SECTORS_64 flag to the unusual_devs
entry for the Simple Tech/Datafab controller.  This fixes Bugzilla
#12882.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: binbin <binbinsh@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/storage/unusual_devs.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1164,12 +1164,14 @@ UNUSUAL_DEV(  0x07c4, 0xa400, 0x0000, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_INQUIRY ),
 
-/* Reported by Rauch Wolke <rauchwolke@gmx.net> */
+/* Reported by Rauch Wolke <rauchwolke@gmx.net>
+ * and augmented by binbin <binbinsh@gmail.com> (Bugzilla #12882)
+ */
 UNUSUAL_DEV(  0x07c4, 0xa4a5, 0x0000, 0xffff,
 		"Simple Tech/Datafab",
 		"CF+SM Reader",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_IGNORE_RESIDUE ),
+		US_FL_IGNORE_RESIDUE | US_FL_MAX_SECTORS_64 ),
 
 /* Casio QV 2x00/3x00/4000/8000 digital still cameras are not conformant
  * to the USB storage specification in two ways:


