Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZLITZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZLITZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbZLITZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:25:27 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:52776 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424AbZLITZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:25:19 -0500
Date: Wed, 9 Dec 2009 20:25:23 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 10/12] drivers/usb: Correct size given to memset
Message-ID: <Pine.LNX.4.64.0912092025050.1870@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/usb/gadget/f_mass_storage.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2675,7 +2675,7 @@ static struct fsg_common *fsg_common_ini
 			return ERR_PTR(-ENOMEM);
 		common->free_storage_on_release = 1;
 	} else {
-		memset(common, 0, sizeof common);
+		memset(common, 0, sizeof *common);
 		common->free_storage_on_release = 0;
 	}
 
