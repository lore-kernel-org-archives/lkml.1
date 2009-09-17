Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbZIQRlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbZIQRlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbZIQRlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:41:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbZIQRll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:41:41 -0400
Date: Thu, 17 Sep 2009 13:41:45 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix ppc64 build failure on fedora
Message-ID: <20090917174144.GA11961@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

For some reason or another (newer gcc?) on Fedora 12 koji builders we're
seeing _restgpr0_$n symbols instead of _restgpr_$n as handled in the
prom_init_check.sh file:
Checking prom_init.o symbol '_restgpr0_14'
Error: External symbol '_restgpr0_14' referenced from prom_init.c
Checking prom_init.o symbol '_restgpr0_17'

Add cases to handle this to the filter portion of the script.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---

diff --git a/arch/powerpc/kernel/prom_init_check.sh b/arch/powerpc/kernel/prom_init_check.sh
index 1ac136b..9f82f49 100644
--- a/arch/powerpc/kernel/prom_init_check.sh
+++ b/arch/powerpc/kernel/prom_init_check.sh
@@ -52,12 +52,18 @@ do
 	if [ "${UNDEF:0:9}" = "_restgpr_" ]; then
 		OK=1
 	fi
+	if [ "${UNDEF:0:10}" = "_restgpr0_" ]; then
+		OK=1
+	fi
 	if [ "${UNDEF:0:11}" = "_rest32gpr_" ]; then
 		OK=1
 	fi
 	if [ "${UNDEF:0:9}" = "_savegpr_" ]; then
 		OK=1
 	fi
+	if [ "${UNDEF:0:10}" = "_savegpr0_" ]; then
+		OK=1
+	fi
 	if [ "${UNDEF:0:11}" = "_save32gpr_" ]; then
 		OK=1
 	fi
