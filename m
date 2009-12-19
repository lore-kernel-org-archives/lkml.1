Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbZLSHR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbZLSHR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 02:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZLSHRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 02:17:50 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:34278 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbZLSHRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 02:17:46 -0500
Date: Sat, 19 Dec 2009 08:17:44 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/7] drivers/usb: Use kzalloc for allocating only one thing
Message-ID: <Pine.LNX.4.64.0912190817280.30546@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than kcalloc(1,...)

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- kcalloc(1,
+ kzalloc(
          ...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/host/isp1362-hcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
--- a/drivers/usb/host/isp1362-hcd.c 2009-12-17 08:30:14.000000000 +0100
+++ b/drivers/usb/host/isp1362-hcd.c 2009-12-19 07:52:56.000000000 +0100
@@ -1257,7 +1257,7 @@ static int isp1362_urb_enqueue(struct us
 
 	/* avoid all allocations within spinlocks: request or endpoint */
 	if (!hep->hcpriv) {
-		ep = kcalloc(1, sizeof *ep, mem_flags);
+		ep = kzalloc(sizeof *ep, mem_flags);
 		if (!ep)
 			return -ENOMEM;
 	}
