Return-Path: <linux-kernel-owner+w=401wt.eu-S1751034AbXBUBiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034AbXBUBiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbXBUBiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:38:19 -0500
Received: from ns.suse.de ([195.135.220.2]:42177 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbXBUBiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:38:18 -0500
Date: Tue, 20 Feb 2007 17:36:42 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Grant Likely <grant.likely@secretlab.ca>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 02/21] V4L: Fix quickcam communicator driver for big endian architectures
Message-ID: <20070221013642.GC30227@kroah.com>
References: <20070221012758.925122216@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="V4L-Fix-quickcam-communicator-driver-for-big-endian-architectures.patch"
In-Reply-To: <20070221013619.GA30227@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
Host endianess does not affect the order that pixel rgb data comes
in from the quickcam (the values are bytes, not words or longs).  The
driver is erroniously swapping the order of rgb values for big endian
machines.  This patch is needed get the Quickcam communicator working
on big endian machines (tested on powerpc)

(cherry picked from commit c6d704c8c4453f05717ba88792f70f8babf95268)

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/usbvideo/quickcam_messenger.h |   14 --------------
 1 file changed, 14 deletions(-)

--- linux-2.6.19.4.orig/drivers/media/video/usbvideo/quickcam_messenger.h
+++ linux-2.6.19.4/drivers/media/video/usbvideo/quickcam_messenger.h
@@ -35,27 +35,13 @@ struct rgb {
 };
 
 struct bayL0 {
-#ifdef __BIG_ENDIAN
-	u8 r;
-	u8 g;
-#elif __LITTLE_ENDIAN
 	u8 g;
 	u8 r;
-#else
-#error not byte order defined
-#endif
 };
 
 struct bayL1 {
-#ifdef __BIG_ENDIAN
-	u8 g;
-	u8 b;
-#elif __LITTLE_ENDIAN
 	u8 b;
 	u8 g;
-#else
-#error not byte order defined
-#endif
 };
 
 struct cam_size {

--
