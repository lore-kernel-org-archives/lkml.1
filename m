Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbXCVC3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbXCVC3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 22:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXCVC3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 22:29:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38627 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbXCVC3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 22:29:54 -0400
Date: Wed, 21 Mar 2007 19:23:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: venkatesh.pallipadi@intel.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] cpuidle: unsigned bitfield
Message-Id: <20070321192300.6efd67fe.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

A 1-bit bitfield has no room for a sign bit.
drivers/cpuidle/governors/ladder.c:54:16: error: dubious bitfield without explicit `signed' or `unsigned'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/cpuidle/governors/ladder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21-rc4-mm1.orig/drivers/cpuidle/governors/ladder.c
+++ linux-2.6.21-rc4-mm1/drivers/cpuidle/governors/ladder.c
@@ -51,7 +51,7 @@ struct ladder_device_state {
 
 struct ladder_device {
 	struct ladder_device_state states[CPUIDLE_STATE_MAX];
-	int bm_check:1;
+	unsigned int bm_check:1;
 	unsigned long bm_check_timestamp;
 	unsigned long bm_activity; /* FIXME: bm activity should be global */
 	int last_state_idx;
