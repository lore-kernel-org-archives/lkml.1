Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbZBQTp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbZBQTp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbZBQToN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:44:13 -0500
Received: from cmpxchg.org ([85.214.51.133]:38649 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbZBQToM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:44:12 -0500
Message-Id: <20090217184136.097882343@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Tue, 17 Feb 2009 19:26:20 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 5/7] usb: use kzfree()
References: <20090217182615.897042724@cmpxchg.org>
Content-Disposition: inline; filename=usb-use-kzfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/host/hwa-hc.c   |    3 +--
 drivers/usb/wusbcore/cbaf.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/hwa-hc.c
+++ b/drivers/usb/host/hwa-hc.c
@@ -464,8 +464,7 @@ static int __hwahc_dev_set_key(struct wu
 			port_idx << 8 | iface_no,
 			keyd, keyd_len, 1000 /* FIXME: arbitrary */);
 
-	memset(keyd, 0, sizeof(*keyd));	/* clear keys etc. */
-	kfree(keyd);
+	kzfree(keyd); /* clear keys etc. */
 	return result;
 }
 
--- a/drivers/usb/wusbcore/cbaf.c
+++ b/drivers/usb/wusbcore/cbaf.c
@@ -638,8 +638,7 @@ static void cbaf_disconnect(struct usb_i
 	usb_put_intf(iface);
 	kfree(cbaf->buffer);
 	/* paranoia: clean up crypto keys */
-	memset(cbaf, 0, sizeof(*cbaf));
-	kfree(cbaf);
+	kzfree(cbaf);
 }
 
 static struct usb_device_id cbaf_id_table[] = {


