Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZBPPGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZBPPGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbZBPPFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:05:06 -0500
Received: from cmpxchg.org ([85.214.51.133]:49279 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbZBPPFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:05:05 -0500
Message-Id: <20090216144725.901238204@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Mon, 16 Feb 2009 15:29:31 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 5/8] usb: use kzfree()
References: <20090216142926.440561506@cmpxchg.org>
Content-Disposition: inline; filename=usb-use-kzfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
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
+	kzfree(keyd);
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


