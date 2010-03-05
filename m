Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab0CETKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:10:39 -0500
Received: from relay2.sgi.com ([192.48.179.30]:49216 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755440Ab0CETKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:10:36 -0500
Message-Id: <20100305191035.319331216@gulag1.americas.sgi.com>
References: <20100305191035.058221526@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 05 Mar 2010 13:10:36 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, Tony Ernst <tee@sgi.com>,
       linux-kernel@vger.kernel.org,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, x86@kernel.org
Subject: [PATCH 1/3] x86: reduce per cpu MCA boot up messages
Content-Disposition: inline; filename=limit-MCA-messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't write per cpu MCA boot up messages.

Signed-of-by: Mike Travis <travis@sgi.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/cpu/mcheck/mce_intel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -95,7 +95,7 @@ static void cmci_discover(int banks, int
 
 		/* Already owned by someone else? */
 		if (val & CMCI_EN) {
-			if (test_and_clear_bit(i, owned) || boot)
+			if (test_and_clear_bit(i, owned) && !boot)
 				print_update("SHD", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 			continue;
@@ -107,7 +107,7 @@ static void cmci_discover(int banks, int
 
 		/* Did the enable bit stick? -- the bank supports CMCI */
 		if (val & CMCI_EN) {
-			if (!test_and_set_bit(i, owned) || boot)
+			if (!test_and_set_bit(i, owned) && !boot)
 				print_update("CMCI", &hdr, i);
 			__clear_bit(i, __get_cpu_var(mce_poll_banks));
 		} else {

-- 
