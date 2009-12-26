Return-Path: <linux-kernel-owner+w=401wt.eu-S1751519AbZLZETh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbZLZETh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 23:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZLZETg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 23:19:36 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:35425 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZLZETf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 23:19:35 -0500
Date: Fri, 25 Dec 2009 23:18:57 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: werner <w.landgraf@ru.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: kernel problem 2.6.33-rc2
In-reply-to: <web-122887026@zbackend1.aha.ru>
Message-id: <alpine.LFD.2.00.0912252318090.4046@localhost.localdomain>
References: <web-122887026@zbackend1.aha.ru>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> dell_wmi_init

Please try this patch.

>From d11e073ee3e3091d9190dace97ce480e960cca1b Mon Sep 17 00:00:00 2001
From: Len Brown <len.brown@intel.com>
Date: Fri, 25 Dec 2009 23:14:26 -0500
Subject: [PATCH] Revert "wmi: Free the allocated acpi objects through wmi_get_event_data"
X-Patchwork-Hint: ignore

This reverts commit 3e9b988e4edf065d39c1343937f717319b1c1065.

Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>
Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/platform/x86/dell-wmi.c |    1 -
 drivers/platform/x86/hp-wmi.c   |    2 --
 drivers/platform/x86/wmi.c      |    4 ++--
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 916ccb2..46244c6 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -238,7 +238,6 @@ static void dell_wmi_notify(u32 value, void *context)
 			input_sync(dell_wmi_input_dev);
 		}
 	}
-	kfree(obj);
 }
 
 
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 8781d8f..222ab57 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -388,8 +388,6 @@ static void hp_wmi_notify(u32 value, void *context)
 	} else
 		printk(KERN_INFO "HP WMI: Unknown key pressed - %x\n",
 			eventcode);
-
-	kfree(obj);
 }
 
 static int __init hp_wmi_input_setup(void)
diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 9f93d6c..e425a86 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -540,8 +540,8 @@ EXPORT_SYMBOL_GPL(wmi_remove_notify_handler);
 /**
  * wmi_get_event_data - Get WMI data associated with an event
  *
- * @event: Event to find
- * @out: Buffer to hold event data. out->pointer should be freed with kfree()
+ * @event - Event to find
+ * &out - Buffer to hold event data
  *
  * Returns extra data associated with an event in WMI.
  */
-- 
1.6.6.rc4.11.g129a5

