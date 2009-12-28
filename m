Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbZL1JjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbZL1JjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZL1JjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:39:13 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57542 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZL1JjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:39:13 -0500
Date: Mon, 28 Dec 2009 10:34:42 +0100
From: Anisse Astier <anisse@astier.eu>
To: Len Brown <lenb@kernel.org>
Cc: werner <w.landgraf@ru.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: kernel problem 2.6.33-rc2
Message-ID: <20091228103442.318e720c@destiny.ordissimo>
In-Reply-To: <alpine.LFD.2.00.0912252318090.4046@localhost.localdomain>
References: <web-122887026@zbackend1.aha.ru>
	<alpine.LFD.2.00.0912252318090.4046@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Dec 2009 23:18:57 -0500 (EST), Len Brown <lenb@kernel.org> wrote :

> > dell_wmi_init
> 
> Please try this patch.
> 
> From d11e073ee3e3091d9190dace97ce480e960cca1b Mon Sep 17 00:00:00 2001
> From: Len Brown <len.brown@intel.com>
> Date: Fri, 25 Dec 2009 23:14:26 -0500
> Subject: [PATCH] Revert "wmi: Free the allocated acpi objects through wmi_get_event_data"
> X-Patchwork-Hint: ignore
> 
> This reverts commit 3e9b988e4edf065d39c1343937f717319b1c1065.
> 
> Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>
> Tested-by Maciej Rutecki <maciej.rutecki@gmail.com>
> Signed-off-by: Len Brown <len.brown@intel.com>

Hi, please try this patch as well. This should be the proper fix.


From: Anisse Astier <anisse@astier.eu>
Date: Mon, 28 Dec 2009 10:27:30 +0100
Subject: [PATCH] hp-wmi: remove double free

Commit 3e9b988e4edf065d39c1343937f717319b1c1065 had the same purpose as commit
44ef00e6482e755f36629773abc2aee83a6f53e3 .
Signed-off-by: Anisse Astier <anisse@astier.eu>
Reported-by: Sedat Dilek <sedat.dilek@googlemail.com>

---
 drivers/platform/x86/hp-wmi.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

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
-- 
1.6.5.7

