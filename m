Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbZCNB1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbZCNB1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZCNBUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:11 -0400
Received: from kroah.org ([198.145.64.141]:34922 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752842AbZCNBUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:02 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:34 2009
Message-Id: <20090314011034.336748926@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:57 -0700
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 020/114] USB: usb-storage: add IGNORE_RESIDUE flag for Genesys Logic adapters
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=usb-usb-storage-add-ignore_residue-flag-for-genesys-logic-adapters.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 5126a2674ddac0804450f59da25a058cca629d38 upstream.

This patch (as1219) adds the IGNORE_RESIDUE flag to the unusual_devs
entries for Genesys Logic's USB-IDE adapter.  Although this device
usually gets the residue correct, there is one command crucial to the
operation of CD and DVD drives which it messes up.

Tested-by: Mike Lampard <mike@mtgambier.net>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/unusual_devs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -876,13 +876,13 @@ UNUSUAL_DEV(  0x05e3, 0x0701, 0x0000, 0x
 		"Genesys Logic",
 		"USB to IDE Optical",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_GO_SLOW | US_FL_MAX_SECTORS_64 ),
+		US_FL_GO_SLOW | US_FL_MAX_SECTORS_64 | US_FL_IGNORE_RESIDUE ),
 
 UNUSUAL_DEV(  0x05e3, 0x0702, 0x0000, 0xffff,
 		"Genesys Logic",
 		"USB to IDE Disk",
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_GO_SLOW | US_FL_MAX_SECTORS_64 ),
+		US_FL_GO_SLOW | US_FL_MAX_SECTORS_64 | US_FL_IGNORE_RESIDUE ),
 
 /* Reported by Hanno Boeck <hanno@gmx.de>
  * Taken from the Lycoris Kernel */


