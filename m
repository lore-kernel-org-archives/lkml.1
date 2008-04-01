Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbYDANGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbYDANGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 09:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYDANGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 09:06:05 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51691 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYDANGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 09:06:03 -0400
Date: Tue, 1 Apr 2008 15:03:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>, marcel@holtmann.org,
       maxk@qualcomm.com
Subject: hci_usb: remove code obfuscation
Message-ID: <20080401130340.GA14103@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_urb_free is an alias for kfree... making code longer & harder to
read. Remove it.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 656540ae9438fac257b4b4a4bb894a47283dc77c
tree f649cf7a5b12a59528bee958998600ca0fe0b054
parent 3bd38b1d2beb30823cb19d8757ee3cd820b49e31
author Pavel <pavel@amd.ucw.cz> Tue, 01 Apr 2008 15:02:59 +0200
committer Pavel <pavel@amd.ucw.cz> Tue, 01 Apr 2008 15:02:59 +0200

 drivers/bluetooth/hci_usb.c |   10 +++++-----
 drivers/bluetooth/hci_usb.h |    5 -----
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
index 99a714a..192522e 100644
--- a/drivers/bluetooth/hci_usb.c
+++ b/drivers/bluetooth/hci_usb.c
@@ -265,7 +265,7 @@ static int hci_usb_intr_rx_submit(struct
 		BT_ERR("%s intr rx submit failed urb %p err %d",
 				husb->hdev->name, urb, err);
 		_urb_unlink(_urb);
-		_urb_free(_urb);
+		kfree(_urb);
 		kfree(buf);
 	}
 	return err;
@@ -302,7 +302,7 @@ static int hci_usb_bulk_rx_submit(struct
 		BT_ERR("%s bulk rx submit failed urb %p err %d",
 				husb->hdev->name, urb, err);
 		_urb_unlink(_urb);
-		_urb_free(_urb);
+		kfree(_urb);
 		kfree(buf);
 	}
 	return err;
@@ -353,7 +353,7 @@ static int hci_usb_isoc_rx_submit(struct
 		BT_ERR("%s isoc rx submit failed urb %p err %d",
 				husb->hdev->name, urb, err);
 		_urb_unlink(_urb);
-		_urb_free(_urb);
+		kfree(_urb);
 		kfree(buf);
 	}
 	return err;
@@ -431,7 +431,7 @@ static void hci_usb_unlink_urbs(struct h
 					husb->hdev->name, _urb, _urb->type, urb);
 			kfree(urb->setup_packet);
 			kfree(urb->transfer_buffer);
-			_urb_free(_urb);
+			kfree(_urb);
 		}
 	}
 }
@@ -490,7 +490,7 @@ static inline int hci_usb_send_ctrl(stru
 
 		dr = kmalloc(sizeof(*dr), GFP_ATOMIC);
 		if (!dr) {
-			_urb_free(_urb);
+			kfree(_urb);
 			return -ENOMEM;
 		}
 	} else
diff --git a/drivers/bluetooth/hci_usb.h b/drivers/bluetooth/hci_usb.h
index 56cd3a9..414080a 100644
--- a/drivers/bluetooth/hci_usb.h
+++ b/drivers/bluetooth/hci_usb.h
@@ -60,11 +60,6 @@ struct _urb {
 	struct urb        urb;
 };
 
-static inline void _urb_free(struct _urb *_urb)
-{
-	kfree(_urb);
-}
-
 static inline void _urb_queue_init(struct _urb_queue *q)
 {
 	INIT_LIST_HEAD(&q->head);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
