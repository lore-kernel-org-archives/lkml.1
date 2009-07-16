Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZGPA2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZGPA2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 20:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZGPA2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 20:28:24 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:19868 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbZGPA2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 20:28:23 -0400
Date: Wed, 15 Jul 2009 18:28:22 -0600
From: dann frazier <dannf@hp.com>
To: linux-kernel@vger.kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] [x86] pci: Get rid of magic number in AMD bus discovery
Message-ID: <20090716002821.GV11729@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number 4 is hardcoded in a couple of loops.
Use the already-defined PCI_ROOT_NR macro instead.

Signed-off-by: dann frazier <dannf@hp.com>
---
 arch/x86/pci/amd_bus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 3ffa10d..feb3e09 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -332,7 +332,7 @@ static int __init early_fill_mp_bus_info(void)
 		return 0;
 
 	pci_root_num = 0;
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < PCI_ROOT_NR; i++) {
 		int min_bus;
 		int max_bus;
 		reg = read_pci_config(bus, slot, 1, 0xe0 + (i << 2));
@@ -368,7 +368,7 @@ static int __init early_fill_mp_bus_info(void)
 	memset(range, 0, sizeof(range));
 	range[0].end = 0xffff;
 	/* io port resource */
-	for (i = 0; i < 4; i++) {
+	for (i = 0; i < PCI_ROOT_NR; i++) {
 		reg = read_pci_config(bus, slot, 1, 0xc0 + (i << 3));
 		if (!(reg & 3))
 			continue;
-- 
1.6.3.3



