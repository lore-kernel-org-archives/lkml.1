Return-Path: <linux-kernel-owner+w=401wt.eu-S1761307AbZBMBeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307AbZBMBeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 20:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbZBMBdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 20:33:50 -0500
Received: from kroah.org ([198.145.64.141]:58465 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754487AbZBMBdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 20:33:49 -0500
Date: Thu, 12 Feb 2009 17:32:06 -0800
From: Greg KH <greg@kroah.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.27.17
Message-ID: <20090213013206.GB14377@kroah.com>
References: <20090213013157.GA14377@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090213013157.GA14377@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index d398828..104fb0f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .16
+EXTRAVERSION = .17
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index eab790f..e28469e 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -691,14 +691,8 @@ fdd_out:
 static ssize_t show_docked(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
-	struct acpi_device *tmp;
-
-	struct dock_station *dock_station = *((struct dock_station **)
-		dev->platform_data);
+	return snprintf(buf, PAGE_SIZE, "%d\n", dock_present(dock_station));
 
-	if (ACPI_SUCCESS(acpi_bus_get_device(dock_station->handle, &tmp)))
-		return snprintf(buf, PAGE_SIZE, "1\n");
-	return snprintf(buf, PAGE_SIZE, "0\n");
 }
 static DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
 
