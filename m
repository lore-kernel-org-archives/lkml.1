Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521Ab0AEUG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab0AEUG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490Ab0AEUGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:06:17 -0500
Received: from kroah.org ([198.145.64.141]:50005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab0AEUGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:16 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:01 2010
Message-Id: <20100105200301.833920712@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Roel Kluin <roel.kluin@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [22/39] hwmon: (fschmd) Fix check on unsigned in watchdog_write()
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit c7702c31340f84cfd5e5df22293578b7ae1e9370 upstream.

If unsigned the watchdog_trigger() return value will not be
checked correctly.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/fschmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -819,7 +819,7 @@ static int watchdog_release(struct inode
 static ssize_t watchdog_write(struct file *filp, const char __user *buf,
 	size_t count, loff_t *offset)
 {
-	size_t ret;
+	int ret;
 	struct fschmd_data *data = filp->private_data;
 
 	if (count) {


