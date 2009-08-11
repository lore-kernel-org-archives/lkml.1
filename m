Return-Path: <linux-kernel-owner+w=401wt.eu-S932118AbZHKUJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbZHKUJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 16:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZHKUJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 16:09:54 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:19195
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752211AbZHKUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 16:09:53 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KO8AOB-01-KBF-02
X-M-MSG: 
From: Mark Langsdorf <mark.langsdorf@amd.com>
To: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       matthew.tippett@amd.com, samuel.li@amd.com
Subject: [PATCH][ACPI] AC/DC notifier
Date: Tue, 11 Aug 2009 15:15:42 -0500
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200908111515.42635.mark.langsdorf@amd.com>
X-OriginalArrivalTime: 11 Aug 2009 20:09:46.0786 (UTC) FILETIME=[AC745020:01CA1ABF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an ACPI event notifier for AC/DC connect/disconnect events.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

---
 drivers/acpi/ac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/acpi/ac.c b/drivers/acpi/ac.c
index 0df8fcb..656b903 100644
--- a/drivers/acpi/ac.c
+++ b/drivers/acpi/ac.c
@@ -243,6 +243,7 @@ static void acpi_ac_notify(struct acpi_device *device, u32 event)
 		acpi_bus_generate_netlink_event(device->pnp.device_class,
 						  dev_name(&device->dev), event,
 						  (u32) ac->state);
+		acpi_notifier_call_chain(device, event, (u32) ac->state);
 #ifdef CONFIG_ACPI_SYSFS_POWER
 		kobject_uevent(&ac->charger.dev->kobj, KOBJ_CHANGE);
 #endif
-- 
1.6.0.2


