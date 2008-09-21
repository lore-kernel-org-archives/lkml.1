Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYIUDf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYIUDf4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 23:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYIUDfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 23:35:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:58082 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYIUDfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 23:35:47 -0400
Date: Sat, 20 Sep 2008 20:35:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH] x86: use round_jiffies() for the corruption check timer
Message-ID: <20080920203544.53a5148e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 20 Sep 2008 20:32:43 -0700
Subject: [PATCH] x86: use round_jiffies() for the corruption check timer

the exact timing of the corruption check isn't too important (it's once a
minute timer), use round_jiffies() to align it and avoid extra wakeups.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
CC: Hugh Dickins <hugh@veritas.com>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d5bd679..a9998cb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -715,7 +715,7 @@ void check_for_bios_corruption(void)
 static void periodic_check_for_corruption(unsigned long data)
 {
 	check_for_bios_corruption();
-	mod_timer(&periodic_check_timer, jiffies + corruption_check_period*HZ);
+	mod_timer(&periodic_check_timer, round_jiffies(jiffies + corruption_check_period*HZ));
 }
 
 void start_periodic_check_for_corruption(void)
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
