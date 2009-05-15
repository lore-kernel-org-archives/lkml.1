Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZEOTpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZEOTpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZEOTpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:45:13 -0400
Received: from relay3.sgi.com ([192.48.156.57]:41006 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755135AbZEOTpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:45:11 -0400
Date: Fri, 15 May 2009 14:45:08 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64 - UV fix for memory-only blades
Message-ID: <20090515194508.GA8305@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an endcase in handling UV blades that have memory
but no cpus. The calculation of the highest blade number
failed to handle these blades if they appear last in the
configuration.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-05-15 12:00:59.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-05-15 14:38:16.000000000 -0500
@@ -632,6 +632,7 @@ void __init uv_system_init(void)
 		pnode = (paddr >> m_val) & pnode_mask;
 		blade = boot_pnode_to_blade(pnode);
 		uv_node_to_blade[nid] = blade;
+		max_pnode = max(pnode, max_pnode);
 	}
 
 	map_gru_high(max_pnode);
