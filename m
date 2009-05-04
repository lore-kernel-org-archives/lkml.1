Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbZEDQ72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbZEDQ72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758406AbZEDQ65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:58:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:37515 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757783AbZEDQ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:58:56 -0400
Date: Mon, 4 May 2009 16:58:18 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, steiner@sgi.com, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, steiner@sgi.com, tglx@linutronix.de,
       gorcunov@gmail.com, mingo@elte.hu
In-Reply-To: <20090501202511.GE4633@lenovo>
References: <20090501202511.GE4633@lenovo>
Subject: [tip:x86/apic] x86: uv - prevent NULL dereference in uv_system_init()
Message-ID: <tip-9a8709d44139748fe2e0ab56d20d8c384c8b65ad@git.kernel.org>
Git-Commit-ID: 9a8709d44139748fe2e0ab56d20d8c384c8b65ad
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 16:58:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a8709d44139748fe2e0ab56d20d8c384c8b65ad
Gitweb:     http://git.kernel.org/tip/9a8709d44139748fe2e0ab56d20d8c384c8b65ad
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Sat, 2 May 2009 00:25:11 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 3 May 2009 10:49:31 +0200

x86: uv - prevent NULL dereference in uv_system_init()

We may reach NULL dereference oops if kmalloc failed.
Prevent it with explicit BUG_ON.

[ Impact: more controlled assert in 'impossible' scenario ]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Jack Steiner <steiner@sgi.com>
LKML-Reference: <20090501202511.GE4633@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 873bf71..9d9e228 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -569,15 +569,18 @@ void __init uv_system_init(void)
 
 	bytes = sizeof(struct uv_blade_info) * uv_num_possible_blades();
 	uv_blade_info = kmalloc(bytes, GFP_KERNEL);
+	BUG_ON(!uv_blade_info);
 
 	get_lowmem_redirect(&lowmem_redir_base, &lowmem_redir_size);
 
 	bytes = sizeof(uv_node_to_blade[0]) * num_possible_nodes();
 	uv_node_to_blade = kmalloc(bytes, GFP_KERNEL);
+	BUG_ON(!uv_node_to_blade);
 	memset(uv_node_to_blade, 255, bytes);
 
 	bytes = sizeof(uv_cpu_to_blade[0]) * num_possible_cpus();
 	uv_cpu_to_blade = kmalloc(bytes, GFP_KERNEL);
+	BUG_ON(!uv_cpu_to_blade);
 	memset(uv_cpu_to_blade, 255, bytes);
 
 	blade = 0;
