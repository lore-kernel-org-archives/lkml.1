Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbZHMUMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbZHMUMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbZHMUME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:12:04 -0400
Received: from kroah.org ([198.145.64.141]:41700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbZHMT72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:27 2009
Message-Id: <20090813195127.776055031@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Giacomo Lozito <james@develia.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 22/74] USB: storage: raise timeout in usb_stor_Bulk_max_lun
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=usb-storage-raise-timeout-in-usb_stor_bulk_max_lun.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Giacomo Lozito <james@develia.org>

commit 7a777919bbeec3eac1d7904a728a60e9c2bb9c67 upstream.

Requests to get max LUN, for certain USB storage devices, require a
longer timeout before a correct reply is returned. This happens for a
Realtek USB Card Reader (0bda:0152), which has a max LUN of 3 but is set
to 0, thus losing functionality, because of the timeout occurring too
quickly.

Raising the timeout value fixes the issue and might help other devices
to return a correct max LUN value as well.

Signed-off-by: Giacomo Lozito <james@develia.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -961,7 +961,7 @@ int usb_stor_Bulk_max_lun(struct us_data
 				 US_BULK_GET_MAX_LUN, 
 				 USB_DIR_IN | USB_TYPE_CLASS | 
 				 USB_RECIP_INTERFACE,
-				 0, us->ifnum, us->iobuf, 1, HZ);
+				 0, us->ifnum, us->iobuf, 1, 10*HZ);
 
 	US_DEBUGP("GetMaxLUN command result is %d, data is %d\n", 
 		  result, us->iobuf[0]);


