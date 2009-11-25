Return-Path: <linux-kernel-owner+w=401wt.eu-S964784AbZKYOAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbZKYOAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:00:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934617AbZKYOAC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:00:02 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:32854 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZKYOAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:00:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=t4gIpnVxiGPancy2HkAH6QImy7onEJIpeo0/0/tTsaiSPvA8pQVF4P/9WbyxIrc1RK
         0PmMzlWjV1dT0/TlKqb4zPoh1EQW8zo5WHoq2RH3sNqhCKDDBHx4Qp4ENNIK4qiYtB4r
         6ml8KZRj/ypW3GKOZWYs74C522frIpIdosJPo=
Date: Wed, 25 Nov 2009 22:04:20 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "xgr178" <xgr178@163.com>,
       "strongzgy" <strongzgy@gmail.com>, "qingshenlwy" <qingshenlwy@tom.com>,
       "rusty" <rusty@rustcorp.com.au>, "travis" <travis@sgi.com>,
       "adobriyan" <adobriyan@gmail.com>, "tglx" <tglx@linutronix.de>
Subject: [PATCH V2]irq/core: Add a length limitation
Message-ID: <200911252204173129580@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 ---
In this version, I modify the code by Ingo's suggestion, 
and less code add. 
The code will check the irqaction->name's length 
and avoid Using too long name without any notice.
---
Signed-off-by: Liuwenyi<qingshenlwy@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org

---
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 0832145..b91dcb1 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -196,6 +196,8 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
 	char name [MAX_NAMELEN];
 	struct irq_desc *desc = irq_to_desc(irq);
 
+	WARN_ON(strlen(action->name) < MAX_NAMELEN);
+
 	if (!desc->dir || action->dir || !action->name ||
 					!name_unique(irq, action))
 		return;

 				
--------------
Best Regards,
Liuweni
2009-11-25

