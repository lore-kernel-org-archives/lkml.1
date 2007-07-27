Return-Path: <linux-kernel-owner+w=401wt.eu-S1765020AbXG0Jt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765020AbXG0Jt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936260AbXG0Jq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:46:27 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:36022 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936433AbXG0JqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:46:25 -0400
Date: Fri, 27 Jul 2007 11:45:00 +0200 (MEST)
Message-Id: <200707270945.LAA17237@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 10/68] 0 -> NULL, for arch/mips
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is an excerpt of the semantic patch: 

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

  E !=
- 0
+ NULL

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: ralf@linux-mips.org
Cc: linux-mips@linux-mips.org
Cc: akpm@linux-foundation.org
---

 ops-emma2rh.c |    2 +-
 ops-pnx8550.c |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/mips/pci/ops-emma2rh.c b/arch/mips/pci/ops-emma2rh.c
index 38f1816..d31bfc6 100644
--- a/arch/mips/pci/ops-emma2rh.c
+++ b/arch/mips/pci/ops-emma2rh.c
@@ -45,7 +45,7 @@ static int check_args(struct pci_bus *bu
 	/* check if the bus is top-level */
 	if (bus->parent != NULL) {
 		*bus_num = bus->number;
-		db_assert(bus_num != 0);
+		db_assert(bus_num != NULL);
 	} else
 		*bus_num = 0;
 
diff --git a/arch/mips/pci/ops-pnx8550.c b/arch/mips/pci/ops-pnx8550.c
index f556b7a..d610646 100644
--- a/arch/mips/pci/ops-pnx8550.c
+++ b/arch/mips/pci/ops-pnx8550.c
@@ -117,7 +117,7 @@ read_config_byte(struct pci_bus *bus, un
 	unsigned int data = 0;
 	int err;
 
-	if (bus == 0)
+	if (bus == NULL)
 		return -1;
 
 	err = config_access(PCI_CMD_CONFIG_READ, bus, devfn, where, ~(1 << (where & 3)), &data);
@@ -145,7 +145,7 @@ read_config_word(struct pci_bus *bus, un
 	unsigned int data = 0;
 	int err;
 
-	if (bus == 0)
+	if (bus == NULL)
 		return -1;
 
 	if (where & 0x01)
@@ -168,7 +168,7 @@ static int
 read_config_dword(struct pci_bus *bus, unsigned int devfn, int where, u32 * val)
 {
 	int err;
-	if (bus == 0)
+	if (bus == NULL)
 		return -1;
 
 	if (where & 0x03)
@@ -185,7 +185,7 @@ write_config_byte(struct pci_bus *bus, u
 	unsigned int data = (unsigned int)val;
 	int err;
 
-	if (bus == 0)
+	if (bus == NULL)
 		return -1;
 
 	switch (where & 0x03) {
@@ -213,7 +213,7 @@ write_config_word(struct pci_bus *bus, u
 	unsigned int data = (unsigned int)val;
 	int err;
 
-	if (bus == 0)
+	if (bus == NULL)
 		return -1;
 
 	if (where & 0x01)
@@ -235,7 +235,7 @@ static int
 write_config_dword(struct pci_bus *bus, unsigned int devfn, int where, u32 val)
 {
 	int err;
-	if (bus == 0)
+	if (bus == NULL)
 		return -1;
 
 	if (where & 0x03)

