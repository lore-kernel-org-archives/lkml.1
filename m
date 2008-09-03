Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbYICNjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbYICNjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbYICNi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:38:59 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:6695 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbYICNi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:38:58 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="18324177"
From: Alex Nixon <alex.nixon@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Alex Nixon <alex.nixon@citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 1/3] Xen: Fix cpu_hotplug.c build by replacing is_running_on_xen() with xen_pv_domain()
Date: Wed,  3 Sep 2008 14:30:21 +0100
Message-Id: <1220448623-14860-1-git-send-email-alex.nixon@citrix.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 03 Sep 2008 13:29:21.0415 (UTC) FILETIME=[12F12170:01C90DC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 drivers/xen/cpu_hotplug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index 1bc0035..565280e 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -78,7 +78,7 @@ static int __init setup_vcpu_hotplug_event(void)
 	static struct notifier_block xsn_cpu = {
 		.notifier_call = setup_cpu_watcher };
 
-	if (!is_running_on_xen())
+	if (!xen_pv_domain())
 		return -ENODEV;
 
 	register_xenstore_notifier(&xsn_cpu);
-- 
1.5.4.3

