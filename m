Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYHHBOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYHHBOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYHHBOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:14:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47042 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751017AbYHHBOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:14:16 -0400
Message-ID: <489B9DE7.9070802@sgi.com>
Date: Thu, 07 Aug 2008 18:14:15 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Luck, Tony" <tony.luck@intel.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] ia64 UV: Use blinking LED for heartbeat display fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: ia64 UV: Use blinking LED for heartbeat display fix

  Fix error not caught on initial build test.

Based on linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/uv/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.tip.orig/arch/ia64/uv/kernel/setup.c
+++ linux-2.6.tip/arch/ia64/uv/kernel/setup.c
@@ -71,7 +71,7 @@ static void uv_display_heartbeat(void)
 {
 	int cpu;
 
-	uv_hub_info->uv_heartbeat = nr_cpu_ids;
+	uv_hub_info->led_heartbeat_count = nr_cpu_ids;
 
 	for_each_online_cpu(cpu) {
 		struct uv_hub_info_s *hub = uv_cpu_hub_info(cpu);
