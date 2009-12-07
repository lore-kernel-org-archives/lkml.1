Return-Path: <linux-kernel-owner+w=401wt.eu-S934435AbZLGA0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435AbZLGA0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:26:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934412AbZLGA0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:26:36 -0500
Received: from kroah.org ([198.145.64.141]:34463 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758508AbZLGANR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:17 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:50 2009
Message-Id: <20091207000650.636746886@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <len.brown@intel.com>
Subject: [059/119] thinkpad-acpi: fix sign of ERESTARTSYS return
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=thinkpad-acpi-fix-sign-of-erestartsys-return.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roel Kluin <roel.kluin@gmail.com>

commit 80a8d1228e90349b4514e8c925c061fa5cbcea75 upstream.

The returned error should be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5863,7 +5863,7 @@ static int brightness_write(char *buf)
 	 * Doing it this way makes the syscall restartable in case of EINTR
 	 */
 	rc = brightness_set(level);
-	return (rc == -EINTR)? ERESTARTSYS : rc;
+	return (rc == -EINTR)? -ERESTARTSYS : rc;
 }
 
 static struct ibm_struct brightness_driver_data = {


