Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbZKDNVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbZKDNVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:21:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580AbZKDNVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:21:02 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:34079 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbZKDNU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:20:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HzdsH6ApntxiVoslveXn9q4gz/QgpmCJIUa6D18qiGr/OBhLQcIjRhzxIuxglFmNpE
         3RWCZCTbHG9wTmd9t90UwxVFMssOYVIz8LHRmgduK1lPdAqeg3b6mBxo2oLm7Z832ENA
         lpQDRZsZkqSX62EsGBbdMj3rWPfnHt9yiavJ8=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] genirq: remove strange local_irq_disable()
Date: Wed,  4 Nov 2009 21:20:41 +0800
Message-Id: <1257340841-3739-3-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1257340841-3739-2-git-send-email-yong.zhang0@gmail.com>
References: <1257340841-3739-1-git-send-email-yong.zhang0@gmail.com>
 <1257340841-3739-2-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

local_irq_disable() called in try_one_irq looks very odd and maybe
lead misunderstand.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/spurious.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 114e704..430eb9a 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -54,7 +54,7 @@ static int try_one_irq(int irq, struct irq_desc *desc)
 		}
 		action = action->next;
 	}
-	local_irq_disable();
+
 	/* Now clean up the flags */
 	spin_lock(&desc->lock);
 	action = desc->action;
-- 
1.6.3.3

