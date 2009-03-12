Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZCLMjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZCLMjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbZCLMja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:39:30 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37501 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbZCLMj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:39:29 -0400
Message-Id: <49B910B6.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 12:40:06 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: move save_mr() into .meminit.text
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

The function is only being called from boot or memory hotplug paths.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/init_64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- tip/arch/x86/mm/init.c
+++ tip-x86_64-save_mr-meminit/arch/x86/mm/init.c
@@ -94,9 +94,9 @@ struct map_range {
 #define NR_RANGE_MR 5
 #endif
 
-static int save_mr(struct map_range *mr, int nr_range,
-		   unsigned long start_pfn, unsigned long end_pfn,
-		   unsigned long page_size_mask)
+static int __meminit save_mr(struct map_range *mr, int nr_range,
+			     unsigned long start_pfn, unsigned long end_pfn,
+			     unsigned long page_size_mask)
 {
 	if (start_pfn < end_pfn) {
 		if (nr_range >= NR_RANGE_MR)



