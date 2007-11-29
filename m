Return-Path: <linux-kernel-owner+w=401wt.eu-S933467AbXK2Tpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467AbXK2Tpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbXK2TpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:45:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:3835 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757325AbXK2TpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:45:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=EdXY6SJqtD4usZFzxn+TMlWpBNkrdIXLAQ7sIznfkB1ZrYHgfLfIVHlGhGmsRxEX9qxWlc7pxWFZ6QhWzc3ittYe1zyXx44esvIQaPalfqoP4u9aZunvE3DWO+U7U793NQDYQTI2WHDLdSjATVId7Tcjm5e0UXsJcoA99pDnBTE=
Date: Thu, 29 Nov 2007 22:45:47 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: PPCML <linuxppc-dev@ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/5] PPC cleanup: do use for_each macro
Message-ID: <20071129194547.GC12123@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 arch/powerpc/kernel/btext.c         |    2 +-
 arch/powerpc/kernel/legacy_serial.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/btext.c b/arch/powerpc/kernel/btext.c
index 3ef51fb..04c9249 100644
--- a/arch/powerpc/kernel/btext.c
+++ b/arch/powerpc/kernel/btext.c
@@ -234,7 +234,7 @@ int __init btext_find_display(int allow_nonstdout)
 	if (rc == 0 || !allow_nonstdout)
 		return rc;
 
-	for (np = NULL; (np = of_find_node_by_type(np, "display"));) {
+	for_each_node_by_type(np, "display") {
 		if (of_get_property(np, "linux,opened", NULL)) {
 			printk("trying %s ...\n", np->full_name);
 			rc = btext_initialize(np);
diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index 4ed5887..b5dc646 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -307,7 +307,7 @@ void __init find_legacy_serial_ports(void)
 	}
 
 	/* First fill our array with SOC ports */
-	for (np = NULL; (np = of_find_compatible_node(np, "serial", "ns16550")) != NULL;) {
+	for_each_compatible_node(np, "serial", "ns16550") {
 		struct device_node *soc = of_get_parent(np);
 		if (soc && !strcmp(soc->type, "soc")) {
 			index = add_legacy_soc_port(np, np);
@@ -318,7 +318,7 @@ void __init find_legacy_serial_ports(void)
 	}
 
 	/* First fill our array with ISA ports */
-	for (np = NULL; (np = of_find_node_by_type(np, "serial"));) {
+	for_each_node_by_type(np, "serial") {
 		struct device_node *isa = of_get_parent(np);
 		if (isa && !strcmp(isa->name, "isa")) {
 			index = add_legacy_isa_port(np, isa);
@@ -329,7 +329,7 @@ void __init find_legacy_serial_ports(void)
 	}
 
 	/* First fill our array with tsi-bridge ports */
-	for (np = NULL; (np = of_find_compatible_node(np, "serial", "ns16550")) != NULL;) {
+	for_each_compatible_node(np, "serial", "ns16550") {
 		struct device_node *tsi = of_get_parent(np);
 		if (tsi && !strcmp(tsi->type, "tsi-bridge")) {
 			index = add_legacy_soc_port(np, np);
@@ -340,7 +340,7 @@ void __init find_legacy_serial_ports(void)
 	}
 
 	/* First fill our array with opb bus ports */
-	for (np = NULL; (np = of_find_compatible_node(np, "serial", "ns16550")) != NULL;) {
+	for_each_compatible_node(np, "serial", "ns16550") {
 		struct device_node *opb = of_get_parent(np);
 		if (opb && (!strcmp(opb->type, "opb") ||
 			    of_device_is_compatible(opb, "ibm,opb"))) {
-- 
1.5.3.5
