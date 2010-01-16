Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0APP7a (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 10:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063Ab0APP7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 10:59:25 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44194 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab0APP7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 10:59:24 -0500
Date: Sat, 16 Jan 2010 16:59:22 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 6/9] drivers/staging/go7007: Eliminate useless code
Message-ID: <Pine.LNX.4.64.1001161659000.28745@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable s is initialized twice to the same (side effect-free)
expression.  Drop one initialization.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/go7007/s2250-loader.c          |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/go7007/s2250-loader.c b/drivers/staging/go7007/s2250-loader.c
index c152ab9..d9a3278 100644
--- a/drivers/staging/go7007/s2250-loader.c
+++ b/drivers/staging/go7007/s2250-loader.c
@@ -139,9 +139,9 @@ failed2:
 
 static void s2250loader_disconnect(struct usb_interface *interface)
 {
-	pdevice_extension_t s = usb_get_intfdata(interface);
+	pdevice_extension_t s;
 	printk(KERN_INFO "s2250: disconnect\n");
 	lock_kernel();
 	s = usb_get_intfdata(interface);
