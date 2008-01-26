Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbYAZWN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbYAZWN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbYAZWLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:11:48 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:41249 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827AbYAZWLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:11:43 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: fix section mismatch warning in srat_64.c
Date: Sat, 26 Jan 2008 23:11:46 +0100
Message-Id: <1201385513-26885-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080126215917.GB26651@uranus.ravnborg.org>
References: <20080126215917.GB26651@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warnings:
WARNING: arch/x86/mm/built-in.o(.text+0x1abc): Section mismatch: reference to .init.data:nodes_parsed in 'unparse_node'
WARNING: arch/x86/mm/built-in.o(.text+0x1ac6): Section mismatch: reference to .cpuinit.data:apicid_to_node in 'unparse_node'
WARNING: arch/x86/mm/built-in.o(.text+0x1ad2): Section mismatch: reference to .cpuinit.data:apicid_to_node in 'unparse_node'

unparse_node are static and only used by acpi_scan_nodes which
is already annotated __init.
So we annotate unparse_node with __init.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/mm/srat_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 37308d6..65416f8 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -323,7 +323,7 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 	return 1;
 }
 
-static void unparse_node(int node)
+static void __init unparse_node(int node)
 {
 	int i;
 	node_clear(node, nodes_parsed);
-- 
1.5.4.rc3.14.g44397

