Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbZL3GTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbZL3GTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 01:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZL3GTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 01:19:38 -0500
Received: from vms173015pub.verizon.net ([206.46.173.15]:49092 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbZL3GTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 01:19:38 -0500
Date: Wed, 30 Dec 2009 01:19:12 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Paul Rolland <rol@as2917.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rol@witbe.net,
       werner <w.landgraf@ru.ru>, linux-acpi@vger.kernel.org
Subject: [PATCH] wmi: check find_guid() return value to prevent oops
In-reply-to: <20091228175301.4e89aa65@tux.DEF.witbe.net>
Message-id: <alpine.LFD.2.00.0912300116430.15839@localhost.localdomain>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
 <20091225102731.GA25513@elte.hu>
 <alpine.LFD.2.00.0912261504460.4089@localhost.localdomain>
 <alpine.LFD.2.00.0912262316530.14053@localhost.localdomain>
 <20091228094444.GG24690@elte.hu> <20091228120125.GA10911@elte.hu>
 <20091228160212.1f70d825@tux.DEF.witbe.net>
 <20091228175301.4e89aa65@tux.DEF.witbe.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: rol@as2917.net <Paul Rolland>

Signed-off-by: rol@as2917.net <Paul Rolland>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/platform/x86/wmi.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 9f93d6c..cc9ad74 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -492,8 +492,7 @@ wmi_notify_handler handler, void *data)
 	if (!guid || !handler)
 		return AE_BAD_PARAMETER;
 
-	find_guid(guid, &block);
-	if (!block)
+	if (!find_guid(guid, &block))
 		return AE_NOT_EXIST;
 
 	if (block->handler)
@@ -521,8 +520,7 @@ acpi_status wmi_remove_notify_handler(const char *guid)
 	if (!guid)
 		return AE_BAD_PARAMETER;
 
-	find_guid(guid, &block);
-	if (!block)
+	if (!find_guid(guid, &block))
 		return AE_NOT_EXIST;
 
 	if (!block->handler)
-- 
1.6.6.rc4.11.g129a5

