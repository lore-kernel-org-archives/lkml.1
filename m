Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZLDWkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZLDWkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbZLDWkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:40:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34877 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZLDWkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:40:04 -0500
Message-ID: <4B199025.5040208@gmail.com>
Date: Fri, 04 Dec 2009 23:41:41 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 24/31] Constify struct pci_raw_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct pci_raw_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/x86/include/asm/pci_x86.h |   10 +++++-----
 arch/x86/pci/common.c          |    4 ++--
 arch/x86/pci/direct.c          |    6 +++---
 arch/x86/pci/mmconfig_32.c     |    2 +-
 arch/x86/pci/mmconfig_64.c     |    2 +-
 arch/x86/pci/numaq_32.c        |    2 +-
 arch/x86/pci/olpc.c            |    2 +-
 arch/x86/pci/pcbios.c          |    4 ++--
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index b399988..3f47c38 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -89,16 +89,16 @@ extern int (*pcibios_enable_irq)(struct pci_dev *dev);
 extern void (*pcibios_disable_irq)(struct pci_dev *dev);
 
 struct pci_raw_ops {
-	int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
+	int (* const read)(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val);
-	int (*write)(unsigned int domain, unsigned int bus, unsigned int devfn,
+	int (* const write)(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 val);
 };
 
-extern struct pci_raw_ops *raw_pci_ops;
-extern struct pci_raw_ops *raw_pci_ext_ops;
+extern const struct pci_raw_ops *raw_pci_ops;
+extern const struct pci_raw_ops *raw_pci_ext_ops;
 
-extern struct pci_raw_ops pci_direct_conf1;
+extern const struct pci_raw_ops pci_direct_conf1;
 extern bool port_cf9_safe;
 
 /* arch_initcall level */
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 1331fcf..03901b2 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -31,8 +31,8 @@ int noioapicreroute = 1;
 int pcibios_last_bus = -1;
 unsigned long pirq_table_addr;
 struct pci_bus *pci_root_bus;
-struct pci_raw_ops *raw_pci_ops;
-struct pci_raw_ops *raw_pci_ext_ops;
+const struct pci_raw_ops *raw_pci_ops;
+const struct pci_raw_ops *raw_pci_ext_ops;
 
 int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val)
diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index 347d882..4baf6b6 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -79,7 +79,7 @@ static int pci_conf1_write(unsigned int seg, unsigned int bus,
 
 #undef PCI_CONF1_ADDRESS
 
-struct pci_raw_ops pci_direct_conf1 = {
+const struct pci_raw_ops pci_direct_conf1 = {
 	.read =		pci_conf1_read,
 	.write =	pci_conf1_write,
 };
@@ -173,7 +173,7 @@ static int pci_conf2_write(unsigned int seg, unsigned int bus,
 
 #undef PCI_CONF2_ADDRESS
 
-struct pci_raw_ops pci_direct_conf2 = {
+const struct pci_raw_ops pci_direct_conf2 = {
 	.read =		pci_conf2_read,
 	.write =	pci_conf2_write,
 };
@@ -189,7 +189,7 @@ struct pci_raw_ops pci_direct_conf2 = {
  * This should be close to trivial, but it isn't, because there are buggy
  * chipsets (yes, you guessed it, by Intel and Compaq) that have no class ID.
  */
-static int __init pci_sanity_check(struct pci_raw_ops *o)
+static int __init pci_sanity_check(const struct pci_raw_ops *o)
 {
 	u32 x = 0;
 	int year, devfn;
diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index f10a7e9..0425342 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -125,7 +125,7 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 	return 0;
 }
 
-static struct pci_raw_ops pci_mmcfg = {
+static const struct pci_raw_ops pci_mmcfg = {
 	.read =		pci_mmcfg_read,
 	.write =	pci_mmcfg_write,
 };
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
index 94349f8..41600a7 100644
--- a/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -104,7 +104,7 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 	return 0;
 }
 
-static struct pci_raw_ops pci_mmcfg = {
+static const struct pci_raw_ops pci_mmcfg = {
 	.read =		pci_mmcfg_read,
 	.write =	pci_mmcfg_write,
 };
diff --git a/arch/x86/pci/numaq_32.c b/arch/x86/pci/numaq_32.c
index 8eb295e..86bd657 100644
--- a/arch/x86/pci/numaq_32.c
+++ b/arch/x86/pci/numaq_32.c
@@ -112,7 +112,7 @@ static int pci_conf1_mq_write(unsigned int seg, unsigned int bus,
 
 #undef PCI_CONF1_MQ_ADDRESS
 
-static struct pci_raw_ops pci_direct_conf1_mq = {
+static const struct pci_raw_ops pci_direct_conf1_mq = {
 	.read	= pci_conf1_mq_read,
 	.write	= pci_conf1_mq_write
 };
diff --git a/arch/x86/pci/olpc.c b/arch/x86/pci/olpc.c
index b889d82..5a58a0a 100644
--- a/arch/x86/pci/olpc.c
+++ b/arch/x86/pci/olpc.c
@@ -297,7 +297,7 @@ static int pci_olpc_write(unsigned int seg, unsigned int bus,
 	return 0;
 }
 
-static struct pci_raw_ops pci_olpc_conf = {
+static const struct pci_raw_ops pci_olpc_conf = {
 	.read =	pci_olpc_read,
 	.write = pci_olpc_write,
 };
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 1c975cc..5fa1cff 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -278,7 +278,7 @@ static int pci_bios_write(unsigned int seg, unsigned int bus,
  * Function table for BIOS32 access
  */
 
-static struct pci_raw_ops pci_bios_access = {
+static const struct pci_raw_ops pci_bios_access = {
 	.read =		pci_bios_read,
 	.write =	pci_bios_write
 };
@@ -287,7 +287,7 @@ static struct pci_raw_ops pci_bios_access = {
  * Try to find PCI BIOS.
  */
 
-static struct pci_raw_ops * __devinit pci_find_bios(void)
+static const struct pci_raw_ops * __devinit pci_find_bios(void)
 {
 	union bios32 *check;
 	unsigned char sum;

