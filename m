Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbZIXUnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbZIXUnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 16:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZIXUny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 16:43:54 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:34341 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbZIXUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 16:43:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=tlntjNw3lXDMSix1ogC3YQ4yj6vRemLo3//gCtFSTVEqn9qYZvzbB4so46T9l/1x+z
         bwsw2ACe4W9q61saNygHsPVwZPraFsCNY4P4s2tTxk5i0WAPIN13euPcFF8Lw3ciqP/L
         qmtwGozVwqsf8Lh9w5ud7uXSERMBsRw0dcF9M=
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Cc: Remy Bohmer <linux@bohmer.net>
Subject: [PATCH] get rid of [softirq-NULL]
Date: Thu, 24 Sep 2009 22:43:53 +0200
Message-Id: <1253825033-30094-1-git-send-email-linux@bohmer.net>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if CONFIG_HIGH_RES_TIMERS is not configured, still the hrtimer-softirq
is started, so to prevent the name 'softirq-NULL' in 'ps' output we
should still define its name here.
Preventing the softirq from starting at all would touch much more code, so
I chose the easy way here, it is a cosmetic fix anyway.

Signed-off-by: Remy Bohmer <linux@bohmer.net>
---
 kernel/softirq.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index aae8d45..590049c 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -1139,9 +1139,7 @@ static const char *softirq_names [] =
   [NET_RX_SOFTIRQ]	= "net-rx",
   [BLOCK_SOFTIRQ]	= "block",
   [TASKLET_SOFTIRQ]	= "tasklet",
-#ifdef CONFIG_HIGH_RES_TIMERS
   [HRTIMER_SOFTIRQ]	= "hrtimer",
-#endif
   [RCU_SOFTIRQ]		= "rcu",
 };
 
-- 
1.6.0.4

