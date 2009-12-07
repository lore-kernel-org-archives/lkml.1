Return-Path: <linux-kernel-owner+w=401wt.eu-S1758774AbZLGASQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774AbZLGASQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758676AbZLGARs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:17:48 -0500
Received: from kroah.org ([198.145.64.141]:34732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606AbZLGANz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:58 2009
Message-Id: <20091207000658.315298898@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Hans de Goede <hdegoede@redhat.com>,
       Jordan Crouse <jordan@cosmicpenguin.net>
Subject: [100/119] hwmon: (adt7475) Cache limits for 60 seconds
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=hwmon-adt7475-cache-limits-for-60-seconds.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit 56e35eeebed2dcb4e1a17ad119e039cf095854ac upstream.

The comment says that limits are cached for 60 seconds but the code
actually caches them for only 2 seconds. Align the code on the
comment, as 60 seconds makes more sense.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/adt7475.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -1151,7 +1151,7 @@ static struct adt7475_data *adt7475_upda
 	}
 
 	/* Limits and settings, should never change update every 60 seconds */
-	if (time_after(jiffies, data->limits_updated + HZ * 2) ||
+	if (time_after(jiffies, data->limits_updated + HZ * 60) ||
 	    !data->valid) {
 		data->config5 = adt7475_read(REG_CONFIG5);
 


