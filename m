Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZAMSuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZAMSuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbZAMSto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:49:44 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:16197 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbZAMStn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:49:43 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: rusty@rustcorp.com.au, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, travis@sgi.com,
       David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 1/2] Make irq_*_affinity depend on CONFIG_GENERIC_HARDIRQS too.
Date: Tue, 13 Jan 2009 10:47:37 -0800
Message-Id: <1231872458-21218-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <496CE153.5010802@caviumnetworks.com>
References: <496CE153.5010802@caviumnetworks.com>
X-OriginalArrivalTime: 13 Jan 2009 18:47:43.0949 (UTC) FILETIME=[6B777FD0:01C975AF]
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

