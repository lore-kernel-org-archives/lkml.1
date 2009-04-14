Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbZDNQpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbZDNQpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754979AbZDNQpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:45:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:47351 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbZDNQp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:45:29 -0400
Subject: [PATCH -tip] x86: k8.h reference to node in node_to_k8_nb_misc for
 !CONFIG_K8_NB
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mark Langsdorf <mark.langsdorf@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Apr 2009 22:15:00 +0530
Message-Id: <1239727500.2966.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add reference to node in node_to_k8_nb_misc for !CONFIG_K8_NB to make compiler happy.

So fixes compiler warnings:
  arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘show_cache_disable’:
  arch/x86/kernel/cpu/intel_cacheinfo.c:712: warning: unused variable ‘node’
  arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘store_cache_disable’:
  arch/x86/kernel/cpu/intel_cacheinfo.c:739: warning: unused variable ‘node’

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/k8.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index c23b3d1..c81e4ee 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -16,7 +16,7 @@ extern int k8_scan_nodes(unsigned long start, unsigned long end);
 #define node_to_k8_nb_misc(node) \
 	(node < num_k8_northbridges) ? k8_northbridges[node] : NULL
 #else
-#define node_to_k8_nb_misc(node) NULL
+#define node_to_k8_nb_misc(node) (node) ? NULL : NULL
 #endif
 
 
-- 
1.6.0.6



