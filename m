Return-Path: <linux-kernel-owner+w=401wt.eu-S932947AbZKXNnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947AbZKXNnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 08:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932912AbZKXNnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 08:43:32 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:65060 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbZKXNnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 08:43:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=j1UQAG/2PkNv7ZtyUqYALW5ve5bZ3ElNahDkHxBO3RpUhF/OYUzP2b7LMavPJLvgjf
         8zn5MW+6C5eF8vlVTCa0h63Uaqo3IHmxVLfAUgE6K9rI0poWpij/4ajuVB+p6jfuMaSB
         TbdmJ1fp0PR5qUOsPPWVzsGQVPHSGF0aYbR5Y=
Date: Tue, 24 Nov 2009 21:47:54 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "xgr178" <xgr178@163.com>, "Jiri Kosina" <jkosina@suse.cz>,
       "qingshenlwy" <qingshenlwy@tom.com>
Subject: [PATCH]irq/core:Add a length limitation
Message-ID: <200911242147508598860@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the register_handler_proc(), the max length of irqaction->name is MAX_NAMELEN.
And this function will call name_unique() to compare name with other irqs'.
There is no any code for limitation the length.
I add a warning in the function to notice that the irqaction->name is too long.

Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
---
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 0832145..9ab6e04 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -196,6 +196,9 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 	char name [MAX_NAMELEN];
 	struct irq_desc *desc = irq_to_desc(irq);
 
+	if(strlen(action->name) >= MAX_NAMELEN)
+		WARN_ON(1);
+
 	if (!desc->dir || action->dir || !action->name ||
 					!name_unique(irq, action))
 		return;
---

Best Regards,
Liuweni
2009-11-24

