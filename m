Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443Ab0AWA06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab0AWA06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070Ab0AWA0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:26:11 -0500
Received: from kroah.org ([198.145.64.141]:35041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab0AWASt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:18:49 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jan 22 16:11:11 2010
Message-Id: <20100123001111.635592616@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jan 2010 16:09:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [11/29] USB: fix bitmask merge error
In-Reply-To: <20100123001145.GA7391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit a91b593edd4b3e8aa91f671b763b27b8119eb49d upstream.

This patch adds a mask bit which was mistakenly omitted from the
as1311 patch (usb-storage: add BAD_SENSE flag).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -430,7 +430,8 @@ static void adjust_quirks(struct us_data
 	u16 vid = le16_to_cpu(us->pusb_dev->descriptor.idVendor);
 	u16 pid = le16_to_cpu(us->pusb_dev->descriptor.idProduct);
 	unsigned f = 0;
-	unsigned int mask = (US_FL_SANE_SENSE | US_FL_FIX_CAPACITY |
+	unsigned int mask = (US_FL_SANE_SENSE | US_FL_BAD_SENSE |
+			US_FL_FIX_CAPACITY |
 			US_FL_CAPACITY_HEURISTICS | US_FL_IGNORE_DEVICE |
 			US_FL_NOT_LOCKABLE | US_FL_MAX_SECTORS_64 |
 			US_FL_CAPACITY_OK | US_FL_IGNORE_RESIDUE |


