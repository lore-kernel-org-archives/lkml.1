Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbYLKTa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbYLKTa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbYLKTSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:41 -0500
Received: from kroah.org ([198.145.64.141]:56185 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757629AbYLKTSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:37 -0500
Date: Thu, 11 Dec 2008 11:14:52 -0800
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
       alan@lxorguk.ukuu.org.uk, Jens Taprogge <jens.taprogge@taprogge.org>,
       Alan Stern <stern@rowland.harvard.edu>, Phil Dibowitz <phil@ipom.com>
Subject: [patch 36/83] USB: Unusual dev for the "Kyocera / Contax SL300R
	T*" digital camera.
Message-ID: <20081211191452.GJ5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-unusual-dev-for-the-kyocera-contax-sl300r-t-digital-camera.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jens Taprogge <jens.taprogge@taprogge.org>

commit 74511bb340059be5a3fceb032213c7f325344694 upstream

The camera reports an incorrect size and fails to handle PREVENT-ALLOW
MEDIUM REMOVAL commands.  The patch marks the camera as an unusual dev
and adds the flags to enable the workarounds for both shortcomings.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Phil Dibowitz <phil@ipom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -333,6 +333,13 @@ UNUSUAL_DEV(  0x0482, 0x0103, 0x0100, 0x
 		"Finecam S5",
 		US_SC_DEVICE, US_PR_DEVICE, NULL, US_FL_FIX_INQUIRY),
 
+/* Patch submitted by Jens Taprogge <jens.taprogge@taprogge.org> */
+UNUSUAL_DEV(  0x0482, 0x0107, 0x0100, 0x0100,
+		"Kyocera",
+		"CONTAX SL300R T*",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY | US_FL_NOT_LOCKABLE),
+
 /* Reported by Paul Stewart <stewart@wetlogic.net>
  * This entry is needed because the device reports Sub=ff */
 UNUSUAL_DEV(  0x04a4, 0x0004, 0x0001, 0x0001,

