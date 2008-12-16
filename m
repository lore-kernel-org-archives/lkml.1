Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbYLPC0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbYLPC0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYLPCYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:21 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40563 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752022AbYLPCYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:14 -0500
Message-Id: <20081216022411.469961000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:21 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] x86: Use cpumask accessors code for possible/present maps.
Content-Disposition: inline; filename=0016-x86-Use-cpumask-accessors-code-for-possible-present.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use new API

Use the accessors rather than frobbing bits directly.  Most of this is
in arch code I haven't even compiled, but is straightforward.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/apic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 3b630ec..edda4c0 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1903,8 +1903,8 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	}
 #endif
 
-	cpu_set(cpu, cpu_possible_map);
-	cpu_set(cpu, cpu_present_map);
+	set_cpu_possible(cpu, true);
+	set_cpu_present(cpu, true);
 }
 
 #ifdef CONFIG_X86_64
-- 
1.6.0

-- 
