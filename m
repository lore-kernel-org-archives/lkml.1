Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936404Ab0CMBWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:22:53 -0500
Received: from kroah.org ([198.145.64.141]:60885 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934780Ab0CMAUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:19 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:10 2010
Message-Id: <20100313001510.686441417@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 063/123] hwmon: (tmp421) Fix temperature conversions
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Jean Delvare <khali@linux-fr.org>

commit a44908d742a577fb5ccb9a8c082326d4cea234c2 upstream.

The low bits of temperature registers are status bits, they must be
masked out before converting the register values to temperatures.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Andre Prendel <andre.prendel@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/tmp421.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -80,14 +80,16 @@ struct tmp421_data {
 
 static int temp_from_s16(s16 reg)
 {
-	int temp = reg;
+	/* Mask out status bits */
+	int temp = reg & ~0xf;
 
 	return (temp * 1000 + 128) / 256;
 }
 
 static int temp_from_u16(u16 reg)
 {
-	int temp = reg;
+	/* Mask out status bits */
+	int temp = reg & ~0xf;
 
 	/* Add offset for extended temperature range. */
 	temp -= 64 * 256;


