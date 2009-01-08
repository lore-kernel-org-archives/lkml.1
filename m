Return-Path: <linux-kernel-owner+w=401wt.eu-S1763632AbZAHW4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763632AbZAHW4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759420AbZAHW41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:56:27 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:39315 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945AbZAHW40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:56:26 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: rusty@rustcorp.com.au, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, travis@sgi.com,
       David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 1/2] Make irq_*_affinity depend on CONFIG_GENERIC_HARDIRQS too.
Date: Thu,  8 Jan 2009 14:55:44 -0800
Message-Id: <1231455345-29453-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <496683D0.6000509@caviumnetworks.com>
References: <496683D0.6000509@caviumnetworks.com>
X-OriginalArrivalTime: 08 Jan 2009 22:55:49.0635 (UTC) FILETIME=[3FF62D30:01C971E4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In interrupt.h these functions are declared only if
CONFIG_GENERIC_HARDIRQS is set.  We should define them under identical
conditions.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index cd0cd8d..618a64f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -15,7 +15,7 @@
 
 #include "internals.h"
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 cpumask_var_t irq_default_affinity;
 
 static int init_irq_default_affinity(void)
-- 
1.5.6.6

