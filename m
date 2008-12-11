Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbYLKTaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbYLKTaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbYLKTSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:40 -0500
Received: from kroah.org ([198.145.64.141]:56172 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757604AbYLKTSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:36 -0500
Date: Thu, 11 Dec 2008 11:14:50 -0800
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
       alan@lxorguk.ukuu.org.uk,
       =?iso-8859-1?B?RnLDqWTDqXJpYw==?= Marchal 
	<frederic.marchal@wowcompany.com>,
       Phil Dibowitz <phil@ipom.com>
Subject: [patch 35/83] USB: Unusual dev for Mio moov 330 gps
Message-ID: <20081211191450.GI5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="usb-unusual-dev-for-mio-moov-330-gps.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frédéric Marchal <frederic.marchal@wowcompany.com>

commit e8fab4ce763c36869624c5388714ff19c30a91a7 upstream

Here is an entry for the unusual_devs.h file to handle a Mio Moov 330 GPS that
stops responding when it is requested to transfer more than 64KB. The patch is
taken against kernel-2.6.27-git3.

Signed-off-by: Frédéric Marchal <frederic.marchal@wowcompany.com>
Signed-off-by: Phil Dibowitz <phil@ipom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/storage/unusual_devs.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2069,6 +2069,15 @@ UNUSUAL_DEV(  0x2770, 0x915d, 0x0010, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_FIX_CAPACITY ),
 
+/* Reported by Frederic Marchal <frederic.marchal@wowcompany.com>
+ * Mio Moov 330
+ */
+UNUSUAL_DEV(  0x3340, 0xffff, 0x0000, 0x0000,
+		"Mitac",
+		"Mio DigiWalker USB Sync",
+		US_SC_DEVICE,US_PR_DEVICE,NULL,
+		US_FL_MAX_SECTORS_64 ),
+
 /* Reported by Andrey Rahmatullin <wrar@altlinux.org> */
 UNUSUAL_DEV(  0x4102, 0x1020, 0x0100,  0x0100,
 		"iRiver",

