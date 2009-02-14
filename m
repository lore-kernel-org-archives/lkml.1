Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbZBNBpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbZBNBpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:45:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762305AbZBNBQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:53 -0500
Received: from kroah.org ([198.145.64.141]:50709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762612AbZBNBQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:41 -0500
Date: Fri, 13 Feb 2009 17:13:45 -0800
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
       alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>
Subject: [patch 42/48] HID: adjust report descriptor fixup for MS 1028
	receiver
Message-ID: <20090214011345.GQ17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hid-adjust-report-descriptor-fixup-for-ms-1028-receiver.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 0fb21de0799a985d2da3da14ae5625d724256638 upstream.

Report descriptor fixup for MS 1028 receiver changes also values for
Keyboard and Consumer, which incorrectly trims the range, causing correct
events being thrown away before passing to userspace.

We need to keep the GenDesk usage fixup though, as it reports totally bogus
values about axis.

Reported-by: Lucas Gadani <lgadani@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-microsoft.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -30,7 +30,7 @@
 #define MS_NOGET	0x10
 
 /*
- * Microsoft Wireless Desktop Receiver (Model 1028) has several
+ * Microsoft Wireless Desktop Receiver (Model 1028) has
  * 'Usage Min/Max' where it ought to have 'Physical Min/Max'
  */
 static void ms_report_fixup(struct hid_device *hdev, __u8 *rdesc,
@@ -38,17 +38,12 @@ static void ms_report_fixup(struct hid_d
 {
 	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
 
-	if ((quirks & MS_RDESC) && rsize == 571 && rdesc[284] == 0x19 &&
-			rdesc[286] == 0x2a && rdesc[304] == 0x19 &&
-			rdesc[306] == 0x29 && rdesc[352] == 0x1a &&
-			rdesc[355] == 0x2a && rdesc[557] == 0x19 &&
+	if ((quirks & MS_RDESC) && rsize == 571 && rdesc[557] == 0x19 &&
 			rdesc[559] == 0x29) {
 		dev_info(&hdev->dev, "fixing up Microsoft Wireless Receiver "
 				"Model 1028 report descriptor\n");
-		rdesc[284] = rdesc[304] = rdesc[557] = 0x35;
-		rdesc[352] = 0x36;
-		rdesc[286] = rdesc[355] = 0x46;
-		rdesc[306] = rdesc[559] = 0x45;
+		rdesc[557] = 0x35;
+		rdesc[559] = 0x45;
 	}
 }
 

