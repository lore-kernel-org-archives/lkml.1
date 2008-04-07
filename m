Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbYDGI7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbYDGI7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbYDGI7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:59:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51208 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755474AbYDGI7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:59:08 -0400
Message-ID: <47F9E1E2.5020506@cn.fujitsu.com>
Date: Mon, 07 Apr 2008 16:57:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: lenb@kernel.org
CC: linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: check a return value correctly in acpi_power_get_context()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should check *resource != NULL rather than resource != NULL,
which will be always true.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 drivers/acpi/power.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 76bf6d9..f2a76ac 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -121,7 +121,7 @@ acpi_power_get_context(acpi_handle handle,
 	}
 
 	*resource = acpi_driver_data(device);
-	if (!resource)
+	if (!*resource)
 		return -ENODEV;
 
 	return 0;
-- 
1.5.4.rc3

