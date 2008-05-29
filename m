Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbYE2SUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbYE2SUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbYE2STy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:19:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451AbYE2STw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:19:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/6] Werror: Hide warnings on static module device tables
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, bunk@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 29 May 2008 19:17:41 +0100
Message-ID: <20080529181741.5396.66279.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
References: <20080529181726.5396.79336.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hide warnings on static module device tables that are produced when compiling a
driver in to the core kernel rather than compiling it as a module.

This is done by introducing a MODULE_STATIC_DEVICE_TABLE() version of
MODULE_DEVICE_TABLE() for device ID tables that are declared static.  This
tells the compiler that the table is unused, thus suppressing warnings of the
type:

	mod.c:37: warning: 'id_table' defined but not used

MODULE_STATIC_DEVICE_TABLE() should not be used for non-static tables.

A MODULE_STATIC_GENERIC_TABLE() is also added for the same reason as a version
of MODULE_GENERIC_TABLE().

This does not automatically cause the table to be emitted by the compiler; that
will only happen if something references it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/ip2/ip2main.c       |    2 +-
 drivers/char/rocket.c            |    2 +-
 drivers/char/specialix.c         |    2 +-
 drivers/isdn/hisax/config.c      |    2 +-
 drivers/media/video/zoran_card.c |    2 +-
 drivers/scsi/dpt_i2o.c           |    2 +-
 drivers/scsi/fdomain.c           |    2 +-
 drivers/scsi/initio.c            |    2 +-
 drivers/telephony/ixj.c          |    2 +-
 drivers/watchdog/alim1535_wdt.c  |    2 +-
 drivers/watchdog/alim7101_wdt.c  |    2 +-
 include/linux/module.h           |   28 +++++++++++++++++++++++-----
 sound/oss/ad1848.c               |    2 +-
 13 files changed, 35 insertions(+), 17 deletions(-)


diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index c12cf8f..0580122 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -3181,4 +3181,4 @@ static struct pci_device_id ip2main_pci_tbl[] __devinitdata = {
 	{ }
 };
 
-MODULE_DEVICE_TABLE(pci, ip2main_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, ip2main_pci_tbl);
diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 743dc80..27155ce 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -1872,7 +1872,7 @@ static struct pci_device_id __devinitdata rocket_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_RP, PCI_ANY_ID) },
 	{ }
 };
-MODULE_DEVICE_TABLE(pci, rocket_pci_ids);
+MODULE_STATIC_DEVICE_TABLE(pci, rocket_pci_ids);
 
 /*
  *  Called when a PCI card is found.  Retrieves and stores model information,
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 2ee4d98..83b3968 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -2451,7 +2451,7 @@ static struct pci_device_id specialx_pci_tbl[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_IO8) },
 	{ }
 };
-MODULE_DEVICE_TABLE(pci, specialx_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, specialx_pci_tbl);
 
 module_init(specialix_init_module);
 module_exit(specialix_exit_module);
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 84d75a3..63932c5 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -1970,7 +1970,7 @@ static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
 	{ }				/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE(pci, hisax_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, hisax_pci_tbl);
 #endif /* CONFIG_PCI */
 
 module_init(HiSax_init);
diff --git a/drivers/media/video/zoran_card.c b/drivers/media/video/zoran_card.c
index 006d488..231fa72 100644
--- a/drivers/media/video/zoran_card.c
+++ b/drivers/media/video/zoran_card.c
@@ -160,7 +160,7 @@ static struct pci_device_id zr36067_pci_tbl[] = {
 	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0}
 };
-MODULE_DEVICE_TABLE(pci, zr36067_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, zr36067_pci_tbl);
 
 int zoran_num;			/* number of Buzs in use */
 struct zoran zoran[BUZ_MAX];
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 8508816..f98ce25 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -182,7 +182,7 @@ static struct pci_device_id dptids[] = {
 	{ PCI_DPT_VENDOR_ID, PCI_DPT_RAPTOR_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, }
 };
-MODULE_DEVICE_TABLE(pci,dptids);
+MODULE_STATIC_DEVICE_TABLE(pci,dptids);
 
 static int adpt_detect(struct scsi_host_template* sht)
 {
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index c33bcb2..d7c3752 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1772,7 +1772,7 @@ static struct pci_device_id fdomain_pci_tbl[] __devinitdata = {
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ }
 };
-MODULE_DEVICE_TABLE(pci, fdomain_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, fdomain_pci_tbl);
 #endif
 #define driver_template fdomain_driver_template
 #include "scsi_module.c"
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index e3f7397..3d6bbc0 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -136,7 +136,7 @@ static struct pci_device_id i91u_pci_devices[] = {
 	{ PCI_VENDOR_ID_DOMEX, I920_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
 };
-MODULE_DEVICE_TABLE(pci, i91u_pci_devices);
+MODULE_STATIC_DEVICE_TABLE(pci, i91u_pci_devices);
 
 #define DEBUG_INTERRUPT 0
 #define DEBUG_QUEUE     0
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 49cd979..1eea44f 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -290,7 +290,7 @@ static struct pci_device_id ixj_pci_tbl[] __devinitdata = {
 	{ }
 };
 
-MODULE_DEVICE_TABLE(pci, ixj_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, ixj_pci_tbl);
 
 /************************************************************************
 *
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 2b1fbdb..fedf9b9 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -316,7 +316,7 @@ static struct pci_device_id ali_pci_tbl[] = {
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
 };
-MODULE_DEVICE_TABLE(pci, ali_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, ali_pci_tbl);
 
 /*
  *	ali_find_watchdog	-	find a 1535 and 7101
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 238273c..b8fccd2 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -415,7 +415,7 @@ static struct pci_device_id alim7101_pci_tbl[] __devinitdata = {
 	{ }
 };
 
-MODULE_DEVICE_TABLE(pci, alim7101_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, alim7101_pci_tbl);
 
 MODULE_AUTHOR("Steve Hill");
 MODULE_DESCRIPTION("ALi M7101 PMU Computer Watchdog Timer driver");
diff --git a/include/linux/module.h b/include/linux/module.h
index 3e03b1a..9e1b041 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -76,18 +76,34 @@ void sort_extable(struct exception_table_entry *start,
 		  struct exception_table_entry *finish);
 void sort_main_extable(void);
 
+/*
+ * Return a pointer to the current module, but only if within a module
+ */
 #ifdef MODULE
-#define MODULE_GENERIC_TABLE(gtype,name)			\
-extern const struct gtype##_id __mod_##gtype##_table		\
-  __attribute__ ((unused, alias(__stringify(name))))
-
 extern struct module __this_module;
 #define THIS_MODULE (&__this_module)
 #else  /* !MODULE */
-#define MODULE_GENERIC_TABLE(gtype,name)
 #define THIS_MODULE ((struct module *)0)
 #endif
 
+/*
+ * Declare a module table
+ * - this suppresses "'name' defined but not used" warnings from the compiler
+ *   as the table may not actually be used by the code within the module
+ */
+#ifdef MODULE
+#define MODULE_GENERIC_TABLE(gtype,name)			\
+extern const struct gtype##_id __mod_##gtype##_table		\
+  __attribute__ ((unused, alias(__stringify(name))))
+#define MODULE_STATIC_GENERIC_TABLE(gtype,name)			\
+extern const struct gtype##_id __mod_##gtype##_table		\
+  __attribute__ ((unused, alias(__stringify(name))))
+#else
+#define MODULE_GENERIC_TABLE(gtype,name)
+#define MODULE_STATIC_GENERIC_TABLE(gtype,name) \
+static __typeof__((name)) name __attribute__((unused));
+#endif
+
 /* Generic info of form tag = "info" */
 #define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
 
@@ -137,6 +153,8 @@ extern struct module __this_module;
 
 #define MODULE_DEVICE_TABLE(type,name)		\
   MODULE_GENERIC_TABLE(type##_device,name)
+#define MODULE_STATIC_DEVICE_TABLE(type,name)		\
+  MODULE_STATIC_GENERIC_TABLE(type##_device,name)
 
 /* Version of form [<epoch>:]<version>[-<extra-version>].
    Or for CVS/RCS ID version, everything but the number is stripped.
diff --git a/sound/oss/ad1848.c b/sound/oss/ad1848.c
index 7cf9913..2e586f4 100644
--- a/sound/oss/ad1848.c
+++ b/sound/oss/ad1848.c
@@ -2879,7 +2879,7 @@ static struct isapnp_device_id id_table[] __devinitdata = {
 	{0}
 };
 
-MODULE_DEVICE_TABLE(isapnp, id_table);
+MODULE_STATIC_DEVICE_TABLE(isapnp, id_table);
 
 static struct pnp_dev *activate_dev(char *devname, char *resname, struct pnp_dev *dev)
 {

