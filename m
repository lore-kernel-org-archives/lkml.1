Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847Ab0ACN17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab0ACN17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 08:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570Ab0ACN16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 08:27:58 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:65237 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0ACN15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 08:27:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=vzYb0nI+bBzrZ4AsmsBu5JeZcgXToo9D6F1Y0ytKVnzXB8VTCkYWNxiULvoX7W331Q
         5QNUcxb7zhnmcrgVf6mPcRCA6am6yG3B6cUXwYuAKPzZ/LbtW9U6am9HHzkoX7DFYtg4
         orWueapkG0YSlwUloHUiMnDb1u5gWfkx/mmLE=
MIME-Version: 1.0
Date: Sun, 3 Jan 2010 19:27:56 +0600
Message-ID: <b9df5fa11001030527h71b66dbcgd4ef29c04545cdaf@mail.gmail.com>
Subject: [PATCH] acpi: Fix unused variable warning in sbs.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fix unused variabled warning.

When CONFIG_ACPI_SYSFS_POWER=n and CONFIG_ACPI_PROCFS_POWER=n, then
we're warned by the following warning:

drivers/acpi/sbs.c: In function `acpi_battery_remove':
drivers/acpi/sbs.c:825: warning: unused variable `battery'


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/drivers/acpi/sbs.c	2009-12-28 12:37:29.000000000 +0600
+++ rakib/drivers/acpi/sbs.c	2010-01-03 11:29:07.000000000 +0600
@@ -822,7 +822,10 @@ static int acpi_battery_add(struct acpi_

 static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
 {
+#if defined(CONFIG_ACPI_SYSFS_POWER) || defined(CONFIG_ACPI_PROCFS_POWER)
 	struct acpi_battery *battery = &sbs->battery[id];
+#endif
+
 #ifdef CONFIG_ACPI_SYSFS_POWER
 	if (battery->bat.dev) {
 		if (battery->have_sysfs_alarm)
