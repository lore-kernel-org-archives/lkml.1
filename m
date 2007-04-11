Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbXDKJiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbXDKJiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXDKJiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:38:13 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:38335 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXDKJiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:38:00 -0400
X-IronPort-AV: i="4.14,393,1170651600"; 
   d="scan'208"; a="26949350:sNHT29391971"
Subject: [PATCH 5/5] nommu: fix bug ip_conntrack does not work on nommu
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 11 Apr 2007 17:40:15 +0800
Message-Id: <1176284415.29581.30.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


num_physpages is not exported out in mm/nommu.c, so the ip_conntrack
module link will fail.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 mm/nommu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 0016557..db0452e 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -45,6 +45,7 @@ int heap_stack_gap = 0;
 
 EXPORT_SYMBOL(mem_map);
 EXPORT_SYMBOL(__vm_enough_memory);
+EXPORT_SYMBOL(num_physpages);
 
 /* list of shareable VMAs */
 struct rb_root nommu_vma_tree = RB_ROOT;
-- 
1.5.0.5

