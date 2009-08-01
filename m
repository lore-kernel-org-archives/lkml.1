Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbZHAHzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbZHAHzB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZHAHy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:54:56 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:38931 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbZHAHyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=Bppv7Sjw1fdNTtef85f3GLE+cdWX6YHBpfxr6UCEFIg0abBAuSi/AUBZ61dYuJCl5d
         z3RGWSZfXYdreri9F2Y/wYfLWelV3q3Et6wHX48ShFxpzolED9ZgN+F0g0o2yak+7YVK
         XGPtnZWb0HqKd1YTT5xpLcM1pPtoZhzehEj6M=
Message-Id: <20090801075435.769301745@openvz.org>
User-Agent: quilt/0.47-1
Date: Sat, 01 Aug 2009 11:48:00 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: yinghai@kernel.org, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 2/2] x86,ioapic: throw BUG instead of NULL dereference
References: <20090801074758.502095557@openvz.org>
Content-Disposition: inline; filename=x86-ioapic-NULL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of plain NULL deref we better throw error
message with a backtrace. Actually we need more
gracious error handling here. Meanwhile leave it
as is.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/io_apic.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
@@ -503,6 +503,10 @@ static void add_pin_to_irq_node(struct i
 	}
 
 	entry = get_one_free_irq_2_pin(node);
+	if (!entry) {
+		printk(KERN_ERR "can not alloc irq_pin_list\n");
+		BUG_ON(1);
+	}
 	entry->apic = apic;
 	entry->pin = pin;
 

