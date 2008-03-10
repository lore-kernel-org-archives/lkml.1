Return-Path: <linux-kernel-owner+w=401wt.eu-S1756063AbYCJURJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbYCJURJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbYCJUO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:14:27 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:46717 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756710AbYCJUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:14:23 -0400
X-Belgacom-Dynamic: yes
Date: Mon, 10 Mar 2008 21:14:19 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] v2.5.25-rc patches
Message-ID: <20080310201419.GA7623@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/cpu5wdt.c     |    4 
 drivers/watchdog/hpwdt.c       |  214 ++++-------------------------------------
 drivers/watchdog/it8712f_wdt.c |   78 ++++++++++++--
 drivers/watchdog/machzwd.c     |    2 
 drivers/watchdog/mtx-1_wdt.c   |    4 
 drivers/watchdog/pcwd_usb.c    |    4 
 drivers/watchdog/s3c2410_wdt.c |    8 -
 drivers/watchdog/shwdt.c       |    2 
 8 files changed, 100 insertions(+), 216 deletions(-)

with these Changes:

Author: Adrian Bunk <bunk@kernel.org>
Date:   Fri Feb 22 21:58:02 2008 +0200

    [WATCHDOG] make watchdog/hpwdt.c:asminline_call() static
    
    This patch makes the needlessly global asminline_call() static and
    removes the not required "asmlinkage".
    
    Signed-off-by: Adrian Bunk <bunk@kernel.org>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Andrew Morton <akpm@linux-foundation.org>

Author: Florian Fainelli <florian.fainelli@telecomint.eu>
Date:   Mon Feb 25 13:39:57 2008 +0100

    [WATCHDOG] Remove volatiles from watchdog device structures
    
    Remove the volatile since those are useless in such a structure.
    
    Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Wed Mar 5 18:24:58 2008 -0800

    [WATCHDOG] replace remaining __FUNCTION__ occurrences
    
    __FUNCTION__ is gcc-specific, use __func__
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Roland Dreier <rdreier@cisco.com>
Date:   Thu Feb 28 12:34:42 2008 -0800

    [WATCHDOG] hpwdt: Use dmi_walk() instead of own copy
    
    We can simplify the code by deleting all of the duplicated DMI table
    walking code and using the kernel's existing dmi_walk() interface to
    find the DMI entry the driver is looking for.
    
    Signed-off-by: Roland Dreier <rolandd@cisco.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Roland Dreier <rdreier@cisco.com>
Date:   Thu Feb 28 09:48:10 2008 -0800

    [WATCHDOG] Fix return value warning in hpwdt
    
    The return value of smbios_scan_machine() is never used, and when it
    succeeds it doesn't return anything, so just make it void.  This fixes:
    
        drivers/watchdog/hpwdt.c: In function 'smbios_scan_machine':
        drivers/watchdog/hpwdt.c:562: warning: control reaches end of non-void function
    
    Signed-off-by: Roland Dreier <rolandd@cisco.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Roland Dreier <rdreier@cisco.com>
Date:   Thu Feb 28 09:38:44 2008 -0800

    [WATCHDOG] Fix declaration of struct smbios_entry_point in hpwdt
    
    On my HP DL380 G5 system running a 64-bit kernel, loading the hpwdt
    driver causes a crash because the driver attempts to ioremap an
    invalid physical address.  This is because the driver has an incorrect
    definition of the SMBIOS table entry point structure: the table
    address is only a 32-bit quantity, and making it a u64 means that the
    high-order 32 bits end up containing garbage.
    
    Correcting the structure definition fixes the driver so that it loads
    without any problems on my system.
    
    Signed-off-by: Roland Dreier <rolandd@cisco.com>
    Acked-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Andrew Paprocki <andrew@ishiboo.com>
Date:   Sun Feb 10 22:11:15 2008 -0500

    [WATCHDOG] it8712f_wdt support for 16-bit timeout values, WDIOC_GETSTATUS
    
    This patch adds support for 16-bit watchdog timeout values which are
    available in chip revisions >= 0x08. Values <= 65535 are seconds precision,
    otherwise minutes precision is used up to a maximum value of 3932100. Added
    implementation for WDIOC_GETSTATUS which checks the WDT status bit in the
    WDT control register.
    
    Signed-off-by: Andrew Paprocki <andrew@ishiboo.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index 5941ca6..df72f90 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -59,9 +59,9 @@ static int ticks = 10000;
 
 static struct {
 	struct completion stop;
-	volatile int running;
+	int running;
 	struct timer_list timer;
-	volatile int queue;
+	int queue;
 	int default_ticks;
 	unsigned long inuse;
 } cpu5wdt_device;
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a2e174b..6483d10 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -58,41 +58,6 @@ struct bios32_service_dir {
 	u8 reserved[5];
 };
 
-/*
- * smbios_entry_point     - defines SMBIOS entry point structure
- *
- * anchor[4]              - anchor string (_SM_)
- * checksum               - checksum of the entry point structure
- * length                 - length of the entry point structure
- * major_ver              - major version (02h for revision 2.1)
- * minor_ver              - minor version (01h for revision 2.1)
- * max_struct_size        - size of the largest SMBIOS structure
- * revision               - entry point structure revision implemented
- * formatted_area[5]      - reserved
- * intermediate_anchor[5] - intermediate anchor string (_DMI_)
- * intermediate_checksum  - intermediate checksum
- * table_length           - structure table length
- * table_address          - structure table address
- * table_num_structs      - number of SMBIOS structures present
- * bcd_revision           - BCD revision
- */
-struct smbios_entry_point {
-	u8 anchor[4];
-	u8 checksum;
-	u8 length;
-	u8 major_ver;
-	u8 minor_ver;
-	u16 max_struct_size;
-	u8 revision;
-	u8 formatted_area[5];
-	u8 intermediate_anchor[5];
-	u8 intermediate_checksum;
-	u16 table_length;
-	u64 table_address;
-	u16 table_num_structs;
-	u8 bcd_revision;
-};
-
 /* type 212 */
 struct smbios_cru64_info {
 	u8 type;
@@ -175,31 +140,13 @@ static struct pci_device_id hpwdt_devices[] = {
 };
 MODULE_DEVICE_TABLE(pci, hpwdt_devices);
 
-/*
- *	bios_checksum
- */
-static int __devinit bios_checksum(const char __iomem *ptr, int len)
-{
-	char sum = 0;
-	int i;
-
-	/*
-	 * calculate checksum of size bytes. This should add up
-	 * to zero if we have a valid header.
-	 */
-	for (i = 0; i < len; i++)
-		sum += ptr[i];
-
-	return ((sum == 0) && (len > 0));
-}
-
 #ifndef CONFIG_X86_64
 /* --32 Bit Bios------------------------------------------------------------ */
 
 #define HPWDT_ARCH	32
 
-asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
-			       unsigned long *pRomEntry)
+static void asminline_call(struct cmn_registers *pi86Regs,
+			   unsigned long *pRomEntry)
 {
 	asm("pushl       %ebp               \n\t"
 	    "movl        %esp, %ebp         \n\t"
@@ -303,6 +250,24 @@ static int __devinit cru_detect(unsigned long map_entry,
 }
 
 /*
+ *	bios_checksum
+ */
+static int __devinit bios_checksum(const char __iomem *ptr, int len)
+{
+	char sum = 0;
+	int i;
+
+	/*
+	 * calculate checksum of size bytes. This should add up
+	 * to zero if we have a valid header.
+	 */
+	for (i = 0; i < len; i++)
+		sum += ptr[i];
+
+	return ((sum == 0) && (len > 0));
+}
+
+/*
  *	bios32_present
  *
  *	Routine Description:
@@ -368,8 +333,8 @@ static int __devinit detect_cru_service(void)
 
 #define HPWDT_ARCH	64
 
-asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
-			       unsigned long *pRomEntry)
+static void asminline_call(struct cmn_registers *pi86Regs,
+			   unsigned long *pRomEntry)
 {
 	asm("pushq      %rbp            \n\t"
 	    "movq       %rsp, %rbp      \n\t"
@@ -410,12 +375,8 @@ asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
  *	dmi_find_cru
  *
  *	Routine Description:
- *	This function checks wether or not a SMBIOS/DMI record is
+ *	This function checks whether or not a SMBIOS/DMI record is
  *	the 64bit CRU info or not
- *
- *	Return Value:
- *	0        :  SUCCESS - if record found
- *	<0       :  FAILURE - if record not found
  */
 static void __devinit dmi_find_cru(const struct dmi_header *dm)
 {
@@ -434,138 +395,11 @@ static void __devinit dmi_find_cru(const struct dmi_header *dm)
 	}
 }
 
-/*
- *	dmi_table
- *
- *	Routine Description:
- *	Decode the SMBIOS/DMI table and check if we have a 64bit CRU record
- *	or not.
- *
- *	We have to be cautious here. We have seen BIOSes with DMI pointers
- *	pointing to completely the wrong place for example
- */
-static void __devinit dmi_table(u8 *buf, int len, int num,
-		      void (*decode)(const struct dmi_header *))
-{
-	u8 *data = buf;
-	int i = 0;
-
-	/*
-	 *	Stop when we see all the items the table claimed to have
-	 *	OR we run off the end of the table (also happens)
-	 */
-	while ((i < num) && (data - buf + sizeof(struct dmi_header)) <= len) {
-		const struct dmi_header *dm = (const struct dmi_header *)data;
-
-		/*
-		 *  We want to know the total length (formated area and strings)
-		 *  before decoding to make sure we won't run off the table in
-		 *  dmi_decode or dmi_string
-		 */
-		data += dm->length;
-		while ((data - buf < len - 1) && (data[0] || data[1]))
-			data++;
-		if (data - buf < len - 1)
-			decode(dm);
-		data += 2;
-		i++;
-	}
-}
-
-/*
- *	smbios_present
- *
- *	Routine Description:
- *	This function parses the SMBIOS entry point table to retrieve
- *	the 64 bit CRU Service.
- *
- *	Return Value:
- *	0        :  SUCCESS
- *	<0       :  FAILURE
- */
-static int __devinit smbios_present(const char __iomem *p)
-{
-	struct smbios_entry_point *eps =
-		(struct smbios_entry_point *) p;
-	int length;
-	u8 *buf;
-
-	/* check if we have indeed the SMBIOS table entry point */
-	if ((strncmp((char *)eps->anchor, "_SM_",
-			     sizeof(eps->anchor))) == 0) {
-		length = eps->length;
-
-		/* SMBIOS v2.1 implementation might use 0x1e */
-		if ((length == 0x1e) &&
-		    (eps->major_ver == 2) &&
-		    (eps->minor_ver == 1))
-			length = 0x1f;
-
-		/*
-		 * Now we will check:
-		 * - SMBIOS checksum must be 0
-		 * - intermediate anchor should be _DMI_
-		 * - intermediate checksum should be 0
-		 */
-		if ((bios_checksum(p, length)) &&
-		    (strncmp((char *)eps->intermediate_anchor, "_DMI_",
-		             sizeof(eps->intermediate_anchor)) == 0) &&
-		    (bios_checksum(p+0x10, 15))) {
-			buf = ioremap(eps->table_address, eps->table_length);
-			if (buf == NULL)
-				return -ENODEV;
-
-
-			/* Scan the DMI table for the 64 bit CRU service */
-			dmi_table(buf, eps->table_length,
-			          eps->table_num_structs, dmi_find_cru);
-
-			iounmap(buf);
-			return 0;
-		}
-	}
-
-	return -ENODEV;
-}
-
-static int __devinit smbios_scan_machine(void)
-{
-	char __iomem *p, *q;
-	int rc;
-
-	if (efi_enabled) {
-		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
-			return -ENODEV;
-
-		p = ioremap(efi.smbios, 32);
-		if (p == NULL)
-			return -ENOMEM;
-
-		rc = smbios_present(p);
-		iounmap(p);
-	} else {
-		/*
-		 * Search from 0x0f0000 through 0x0fffff, inclusive.
-		 */
-		p = ioremap(PCI_ROM_BASE1, ROM_SIZE);
-		if (p == NULL)
-			return -ENOMEM;
-
-		for (q = p; q < p + ROM_SIZE; q += 16) {
-			rc = smbios_present(q);
-			if (!rc) {
-				break;
-			}
-		}
-		iounmap(p);
-	}
-}
-
 static int __devinit detect_cru_service(void)
 {
 	cru_rom_addr = NULL;
 
-	smbios_scan_machine();	/* will become dmi_walk(dmi_find_cru); */
+	dmi_walk(dmi_find_cru);
 
 	/* if cru_rom_addr has been set then we found a CRU service */
 	return ((cru_rom_addr != NULL)? 0: -ENODEV);
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 1b6d7d1..1efcad3 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -7,7 +7,8 @@
  *
  *	drivers/char/watchdog/scx200_wdt.c
  *	drivers/hwmon/it87.c
- *	IT8712F EC-LPC I/O Preliminary Specification 0.9.2.pdf
+ *	IT8712F EC-LPC I/O Preliminary Specification 0.8.2
+ *	IT8712F EC-LPC I/O Preliminary Specification 0.9.3
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License as
@@ -40,6 +41,7 @@ MODULE_DESCRIPTION("IT8712F Watchdog Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
+static int max_units = 255;
 static int margin = 60;		/* in seconds */
 module_param(margin, int, 0);
 MODULE_PARM_DESC(margin, "Watchdog margin in seconds");
@@ -51,6 +53,7 @@ MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
 static struct semaphore it8712f_wdt_sem;
 static unsigned expect_close;
 static spinlock_t io_lock;
+static unsigned char revision;
 
 /* Dog Food address - We use the game port address */
 static unsigned short address;
@@ -108,6 +111,15 @@ superio_inw(int reg)
 	return val;
 }
 
+static void
+superio_outw(int val, int reg)
+{
+	outb(reg++, REG);
+	outb((val >> 8) & 0xff, VAL);
+	outb(reg, REG);
+	outb(val & 0xff, VAL);
+}
+
 static inline void
 superio_select(int ldn)
 {
@@ -143,15 +155,33 @@ static void
 it8712f_wdt_update_margin(void)
 {
 	int config = WDT_OUT_KRST | WDT_OUT_PWROK;
-
-	printk(KERN_INFO NAME ": timer margin %d seconds\n", margin);
-
-	/* The timeout register only has 8bits wide */
-	if (margin < 256)
-		config |= WDT_UNIT_SEC;	/* else UNIT are MINUTES */
+	int units = margin;
+
+	/* Switch to minutes precision if the configured margin
+	 * value does not fit within the register width.
+	 */
+	if (units <= max_units) {
+		config |= WDT_UNIT_SEC; /* else UNIT is MINUTES */
+		printk(KERN_INFO NAME ": timer margin %d seconds\n", units);
+	} else {
+		units /= 60;
+		printk(KERN_INFO NAME ": timer margin %d minutes\n", units);
+	}
 	superio_outb(config, WDT_CONFIG);
 
-	superio_outb((margin > 255) ? (margin / 60) : margin, WDT_TIMEOUT);
+	if (revision >= 0x08)
+		superio_outw(units, WDT_TIMEOUT);
+	else
+		superio_outb(units, WDT_TIMEOUT);
+}
+
+static int
+it8712f_wdt_get_status(void)
+{
+	if (superio_inb(WDT_CONTROL) & 0x01)
+		return WDIOF_CARDRESET;
+	else
+		return 0;
 }
 
 static void
@@ -234,7 +264,7 @@ it8712f_wdt_ioctl(struct inode *inode, struct file *file,
 		.firmware_version = 1,
 		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
 	};
-	int new_margin;
+	int value;
 
 	switch (cmd) {
 	default:
@@ -244,17 +274,27 @@ it8712f_wdt_ioctl(struct inode *inode, struct file *file,
 			return -EFAULT;
 		return 0;
 	case WDIOC_GETSTATUS:
+		superio_enter();
+		superio_select(LDN_GPIO);
+
+		value = it8712f_wdt_get_status();
+
+		superio_exit();
+
+		return put_user(value, p);
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
 	case WDIOC_KEEPALIVE:
 		it8712f_wdt_ping();
 		return 0;
 	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, p))
+		if (get_user(value, p))
 			return -EFAULT;
-		if (new_margin < 1)
+		if (value < 1)
+			return -EINVAL;
+		if (value > (max_units * 60))
 			return -EINVAL;
-		margin = new_margin;
+		margin = value;
 		superio_enter();
 		superio_select(LDN_GPIO);
 
@@ -262,6 +302,7 @@ it8712f_wdt_ioctl(struct inode *inode, struct file *file,
 
 		superio_exit();
 		it8712f_wdt_ping();
+		/* Fall through */
 	case WDIOC_GETTIMEOUT:
 		if (put_user(margin, p))
 			return -EFAULT;
@@ -336,9 +377,18 @@ it8712f_wdt_find(unsigned short *address)
 	}
 
 	err = 0;
-	printk(KERN_DEBUG NAME ": Found IT%04xF chip revision %d - "
+	revision = superio_inb(DEVREV) & 0x0f;
+
+	/* Later revisions have 16-bit values per datasheet 0.9.1 */
+	if (revision >= 0x08)
+		max_units = 65535;
+
+	if (margin > (max_units * 60))
+		margin = (max_units * 60);
+
+	printk(KERN_INFO NAME ": Found IT%04xF chip revision %d - "
 		"using DogFood address 0x%x\n",
-		chip_type, superio_inb(DEVREV) & 0x0f, *address);
+		chip_type, revision, *address);
 
 exit:
 	superio_exit();
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index e6e07b4..6905135 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -141,7 +141,7 @@ static unsigned long next_heartbeat = 0;
 #ifndef ZF_DEBUG
 #	define dprintk(format, args...)
 #else
-#	define dprintk(format, args...) printk(KERN_DEBUG PFX ":%s:%d: " format, __FUNCTION__, __LINE__ , ## args)
+#	define dprintk(format, args...) printk(KERN_DEBUG PFX ":%s:%d: " format, __func__, __LINE__ , ## args)
 #endif
 
 
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 789831b..10b89f2 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -59,9 +59,9 @@ static int ticks = 100 * HZ;
 
 static struct {
 	struct completion stop;
-	volatile int running;
+	int running;
 	struct timer_list timer;
-	volatile int queue;
+	int queue;
 	int default_ticks;
 	unsigned long inuse;
 	unsigned gpio;
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index 0f3fd6c..bf443d0 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -179,11 +179,11 @@ static void usb_pcwd_intr_done(struct urb *urb)
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 		return;
 	/* -EPIPE:  should clear the halt */
 	default:		/* error */
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 		goto resubmit;
 	}
 
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 5d1c15f..7645e88 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -144,7 +144,7 @@ static int s3c2410wdt_start(void)
 	}
 
 	DBG("%s: wdt_count=0x%08x, wtcon=%08lx\n",
-	    __FUNCTION__, wdt_count, wtcon);
+	    __func__, wdt_count, wtcon);
 
 	writel(wdt_count, wdt_base + S3C2410_WTDAT);
 	writel(wdt_count, wdt_base + S3C2410_WTCNT);
@@ -167,7 +167,7 @@ static int s3c2410wdt_set_heartbeat(int timeout)
 	count = timeout * freq;
 
 	DBG("%s: count=%d, timeout=%d, freq=%d\n",
-	    __FUNCTION__, count, timeout, freq);
+	    __func__, count, timeout, freq);
 
 	/* if the count is bigger than the watchdog register,
 	   then work out what we need to do (and if) we can
@@ -189,7 +189,7 @@ static int s3c2410wdt_set_heartbeat(int timeout)
 	tmr_margin = timeout;
 
 	DBG("%s: timeout=%d, divisor=%d, count=%d (%08x)\n",
-	    __FUNCTION__, timeout, divisor, count, count/divisor);
+	    __func__, timeout, divisor, count, count/divisor);
 
 	count /= divisor;
 	wdt_count = count;
@@ -355,7 +355,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	int ret;
 	int size;
 
-	DBG("%s: probe=%p\n", __FUNCTION__, pdev);
+	DBG("%s: probe=%p\n", __func__, pdev);
 
 	dev = &pdev->dev;
 	wdt_dev = &pdev->dev;
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index 61dde86..1277f7e 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -298,7 +298,7 @@ static int sh_wdt_mmap(struct file *file, struct vm_area_struct *vma)
 	if (io_remap_pfn_range(vma, vma->vm_start, addr >> PAGE_SHIFT,
 			       PAGE_SIZE, vma->vm_page_prot)) {
 		printk(KERN_ERR PFX "%s: io_remap_pfn_range failed\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EAGAIN;
 	}
 
