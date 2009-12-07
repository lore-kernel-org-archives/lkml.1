Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbZLGASv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbZLGASv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758683AbZLGASs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:18:48 -0500
Received: from kroah.org ([198.145.64.141]:34724 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758600AbZLGANy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:54 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:58 2009
Message-Id: <20091207000658.114369182@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Hans de Goede <hdegoede@redhat.com>,
       Jordan Crouse <jordan@cosmicpenguin.net>
Subject: [099/119] hwmon: (adt7475) Fix temperature fault flags
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=hwmon-adt7475-fix-temperature-fault-flags.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

commit cf312e077662ec3a07529551ab6e885828ccfb1d upstream.

The logic of temperature fault flags is wrong, it shows faults when
there are none and vice versa. Fix it.

I can't believe this has been broken since the driver was added, 8
months ago, basically breaking temp1 and temp3, and nobody ever
complained.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/adt7475.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -350,8 +350,7 @@ static ssize_t show_temp(struct device *
 
 	case FAULT:
 		/* Note - only for remote1 and remote2 */
-		out = data->alarms & (sattr->index ? 0x8000 : 0x4000);
-		out = out ? 0 : 1;
+		out = !!(data->alarms & (sattr->index ? 0x8000 : 0x4000));
 		break;
 
 	default:


