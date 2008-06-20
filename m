Return-Path: <linux-kernel-owner+w=401wt.eu-S1764373AbYFTUbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764373AbYFTUbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760666AbYFTUVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:21:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35213 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761545AbYFTUVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:21:01 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 42/70] tty-usb-io_edgeport: Coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:03:32 +0100
Message-ID: <20080620200331.1479.1648.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/io_edgeport.c | 1965 +++++++++++++++++++++-----------------
 drivers/usb/serial/io_tables.h   |    6 
 2 files changed, 1107 insertions(+), 864 deletions(-)


diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 1d8d130..3cb2511 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -42,7 +42,7 @@
 #include <linux/serial.h>
 #include <linux/ioctl.h>
 #include <linux/wait.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include "io_edgeport.h"
@@ -59,14 +59,17 @@
 /* First, the latest boot code - for first generation edgeports */
 #define IMAGE_ARRAY_NAME	BootCodeImage_GEN1
 #define IMAGE_VERSION_NAME	BootCodeImageVersion_GEN1
-#include "io_fw_boot.h"		/* the bootloader firmware to download to a device, if it needs it */
+#include "io_fw_boot.h"		/* the bootloader firmware to download to
+				   a device, if it needs it */
 
 /* for second generation edgeports */
 #define IMAGE_ARRAY_NAME	BootCodeImage_GEN2
 #define IMAGE_VERSION_NAME	BootCodeImageVersion_GEN2
-#include "io_fw_boot2.h"	/* the bootloader firmware to download to a device, if it needs it */
+#include "io_fw_boot2.h"	/* the bootloader firmware to download to
+				   a device, if it needs it */
 
-/* Then finally the main run-time operational code - for first generation edgeports */
+/* Then finally the main run-time operational code - for first generation
+   edgeports */
 #define IMAGE_ARRAY_NAME	OperationalCodeImage_GEN1
 #define IMAGE_VERSION_NAME	OperationalCodeImageVersion_GEN1
 #include "io_fw_down.h"		/* Define array OperationalCodeImage[] */
@@ -84,16 +87,16 @@
 
 /* receive port state */
 enum RXSTATE {
-	EXPECT_HDR1 = 0,	/* Expect header byte 1 */
-	EXPECT_HDR2 = 1,	/* Expect header byte 2 */
-	EXPECT_DATA = 2,	/* Expect 'RxBytesRemaining' data */
-	EXPECT_HDR3 = 3,	/* Expect header byte 3 (for status hdrs only) */
+	EXPECT_HDR1 = 0,    /* Expect header byte 1 */
+	EXPECT_HDR2 = 1,    /* Expect header byte 2 */
+	EXPECT_DATA = 2,    /* Expect 'RxBytesRemaining' data */
+	EXPECT_HDR3 = 3,    /* Expect header byte 3 (for status hdrs only) */
 };
 
 
-/* Transmit Fifo 
- * This Transmit queue is an extension of the edgeport Rx buffer. 
- * The maximum amount of data buffered in both the edgeport 
+/* Transmit Fifo
+ * This Transmit queue is an extension of the edgeport Rx buffer.
+ * The maximum amount of data buffered in both the edgeport
  * Rx buffer (maxTxCredits) and this buffer will never exceed maxTxCredits.
  */
 struct TxFifo {
@@ -150,12 +153,12 @@ struct edgeport_serial {
 	int			is_epic;			/* flag if EPiC device or not */
 
 	__u8			interrupt_in_endpoint;		/* the interrupt endpoint handle */
-	unsigned char *		interrupt_in_buffer;		/* the buffer we use for the interrupt endpoint */
-	struct urb *		interrupt_read_urb;		/* our interrupt urb */
+	unsigned char		*interrupt_in_buffer;		/* the buffer we use for the interrupt endpoint */
+	struct urb		*interrupt_read_urb;		/* our interrupt urb */
 
 	__u8			bulk_in_endpoint;		/* the bulk in endpoint handle */
-	unsigned char *		bulk_in_buffer;			/* the buffer we use for the bulk in endpoint */
-	struct urb *		read_urb;			/* our bulk read urb */
+	unsigned char		*bulk_in_buffer;		/* the buffer we use for the bulk in endpoint */
+	struct urb		*read_urb;			/* our bulk read urb */
 	bool			read_in_progress;
 	spinlock_t		es_lock;
 
@@ -180,16 +183,17 @@ struct divisor_table_entry {
 	__u16  Divisor;
 };
 
-//
-// Define table of divisors for Rev A EdgePort/4 hardware
-// These assume a 3.6864MHz crystal, the standard /16, and
-// MCR.7 = 0.
-//
+/*
+ * Define table of divisors for Rev A EdgePort/4 hardware
+ * These assume a 3.6864MHz crystal, the standard /16, and
+ * MCR.7 = 0.
+ */
+
 static const struct divisor_table_entry divisor_table[] = {
-	{   50,		4608},  
-	{   75,		3072},  
-	{   110,	2095},		/* 2094.545455 => 230450   => .0217 % over */
-	{   134,	1713},		/* 1713.011152 => 230398.5 => .00065% under */
+	{   50,		4608},
+	{   75,		3072},
+	{   110,	2095},	/* 2094.545455 => 230450   => .0217 % over */
+	{   134,	1713},	/* 1713.011152 => 230398.5 => .00065% under */
 	{   150,	1536},
 	{   300,	768},
 	{   600,	384},
@@ -212,65 +216,86 @@ static int debug;
 
 static int low_latency = 1;	/* tty low latency flag, on by default */
 
-static atomic_t CmdUrbs;		/* Number of outstanding Command Write Urbs */
+static atomic_t CmdUrbs;	/* Number of outstanding Command Write Urbs */
 
 
 /* local function prototypes */
 
 /* function prototypes for all URB callbacks */
-static void edge_interrupt_callback	(struct urb *urb);
-static void edge_bulk_in_callback	(struct urb *urb);
-static void edge_bulk_out_data_callback	(struct urb *urb);
-static void edge_bulk_out_cmd_callback	(struct urb *urb);
+static void edge_interrupt_callback(struct urb *urb);
+static void edge_bulk_in_callback(struct urb *urb);
+static void edge_bulk_out_data_callback(struct urb *urb);
+static void edge_bulk_out_cmd_callback(struct urb *urb);
 
 /* function prototypes for the usbserial callbacks */
-static int  edge_open			(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static void edge_close			(struct tty_struct *tty, struct usb_serial_port *port, struct file *filp);
-static int  edge_write			(struct tty_struct *tty, struct usb_serial_port *port, const unsigned char *buf, int count);
-static int  edge_write_room		(struct tty_struct *tty);
-static int  edge_chars_in_buffer	(struct tty_struct *tty);
-static void edge_throttle		(struct tty_struct *tty);
-static void edge_unthrottle		(struct tty_struct *tty);
-static void edge_set_termios		(struct tty_struct *tty, struct usb_serial_port *port, struct ktermios *old_termios);
-static int  edge_ioctl			(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg);
-static void edge_break			(struct tty_struct *tty, int break_state);
-static int  edge_tiocmget		(struct tty_struct *tty, struct file *file);
-static int  edge_tiocmset		(struct tty_struct *tty, struct file *file, unsigned int set, unsigned int clear);
-static int  edge_startup		(struct usb_serial *serial);
-static void edge_shutdown		(struct usb_serial *serial);
+static int edge_open(struct tty_struct *tty, struct usb_serial_port *port,
+					struct file *filp);
+static void edge_close(struct tty_struct *tty, struct usb_serial_port *port,
+					struct file *filp);
+static int edge_write(struct tty_struct *tty, struct usb_serial_port *port,
+					const unsigned char *buf, int count);
+static int edge_write_room(struct tty_struct *tty);
+static int edge_chars_in_buffer(struct tty_struct *tty);
+static void edge_throttle(struct tty_struct *tty);
+static void edge_unthrottle(struct tty_struct *tty);
+static void edge_set_termios(struct tty_struct *tty,
+					struct usb_serial_port *port,
+					struct ktermios *old_termios);
+static int  edge_ioctl(struct tty_struct *tty, struct file *file,
+					unsigned int cmd, unsigned long arg);
+static void edge_break(struct tty_struct *tty, int break_state);
+static int  edge_tiocmget(struct tty_struct *tty, struct file *file);
+static int  edge_tiocmset(struct tty_struct *tty, struct file *file,
+					unsigned int set, unsigned int clear);
+static int  edge_startup(struct usb_serial *serial);
+static void edge_shutdown(struct usb_serial *serial);
 
 
 #include "io_tables.h"	/* all of the devices that this driver supports */
 
 /* function prototypes for all of our local functions */
-static void  process_rcvd_data		(struct edgeport_serial *edge_serial, unsigned char *buffer, __u16 bufferLength);
-static void process_rcvd_status		(struct edgeport_serial *edge_serial, __u8 byte2, __u8 byte3);
-static void edge_tty_recv			(struct device *dev, struct tty_struct *tty, unsigned char *data, int length);
-static void handle_new_msr		(struct edgeport_port *edge_port, __u8 newMsr);
-static void handle_new_lsr		(struct edgeport_port *edge_port, __u8 lsrData, __u8 lsr, __u8 data);
-static int  send_iosp_ext_cmd		(struct edgeport_port *edge_port, __u8 command, __u8 param);
-static int  calc_baud_rate_divisor	(int baud_rate, int *divisor);
-static int  send_cmd_write_baud_rate	(struct edgeport_port *edge_port, int baudRate);
-static void change_port_settings	(struct tty_struct *tty, struct edgeport_port *edge_port,
-					 struct ktermios *old_termios);
-static int  send_cmd_write_uart_register	(struct edgeport_port *edge_port, __u8 regNum, __u8 regValue);
-static int  write_cmd_usb		(struct edgeport_port *edge_port, unsigned char *buffer, int writeLength);
-static void send_more_port_data		(struct edgeport_serial *edge_serial, struct edgeport_port *edge_port);
-
-static int  sram_write			(struct usb_serial *serial, __u16 extAddr, __u16 addr, __u16 length, __u8 *data);
-static int  rom_read			(struct usb_serial *serial, __u16 extAddr, __u16 addr, __u16 length, __u8 *data);
-static int  rom_write			(struct usb_serial *serial, __u16 extAddr, __u16 addr, __u16 length, __u8 *data);
-static void get_manufacturing_desc	(struct edgeport_serial *edge_serial);
-static void get_boot_desc		(struct edgeport_serial *edge_serial);
-static void load_application_firmware	(struct edgeport_serial *edge_serial);
-
-static void unicode_to_ascii(char *string, int buflen, __le16 *unicode, int unicode_size);
-
-
-// ************************************************************************
-// ************************************************************************
-// ************************************************************************
-// ************************************************************************
+static void  process_rcvd_data(struct edgeport_serial *edge_serial,
+				unsigned char *buffer, __u16 bufferLength);
+static void process_rcvd_status(struct edgeport_serial *edge_serial,
+				__u8 byte2, __u8 byte3);
+static void edge_tty_recv(struct device *dev, struct tty_struct *tty,
+				unsigned char *data, int length);
+static void handle_new_msr(struct edgeport_port *edge_port, __u8 newMsr);
+static void handle_new_lsr(struct edgeport_port *edge_port, __u8 lsrData,
+				__u8 lsr, __u8 data);
+static int  send_iosp_ext_cmd(struct edgeport_port *edge_port, __u8 command,
+				__u8 param);
+static int  calc_baud_rate_divisor(int baud_rate, int *divisor);
+static int  send_cmd_write_baud_rate(struct edgeport_port *edge_port,
+				int baudRate);
+static void change_port_settings(struct tty_struct *tty,
+				struct edgeport_port *edge_port,
+				struct ktermios *old_termios);
+static int  send_cmd_write_uart_register(struct edgeport_port *edge_port,
+				__u8 regNum, __u8 regValue);
+static int  write_cmd_usb(struct edgeport_port *edge_port,
+				unsigned char *buffer, int writeLength);
+static void send_more_port_data(struct edgeport_serial *edge_serial,
+				struct edgeport_port *edge_port);
+
+static int sram_write(struct usb_serial *serial, __u16 extAddr, __u16 addr,
+						__u16 length, __u8 *data);
+static int rom_read(struct usb_serial *serial, __u16 extAddr, __u16 addr,
+						__u16 length, __u8 *data);
+static int rom_write(struct usb_serial *serial, __u16 extAddr, __u16 addr,
+						__u16 length, __u8 *data);
+static void get_manufacturing_desc(struct edgeport_serial *edge_serial);
+static void get_boot_desc(struct edgeport_serial *edge_serial);
+static void load_application_firmware(struct edgeport_serial *edge_serial);
+
+static void unicode_to_ascii(char *string, int buflen,
+				__le16 *unicode, int unicode_size);
+
+
+/* ************************************************************************ */
+/* ************************************************************************ */
+/* ************************************************************************ */
+/* ************************************************************************ */
 
 /************************************************************************
  *									*
@@ -280,42 +305,43 @@ static void unicode_to_ascii(char *string, int buflen, __le16 *unicode, int unic
  *				embedded in this driver			*
  *									*
  ************************************************************************/
-static void update_edgeport_E2PROM (struct edgeport_serial *edge_serial)
+static void update_edgeport_E2PROM(struct edgeport_serial *edge_serial)
 {
 	__u32 BootCurVer;
 	__u32 BootNewVer;
-	__u8 BootMajorVersion;                  
-	__u8 BootMinorVersion;                  
+	__u8 BootMajorVersion;
+	__u8 BootMinorVersion;
 	__le16 BootBuildNumber;
-	__u8 *BootImage;      
+	__u8 *BootImage;
 	__u32 BootSize;
 	struct edge_firmware_image_record *record;
 	unsigned char *firmware;
 	int response;
 
-
 	switch (edge_serial->product_info.iDownloadFile) {
-		case EDGE_DOWNLOAD_FILE_I930:
-			BootMajorVersion	= BootCodeImageVersion_GEN1.MajorVersion;
-			BootMinorVersion	= BootCodeImageVersion_GEN1.MinorVersion;
-			BootBuildNumber		= cpu_to_le16(BootCodeImageVersion_GEN1.BuildNumber);
-			BootImage		= &BootCodeImage_GEN1[0];
-			BootSize		= sizeof( BootCodeImage_GEN1 );
-			break;
+	case EDGE_DOWNLOAD_FILE_I930:
+		BootMajorVersion = BootCodeImageVersion_GEN1.MajorVersion;
+		BootMinorVersion = BootCodeImageVersion_GEN1.MinorVersion;
+		BootBuildNumber	=
+			cpu_to_le16(BootCodeImageVersion_GEN1.BuildNumber);
+		BootImage = &BootCodeImage_GEN1[0];
+		BootSize = sizeof(BootCodeImage_GEN1);
+		break;
 
-		case EDGE_DOWNLOAD_FILE_80251:
-			BootMajorVersion	= BootCodeImageVersion_GEN2.MajorVersion;
-			BootMinorVersion	= BootCodeImageVersion_GEN2.MinorVersion;
-			BootBuildNumber		= cpu_to_le16(BootCodeImageVersion_GEN2.BuildNumber);
-			BootImage		= &BootCodeImage_GEN2[0];
-			BootSize		= sizeof( BootCodeImage_GEN2 );
-			break;
+	case EDGE_DOWNLOAD_FILE_80251:
+		BootMajorVersion = BootCodeImageVersion_GEN2.MajorVersion;
+		BootMinorVersion = BootCodeImageVersion_GEN2.MinorVersion;
+		BootBuildNumber =
+			 cpu_to_le16(BootCodeImageVersion_GEN2.BuildNumber);
+		BootImage = &BootCodeImage_GEN2[0];
+		BootSize = sizeof(BootCodeImage_GEN2);
+		break;
 
-		default:
-			return;
+	default:
+		return;
 	}
 
-	// Check Boot Image Version
+	/* Check Boot Image Version */
 	BootCurVer = (edge_serial->boot_descriptor.MajorVersion << 24) +
 		     (edge_serial->boot_descriptor.MinorVersion << 16) +
 		      le16_to_cpu(edge_serial->boot_descriptor.BuildNumber);
@@ -346,19 +372,26 @@ static void update_edgeport_E2PROM (struct edgeport_serial *edge_serial)
 
 		for (;;) {
 			record = (struct edge_firmware_image_record *)firmware;
-			response = rom_write (edge_serial->serial, le16_to_cpu(record->ExtAddr), le16_to_cpu(record->Addr), le16_to_cpu(record->Len), &record->Data[0]);
+			response = rom_write(edge_serial->serial,
+						le16_to_cpu(record->ExtAddr),
+						le16_to_cpu(record->Addr),
+						le16_to_cpu(record->Len),
+						&record->Data[0]);
 			if (response < 0) {
-				dev_err(&edge_serial->serial->dev->dev, "rom_write failed (%x, %x, %d)\n", le16_to_cpu(record->ExtAddr), le16_to_cpu(record->Addr), le16_to_cpu(record->Len));
+				dev_err(&edge_serial->serial->dev->dev,
+					"rom_write failed (%x, %x, %d)\n",
+						le16_to_cpu(record->ExtAddr),
+						le16_to_cpu(record->Addr),
+						le16_to_cpu(record->Len));
 				break;
 			}
-			firmware += sizeof (struct edge_firmware_image_record) + le16_to_cpu(record->Len);
-			if (firmware >= &BootImage[BootSize]) {
+			firmware += sizeof(struct edge_firmware_image_record)
+						+ le16_to_cpu(record->Len);
+			if (firmware >= &BootImage[BootSize])
 				break;
-			}
 		}
-	} else {
+	} else
 		dbg("Boot Image -- already up to date");
-	}
 }
 
 
@@ -367,29 +400,29 @@ static void update_edgeport_E2PROM (struct edgeport_serial *edge_serial)
  *  Get string descriptor from device					*
  *									*
  ************************************************************************/
-static int get_string (struct usb_device *dev, int Id, char *string, int buflen)
+static int get_string(struct usb_device *dev, int Id, char *string, int buflen)
 {
 	struct usb_string_descriptor StringDesc;
 	struct usb_string_descriptor *pStringDesc;
 
-	dbg("%s - USB String ID = %d", __func__, Id );
+	dbg("%s - USB String ID = %d", __func__, Id);
 
-	if (!usb_get_descriptor(dev, USB_DT_STRING, Id, &StringDesc, sizeof(StringDesc))) {
+	if (!usb_get_descriptor(dev, USB_DT_STRING, Id,
+					&StringDesc, sizeof(StringDesc)))
 		return 0;
-	}
-
-	pStringDesc = kmalloc (StringDesc.bLength, GFP_KERNEL);
 
-	if (!pStringDesc) {
+	pStringDesc = kmalloc(StringDesc.bLength, GFP_KERNEL);
+	if (!pStringDesc)
 		return 0;
-	}
 
-	if (!usb_get_descriptor(dev, USB_DT_STRING, Id, pStringDesc, StringDesc.bLength )) {
+	if (!usb_get_descriptor(dev, USB_DT_STRING, Id,
+					pStringDesc, StringDesc.bLength)) {
 		kfree(pStringDesc);
 		return 0;
 	}
 
-	unicode_to_ascii(string, buflen, pStringDesc->wData, pStringDesc->bLength/2);
+	unicode_to_ascii(string, buflen,
+				pStringDesc->wData, pStringDesc->bLength/2);
 
 	kfree(pStringDesc);
 	dbg("%s - USB String %s", __func__, string);
@@ -403,24 +436,24 @@ static int get_string (struct usb_device *dev, int Id, char *string, int buflen)
  *  Get string descriptor from device
  *
  ************************************************************************/
-static int get_string_desc (struct usb_device *dev, int Id, struct usb_string_descriptor **pRetDesc)
+static int get_string_desc(struct usb_device *dev, int Id,
+				struct usb_string_descriptor **pRetDesc)
 {
 	struct usb_string_descriptor StringDesc;
 	struct usb_string_descriptor *pStringDesc;
 
-	dbg("%s - USB String ID = %d", __func__, Id );
+	dbg("%s - USB String ID = %d", __func__, Id);
 
-	if (!usb_get_descriptor(dev, USB_DT_STRING, Id, &StringDesc, sizeof(StringDesc))) {
+	if (!usb_get_descriptor(dev, USB_DT_STRING, Id, &StringDesc,
+						sizeof(StringDesc)))
 		return 0;
-	}
-
-	pStringDesc = kmalloc (StringDesc.bLength, GFP_KERNEL);
 
-	if (!pStringDesc) {
+	pStringDesc = kmalloc(StringDesc.bLength, GFP_KERNEL);
+	if (!pStringDesc)
 		return -1;
-	}
 
-	if (!usb_get_descriptor(dev, USB_DT_STRING, Id, pStringDesc, StringDesc.bLength )) {
+	if (!usb_get_descriptor(dev, USB_DT_STRING, Id, pStringDesc,
+							StringDesc.bLength)) {
 		kfree(pStringDesc);
 		return -1;
 	}
@@ -432,28 +465,30 @@ static int get_string_desc (struct usb_device *dev, int Id, struct usb_string_de
 
 static void dump_product_info(struct edgeport_product_info *product_info)
 {
-	// Dump Product Info structure
+	/* Dump Product Info structure */
 	dbg("**Product Information:");
-	dbg("  ProductId             %x", product_info->ProductId );
-	dbg("  NumPorts              %d", product_info->NumPorts );
-	dbg("  ProdInfoVer           %d", product_info->ProdInfoVer );
+	dbg("  ProductId             %x", product_info->ProductId);
+	dbg("  NumPorts              %d", product_info->NumPorts);
+	dbg("  ProdInfoVer           %d", product_info->ProdInfoVer);
 	dbg("  IsServer              %d", product_info->IsServer);
-	dbg("  IsRS232               %d", product_info->IsRS232 );
-	dbg("  IsRS422               %d", product_info->IsRS422 );
-	dbg("  IsRS485               %d", product_info->IsRS485 );
-	dbg("  RomSize               %d", product_info->RomSize );
-	dbg("  RamSize               %d", product_info->RamSize );
-	dbg("  CpuRev                %x", product_info->CpuRev  );
+	dbg("  IsRS232               %d", product_info->IsRS232);
+	dbg("  IsRS422               %d", product_info->IsRS422);
+	dbg("  IsRS485               %d", product_info->IsRS485);
+	dbg("  RomSize               %d", product_info->RomSize);
+	dbg("  RamSize               %d", product_info->RamSize);
+	dbg("  CpuRev                %x", product_info->CpuRev);
 	dbg("  BoardRev              %x", product_info->BoardRev);
 	dbg("  BootMajorVersion      %d.%d.%d", product_info->BootMajorVersion,
 	    product_info->BootMinorVersion,
 	    le16_to_cpu(product_info->BootBuildNumber));
-	dbg("  FirmwareMajorVersion  %d.%d.%d", product_info->FirmwareMajorVersion,
-	    product_info->FirmwareMinorVersion,
-	    le16_to_cpu(product_info->FirmwareBuildNumber));
-	dbg("  ManufactureDescDate   %d/%d/%d", product_info->ManufactureDescDate[0],
-	    product_info->ManufactureDescDate[1],
-	    product_info->ManufactureDescDate[2]+1900);
+	dbg("  FirmwareMajorVersion  %d.%d.%d",
+			product_info->FirmwareMajorVersion,
+			product_info->FirmwareMinorVersion,
+			le16_to_cpu(product_info->FirmwareBuildNumber));
+	dbg("  ManufactureDescDate   %d/%d/%d",
+			product_info->ManufactureDescDate[0],
+			product_info->ManufactureDescDate[1],
+			product_info->ManufactureDescDate[2]+1900);
 	dbg("  iDownloadFile         0x%x", product_info->iDownloadFile);
 	dbg("  EpicVer               %d", product_info->EpicVer);
 }
@@ -462,61 +497,73 @@ static void get_product_info(struct edgeport_serial *edge_serial)
 {
 	struct edgeport_product_info *product_info = &edge_serial->product_info;
 
-	memset (product_info, 0, sizeof(struct edgeport_product_info));
-
-	product_info->ProductId		= (__u16)(le16_to_cpu(edge_serial->serial->dev->descriptor.idProduct) & ~ION_DEVICE_ID_80251_NETCHIP);
-	product_info->NumPorts		= edge_serial->manuf_descriptor.NumPorts;
-	product_info->ProdInfoVer	= 0;
-
-	product_info->RomSize		= edge_serial->manuf_descriptor.RomSize;
-	product_info->RamSize		= edge_serial->manuf_descriptor.RamSize;
-	product_info->CpuRev		= edge_serial->manuf_descriptor.CpuRev;
-	product_info->BoardRev		= edge_serial->manuf_descriptor.BoardRev;
-
-	product_info->BootMajorVersion	= edge_serial->boot_descriptor.MajorVersion;
-	product_info->BootMinorVersion	= edge_serial->boot_descriptor.MinorVersion;
-	product_info->BootBuildNumber	= edge_serial->boot_descriptor.BuildNumber;
-
-	memcpy(product_info->ManufactureDescDate, edge_serial->manuf_descriptor.DescDate, sizeof(edge_serial->manuf_descriptor.DescDate));
-
-	// check if this is 2nd generation hardware
-	if (le16_to_cpu(edge_serial->serial->dev->descriptor.idProduct) & ION_DEVICE_ID_80251_NETCHIP) {
-		product_info->FirmwareMajorVersion	= OperationalCodeImageVersion_GEN2.MajorVersion;
-		product_info->FirmwareMinorVersion	= OperationalCodeImageVersion_GEN2.MinorVersion;
-		product_info->FirmwareBuildNumber	= cpu_to_le16(OperationalCodeImageVersion_GEN2.BuildNumber);
-		product_info->iDownloadFile		= EDGE_DOWNLOAD_FILE_80251;
+	memset(product_info, 0, sizeof(struct edgeport_product_info));
+
+	product_info->ProductId = (__u16)(le16_to_cpu(edge_serial->serial->dev->descriptor.idProduct) & ~ION_DEVICE_ID_80251_NETCHIP);
+	product_info->NumPorts = edge_serial->manuf_descriptor.NumPorts;
+	product_info->ProdInfoVer = 0;
+
+	product_info->RomSize = edge_serial->manuf_descriptor.RomSize;
+	product_info->RamSize = edge_serial->manuf_descriptor.RamSize;
+	product_info->CpuRev = edge_serial->manuf_descriptor.CpuRev;
+	product_info->BoardRev = edge_serial->manuf_descriptor.BoardRev;
+
+	product_info->BootMajorVersion =
+				edge_serial->boot_descriptor.MajorVersion;
+	product_info->BootMinorVersion =
+				edge_serial->boot_descriptor.MinorVersion;
+	product_info->BootBuildNumber =
+				edge_serial->boot_descriptor.BuildNumber;
+
+	memcpy(product_info->ManufactureDescDate,
+			edge_serial->manuf_descriptor.DescDate,
+			sizeof(edge_serial->manuf_descriptor.DescDate));
+
+	/* check if this is 2nd generation hardware */
+	if (le16_to_cpu(edge_serial->serial->dev->descriptor.idProduct)
+					    & ION_DEVICE_ID_80251_NETCHIP) {
+		product_info->FirmwareMajorVersion =
+				OperationalCodeImageVersion_GEN2.MajorVersion;
+		product_info->FirmwareMinorVersion =
+				OperationalCodeImageVersion_GEN2.MinorVersion;
+		product_info->FirmwareBuildNumber =
+		    cpu_to_le16(OperationalCodeImageVersion_GEN2.BuildNumber);
+		product_info->iDownloadFile = EDGE_DOWNLOAD_FILE_80251;
 	} else {
-		product_info->FirmwareMajorVersion	= OperationalCodeImageVersion_GEN1.MajorVersion;
-		product_info->FirmwareMinorVersion	= OperationalCodeImageVersion_GEN1.MinorVersion;
-		product_info->FirmwareBuildNumber	= cpu_to_le16(OperationalCodeImageVersion_GEN1.BuildNumber);
-		product_info->iDownloadFile		= EDGE_DOWNLOAD_FILE_I930;
+		product_info->FirmwareMajorVersion =
+				OperationalCodeImageVersion_GEN1.MajorVersion;
+		product_info->FirmwareMinorVersion =
+				OperationalCodeImageVersion_GEN1.MinorVersion;
+		product_info->FirmwareBuildNumber =
+		    cpu_to_le16(OperationalCodeImageVersion_GEN1.BuildNumber);
+		product_info->iDownloadFile = EDGE_DOWNLOAD_FILE_I930;
 	}
 
-	// Determine Product type and set appropriate flags
+	/* Determine Product type and set appropriate flags */
 	switch (DEVICE_ID_FROM_USB_PRODUCT_ID(product_info->ProductId)) {
-		case ION_DEVICE_ID_EDGEPORT_COMPATIBLE:
-		case ION_DEVICE_ID_EDGEPORT_4T:
-		case ION_DEVICE_ID_EDGEPORT_4:
-		case ION_DEVICE_ID_EDGEPORT_2:
-		case ION_DEVICE_ID_EDGEPORT_8_DUAL_CPU:
-		case ION_DEVICE_ID_EDGEPORT_8:
-		case ION_DEVICE_ID_EDGEPORT_421:
-		case ION_DEVICE_ID_EDGEPORT_21:
-		case ION_DEVICE_ID_EDGEPORT_2_DIN:
-		case ION_DEVICE_ID_EDGEPORT_4_DIN:
-		case ION_DEVICE_ID_EDGEPORT_16_DUAL_CPU:
-			product_info->IsRS232 = 1;
-			break;
+	case ION_DEVICE_ID_EDGEPORT_COMPATIBLE:
+	case ION_DEVICE_ID_EDGEPORT_4T:
+	case ION_DEVICE_ID_EDGEPORT_4:
+	case ION_DEVICE_ID_EDGEPORT_2:
+	case ION_DEVICE_ID_EDGEPORT_8_DUAL_CPU:
+	case ION_DEVICE_ID_EDGEPORT_8:
+	case ION_DEVICE_ID_EDGEPORT_421:
+	case ION_DEVICE_ID_EDGEPORT_21:
+	case ION_DEVICE_ID_EDGEPORT_2_DIN:
+	case ION_DEVICE_ID_EDGEPORT_4_DIN:
+	case ION_DEVICE_ID_EDGEPORT_16_DUAL_CPU:
+		product_info->IsRS232 = 1;
+		break;
 
-		case ION_DEVICE_ID_EDGEPORT_2I:				   // Edgeport/2 RS422/RS485
-			product_info->IsRS422 = 1;
-			product_info->IsRS485 = 1;
-			break;
+	case ION_DEVICE_ID_EDGEPORT_2I:	/* Edgeport/2 RS422/RS485 */
+		product_info->IsRS422 = 1;
+		product_info->IsRS485 = 1;
+		break;
 
-		case ION_DEVICE_ID_EDGEPORT_8I:				   // Edgeport/4 RS422
-		case ION_DEVICE_ID_EDGEPORT_4I:				   // Edgeport/4 RS422
-			product_info->IsRS422 = 1;
-			break;
+	case ION_DEVICE_ID_EDGEPORT_8I:	/* Edgeport/4 RS422 */
+	case ION_DEVICE_ID_EDGEPORT_4I:	/* Edgeport/4 RS422 */
+		product_info->IsRS422 = 1;
+		break;
 	}
 
 	dump_product_info(product_info);
@@ -544,32 +591,32 @@ static int get_epic_descriptor(struct edgeport_serial *ep)
 		ep->is_epic = 1;
 		memset(product_info, 0, sizeof(struct edgeport_product_info));
 
-		product_info->NumPorts			= epic->NumPorts;
-		product_info->ProdInfoVer		= 0;
-		product_info->FirmwareMajorVersion	= epic->MajorVersion;
-		product_info->FirmwareMinorVersion	= epic->MinorVersion;
-		product_info->FirmwareBuildNumber	= epic->BuildNumber;
-		product_info->iDownloadFile		= epic->iDownloadFile;
-		product_info->EpicVer			= epic->EpicVer;
-		product_info->Epic			= epic->Supports;
-		product_info->ProductId			= ION_DEVICE_ID_EDGEPORT_COMPATIBLE;
+		product_info->NumPorts = epic->NumPorts;
+		product_info->ProdInfoVer = 0;
+		product_info->FirmwareMajorVersion = epic->MajorVersion;
+		product_info->FirmwareMinorVersion = epic->MinorVersion;
+		product_info->FirmwareBuildNumber = epic->BuildNumber;
+		product_info->iDownloadFile = epic->iDownloadFile;
+		product_info->EpicVer = epic->EpicVer;
+		product_info->Epic = epic->Supports;
+		product_info->ProductId = ION_DEVICE_ID_EDGEPORT_COMPATIBLE;
 		dump_product_info(product_info);
 
 		bits = &ep->epic_descriptor.Supports;
 		dbg("**EPIC descriptor:");
 		dbg("  VendEnableSuspend: %s", bits->VendEnableSuspend	? "TRUE": "FALSE");
-		dbg("  IOSPOpen         : %s", bits->IOSPOpen		? "TRUE": "FALSE" );
-		dbg("  IOSPClose        : %s", bits->IOSPClose		? "TRUE": "FALSE" );
-		dbg("  IOSPChase        : %s", bits->IOSPChase		? "TRUE": "FALSE" );
-		dbg("  IOSPSetRxFlow    : %s", bits->IOSPSetRxFlow	? "TRUE": "FALSE" );
-		dbg("  IOSPSetTxFlow    : %s", bits->IOSPSetTxFlow	? "TRUE": "FALSE" );
-		dbg("  IOSPSetXChar     : %s", bits->IOSPSetXChar	? "TRUE": "FALSE" );
-		dbg("  IOSPRxCheck      : %s", bits->IOSPRxCheck	? "TRUE": "FALSE" );
-		dbg("  IOSPSetClrBreak  : %s", bits->IOSPSetClrBreak	? "TRUE": "FALSE" );
-		dbg("  IOSPWriteMCR     : %s", bits->IOSPWriteMCR	? "TRUE": "FALSE" );
-		dbg("  IOSPWriteLCR     : %s", bits->IOSPWriteLCR	? "TRUE": "FALSE" );
-		dbg("  IOSPSetBaudRate  : %s", bits->IOSPSetBaudRate	? "TRUE": "FALSE" );
-		dbg("  TrueEdgeport     : %s", bits->TrueEdgeport	? "TRUE": "FALSE" );
+		dbg("  IOSPOpen         : %s", bits->IOSPOpen		? "TRUE": "FALSE");
+		dbg("  IOSPClose        : %s", bits->IOSPClose		? "TRUE": "FALSE");
+		dbg("  IOSPChase        : %s", bits->IOSPChase		? "TRUE": "FALSE");
+		dbg("  IOSPSetRxFlow    : %s", bits->IOSPSetRxFlow	? "TRUE": "FALSE");
+		dbg("  IOSPSetTxFlow    : %s", bits->IOSPSetTxFlow	? "TRUE": "FALSE");
+		dbg("  IOSPSetXChar     : %s", bits->IOSPSetXChar	? "TRUE": "FALSE");
+		dbg("  IOSPRxCheck      : %s", bits->IOSPRxCheck	? "TRUE": "FALSE");
+		dbg("  IOSPSetClrBreak  : %s", bits->IOSPSetClrBreak	? "TRUE": "FALSE");
+		dbg("  IOSPWriteMCR     : %s", bits->IOSPWriteMCR	? "TRUE": "FALSE");
+		dbg("  IOSPWriteLCR     : %s", bits->IOSPWriteLCR	? "TRUE": "FALSE");
+		dbg("  IOSPSetBaudRate  : %s", bits->IOSPSetBaudRate	? "TRUE": "FALSE");
+		dbg("  TrueEdgeport     : %s", bits->TrueEdgeport	? "TRUE": "FALSE");
 	}
 
 	return result;
@@ -585,10 +632,10 @@ static int get_epic_descriptor(struct edgeport_serial *ep)
 
 /*****************************************************************************
  * edge_interrupt_callback
- *	this is the callback function for when we have received data on the 
+ *	this is the callback function for when we have received data on the
  *	interrupt endpoint.
  *****************************************************************************/
-static void edge_interrupt_callback (struct urb *urb)
+static void edge_interrupt_callback(struct urb *urb)
 {
 	struct edgeport_serial	*edge_serial = urb->context;
 	struct edgeport_port *edge_port;
@@ -613,17 +660,17 @@ static void edge_interrupt_callback (struct urb *urb)
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
 		dbg("%s - urb shutting down with status: %d",
-		    __func__, status);
+						__func__, status);
 		return;
 	default:
-		dbg("%s - nonzero urb status received: %d",
-		    __func__, status);
+		dbg("%s - nonzero urb status received: %d", __func__, status);
 		goto exit;
 	}
 
-	// process this interrupt-read even if there are no ports open
+	/* process this interrupt-read even if there are no ports open */
 	if (length) {
-		usb_serial_debug_data(debug, &edge_serial->serial->dev->dev, __func__, length, data);
+		usb_serial_debug_data(debug, &edge_serial->serial->dev->dev,
+						__func__, length, data);
 
 		if (length > 1) {
 			bytes_avail = data[0] | (data[1] << 8);
@@ -637,7 +684,8 @@ static void edge_interrupt_callback (struct urb *urb)
 					dbg("%s - posting a read", __func__);
 					edge_serial->read_in_progress = true;
 
-					/* we have pending bytes on the bulk in pipe, send a request */
+					/* we have pending bytes on the
+					   bulk in pipe, send a request */
 					edge_serial->read_urb->dev = edge_serial->serial->dev;
 					result = usb_submit_urb(edge_serial->read_urb, GFP_ATOMIC);
 					if (result) {
@@ -651,7 +699,8 @@ static void edge_interrupt_callback (struct urb *urb)
 		/* grab the txcredits for the ports if available */
 		position = 2;
 		portNumber = 0;
-		while ((position < length) && (portNumber < edge_serial->serial->num_ports)) {
+		while ((position < length) &&
+				(portNumber < edge_serial->serial->num_ports)) {
 			txCredits = data[position] | (data[position+1] << 8);
 			if (txCredits) {
 				port = edge_serial->serial->port[portNumber];
@@ -660,14 +709,19 @@ static void edge_interrupt_callback (struct urb *urb)
 					spin_lock(&edge_port->ep_lock);
 					edge_port->txCredits += txCredits;
 					spin_unlock(&edge_port->ep_lock);
-					dbg("%s - txcredits for port%d = %d", __func__, portNumber, edge_port->txCredits);
+					dbg("%s - txcredits for port%d = %d",
+							__func__, portNumber,
+							edge_port->txCredits);
 
-					/* tell the tty driver that something has changed */
+					/* tell the tty driver that something
+					   has changed */
 					if (edge_port->port->port.tty)
 						tty_wakeup(edge_port->port->port.tty);
 
-					// Since we have more credit, check if more data can be sent
-					send_more_port_data(edge_serial, edge_port);
+					/* Since we have more credit, check
+					   if more data can be sent */
+					send_more_port_data(edge_serial,
+								edge_port);
 				}
 			}
 			position += 2;
@@ -676,19 +730,20 @@ static void edge_interrupt_callback (struct urb *urb)
 	}
 
 exit:
-	result = usb_submit_urb (urb, GFP_ATOMIC);
-	if (result) {
-		dev_err(&urb->dev->dev, "%s - Error %d submitting control urb\n", __func__, result);
-	}
+	result = usb_submit_urb(urb, GFP_ATOMIC);
+	if (result)
+		dev_err(&urb->dev->dev,
+			"%s - Error %d submitting control urb\n",
+						__func__, result);
 }
 
 
 /*****************************************************************************
  * edge_bulk_in_callback
- *	this is the callback function for when we have received data on the 
+ *	this is the callback function for when we have received data on the
  *	bulk in endpoint.
  *****************************************************************************/
-static void edge_bulk_in_callback (struct urb *urb)
+static void edge_bulk_in_callback(struct urb *urb)
 {
 	struct edgeport_serial	*edge_serial = urb->context;
 	unsigned char		*data = urb->transfer_buffer;
@@ -713,16 +768,18 @@ static void edge_bulk_in_callback (struct urb *urb)
 
 	raw_data_length = urb->actual_length;
 
-	usb_serial_debug_data(debug, &edge_serial->serial->dev->dev, __func__, raw_data_length, data);
+	usb_serial_debug_data(debug, &edge_serial->serial->dev->dev,
+					__func__, raw_data_length, data);
 
 	spin_lock(&edge_serial->es_lock);
 
 	/* decrement our rxBytes available by the number that we just got */
 	edge_serial->rxBytesAvail -= raw_data_length;
 
-	dbg("%s - Received = %d, rxBytesAvail %d", __func__, raw_data_length, edge_serial->rxBytesAvail);
+	dbg("%s - Received = %d, rxBytesAvail %d", __func__,
+				raw_data_length, edge_serial->rxBytesAvail);
 
-	process_rcvd_data (edge_serial, data, urb->actual_length);
+	process_rcvd_data(edge_serial, data, urb->actual_length);
 
 	/* check to see if there's any more data for us to read */
 	if (edge_serial->rxBytesAvail > 0) {
@@ -745,10 +802,10 @@ static void edge_bulk_in_callback (struct urb *urb)
 
 /*****************************************************************************
  * edge_bulk_out_data_callback
- *	this is the callback function for when we have finished sending serial data
- *	on the bulk out endpoint.
+ *	this is the callback function for when we have finished sending
+ *	serial data on the bulk out endpoint.
  *****************************************************************************/
-static void edge_bulk_out_data_callback (struct urb *urb)
+static void edge_bulk_out_data_callback(struct urb *urb)
 {
 	struct edgeport_port *edge_port = urb->context;
 	struct tty_struct *tty;
@@ -764,24 +821,26 @@ static void edge_bulk_out_data_callback (struct urb *urb)
 	tty = edge_port->port->port.tty;
 
 	if (tty && edge_port->open) {
-		/* let the tty driver wakeup if it has a special write_wakeup function */
+		/* let the tty driver wakeup if it has a special
+		   write_wakeup function */
 		tty_wakeup(tty);
 	}
 
-	// Release the Write URB
+	/* Release the Write URB */
 	edge_port->write_in_progress = false;
 
-	// Check if more data needs to be sent
-	send_more_port_data((struct edgeport_serial *)(usb_get_serial_data(edge_port->port->serial)), edge_port);
+	/* Check if more data needs to be sent */
+	send_more_port_data((struct edgeport_serial *)
+		(usb_get_serial_data(edge_port->port->serial)), edge_port);
 }
 
 
 /*****************************************************************************
  * BulkOutCmdCallback
- *	this is the callback function for when we have finished sending a command
- *	on the bulk out endpoint.
+ *	this is the callback function for when we have finished sending a
+ *	command	on the bulk out endpoint.
  *****************************************************************************/
-static void edge_bulk_out_cmd_callback (struct urb *urb)
+static void edge_bulk_out_cmd_callback(struct urb *urb)
 {
 	struct edgeport_port *edge_port = urb->context;
 	struct tty_struct *tty;
@@ -790,17 +849,19 @@ static void edge_bulk_out_cmd_callback (struct urb *urb)
 	dbg("%s", __func__);
 
 	atomic_dec(&CmdUrbs);
-	dbg("%s - FREE URB %p (outstanding %d)", __func__, urb, atomic_read(&CmdUrbs));
+	dbg("%s - FREE URB %p (outstanding %d)", __func__,
+					urb, atomic_read(&CmdUrbs));
 
 
 	/* clean up the transfer buffer */
 	kfree(urb->transfer_buffer);
 
 	/* Free the command urb */
-	usb_free_urb (urb);
+	usb_free_urb(urb);
 
 	if (status) {
-		dbg("%s - nonzero write bulk status received: %d", __func__, status);
+		dbg("%s - nonzero write bulk status received: %d",
+							__func__, status);
 		return;
 	}
 
@@ -828,7 +889,7 @@ static void edge_bulk_out_cmd_callback (struct urb *urb)
  *	Otherwise we return a negative error number.
  *****************************************************************************/
 static int edge_open(struct tty_struct *tty,
-			struct usb_serial_port *port, struct file * filp)
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	struct usb_serial *serial;
@@ -843,51 +904,59 @@ static int edge_open(struct tty_struct *tty,
 	if (tty)
 		tty->low_latency = low_latency;
 
-	/* see if we've set up our endpoint info yet (can't set it up in edge_startup
-	   as the structures were not set up at that time.) */
+	/* see if we've set up our endpoint info yet (can't set it up
+	   in edge_startup as the structures were not set up at that time.) */
 	serial = port->serial;
 	edge_serial = usb_get_serial_data(serial);
 	if (edge_serial == NULL)
 		return -ENODEV;
 	if (edge_serial->interrupt_in_buffer == NULL) {
 		struct usb_serial_port *port0 = serial->port[0];
-		
+
 		/* not set up yet, so do it now */
-		edge_serial->interrupt_in_buffer = port0->interrupt_in_buffer;
-		edge_serial->interrupt_in_endpoint = port0->interrupt_in_endpointAddress;
+		edge_serial->interrupt_in_buffer =
+					port0->interrupt_in_buffer;
+		edge_serial->interrupt_in_endpoint =
+					port0->interrupt_in_endpointAddress;
 		edge_serial->interrupt_read_urb = port0->interrupt_in_urb;
 		edge_serial->bulk_in_buffer = port0->bulk_in_buffer;
-		edge_serial->bulk_in_endpoint = port0->bulk_in_endpointAddress;
+		edge_serial->bulk_in_endpoint =
+					port0->bulk_in_endpointAddress;
 		edge_serial->read_urb = port0->read_urb;
-		edge_serial->bulk_out_endpoint = port0->bulk_out_endpointAddress;
-	
+		edge_serial->bulk_out_endpoint =
+					port0->bulk_out_endpointAddress;
+
 		/* set up our interrupt urb */
 		usb_fill_int_urb(edge_serial->interrupt_read_urb,
-				 serial->dev,
-				 usb_rcvintpipe(serial->dev,
-					        port0->interrupt_in_endpointAddress),
-				 port0->interrupt_in_buffer,
-				 edge_serial->interrupt_read_urb->transfer_buffer_length,
-				 edge_interrupt_callback, edge_serial,
-				 edge_serial->interrupt_read_urb->interval);
-		
+		      serial->dev,
+		      usb_rcvintpipe(serial->dev,
+				port0->interrupt_in_endpointAddress),
+		      port0->interrupt_in_buffer,
+		      edge_serial->interrupt_read_urb->transfer_buffer_length,
+		      edge_interrupt_callback, edge_serial,
+		      edge_serial->interrupt_read_urb->interval);
+
 		/* set up our bulk in urb */
 		usb_fill_bulk_urb(edge_serial->read_urb, serial->dev,
-				  usb_rcvbulkpipe(serial->dev,
-					  	  port0->bulk_in_endpointAddress),
-				  port0->bulk_in_buffer,
-				  edge_serial->read_urb->transfer_buffer_length,
-				  edge_bulk_in_callback, edge_serial);
+			usb_rcvbulkpipe(serial->dev,
+				port0->bulk_in_endpointAddress),
+			port0->bulk_in_buffer,
+			edge_serial->read_urb->transfer_buffer_length,
+			edge_bulk_in_callback, edge_serial);
 		edge_serial->read_in_progress = false;
 
 		/* start interrupt read for this edgeport
-		 * this interrupt will continue as long as the edgeport is connected */
-		response = usb_submit_urb (edge_serial->interrupt_read_urb, GFP_KERNEL);
+		 * this interrupt will continue as long
+		 * as the edgeport is connected */
+		response = usb_submit_urb(edge_serial->interrupt_read_urb,
+								GFP_KERNEL);
 		if (response) {
-			dev_err(&port->dev, "%s - Error %d submitting control urb\n", __func__, response);
+			dev_err(&port->dev,
+				"%s - Error %d submitting control urb\n",
+							__func__, response);
 		}
 	}
-	
+
 	/* initialize our wait queues */
 	init_waitqueue_head(&edge_port->wait_open);
 	init_waitqueue_head(&edge_port->wait_chase);
@@ -895,26 +964,29 @@ static int edge_open(struct tty_struct *tty,
 	init_waitqueue_head(&edge_port->wait_command);
 
 	/* initialize our icount structure */
-	memset (&(edge_port->icount), 0x00, sizeof(edge_port->icount));
+	memset(&(edge_port->icount), 0x00, sizeof(edge_port->icount));
 
 	/* initialize our port settings */
-	edge_port->txCredits            = 0;			/* Can't send any data yet */
-	edge_port->shadowMCR            = MCR_MASTER_IE;	/* Must always set this bit to enable ints! */
+	edge_port->txCredits = 0;	/* Can't send any data yet */
+	/* Must always set this bit to enable ints! */
+	edge_port->shadowMCR = MCR_MASTER_IE;
 	edge_port->chaseResponsePending = false;
 
 	/* send a open port command */
 	edge_port->openPending = true;
 	edge_port->open        = false;
-	response = send_iosp_ext_cmd (edge_port, IOSP_CMD_OPEN_PORT, 0);
+	response = send_iosp_ext_cmd(edge_port, IOSP_CMD_OPEN_PORT, 0);
 
 	if (response < 0) {
-		dev_err(&port->dev, "%s - error sending open port command\n", __func__);
+		dev_err(&port->dev, "%s - error sending open port command\n",
+								__func__);
 		edge_port->openPending = false;
 		return -ENODEV;
 	}
 
 	/* now wait for the port to be completely opened */
-	wait_event_timeout(edge_port->wait_open, !edge_port->openPending, OPEN_TIMEOUT);
+	wait_event_timeout(edge_port->wait_open, !edge_port->openPending,
+								OPEN_TIMEOUT);
 
 	if (!edge_port->open) {
 		/* open timed out */
@@ -928,25 +1000,26 @@ static int edge_open(struct tty_struct *tty,
 	edge_port->txfifo.tail	= 0;
 	edge_port->txfifo.count	= 0;
 	edge_port->txfifo.size	= edge_port->maxTxCredits;
-	edge_port->txfifo.fifo	= kmalloc (edge_port->maxTxCredits, GFP_KERNEL);
+	edge_port->txfifo.fifo	= kmalloc(edge_port->maxTxCredits, GFP_KERNEL);
 
 	if (!edge_port->txfifo.fifo) {
 		dbg("%s - no memory", __func__);
-		edge_close (tty, port, filp);
+		edge_close(tty, port, filp);
 		return -ENOMEM;
 	}
 
 	/* Allocate a URB for the write */
-	edge_port->write_urb = usb_alloc_urb (0, GFP_KERNEL);
+	edge_port->write_urb = usb_alloc_urb(0, GFP_KERNEL);
 	edge_port->write_in_progress = false;
 
 	if (!edge_port->write_urb) {
 		dbg("%s - no memory", __func__);
-		edge_close (tty, port, filp);
+		edge_close(tty, port, filp);
 		return -ENOMEM;
 	}
 
-	dbg("%s(%d) - Initialize TX fifo to %d bytes", __func__, port->number, edge_port->maxTxCredits);
+	dbg("%s(%d) - Initialize TX fifo to %d bytes",
+			__func__, port->number, edge_port->maxTxCredits);
 
 	dbg("%s exited", __func__);
 
@@ -972,27 +1045,28 @@ static void block_until_chase_response(struct edgeport_port *edge_port)
 	int loop = 10;
 
 	while (1) {
-		// Save Last credits
+		/* Save Last credits */
 		lastCredits = edge_port->txCredits;
 
-		// Did we get our Chase response
+		/* Did we get our Chase response */
 		if (!edge_port->chaseResponsePending) {
 			dbg("%s - Got Chase Response", __func__);
 
-			// did we get all of our credit back?
-			if (edge_port->txCredits == edge_port->maxTxCredits ) {
+			/* did we get all of our credit back? */
+			if (edge_port->txCredits == edge_port->maxTxCredits) {
 				dbg("%s - Got all credits", __func__);
 				return;
 			}
 		}
 
-		// Block the thread for a while
-		prepare_to_wait(&edge_port->wait_chase, &wait, TASK_UNINTERRUPTIBLE);
+		/* Block the thread for a while */
+		prepare_to_wait(&edge_port->wait_chase, &wait,
+						TASK_UNINTERRUPTIBLE);
 		schedule_timeout(timeout);
 		finish_wait(&edge_port->wait_chase, &wait);
 
 		if (lastCredits == edge_port->txCredits) {
-			// No activity.. count down.
+			/* No activity.. count down. */
 			loop--;
 			if (loop == 0) {
 				edge_port->chaseResponsePending = false;
@@ -1000,8 +1074,9 @@ static void block_until_chase_response(struct edgeport_port *edge_port)
 				return;
 			}
 		} else {
-			// Reset timeout value back to 10 seconds
-			dbg("%s - Last %d, Current %d", __func__, lastCredits, edge_port->txCredits);
+			/* Reset timeout value back to 10 seconds */
+			dbg("%s - Last %d, Current %d", __func__,
+					lastCredits, edge_port->txCredits);
 			loop = 10;
 		}
 	}
@@ -1018,7 +1093,7 @@ static void block_until_chase_response(struct edgeport_port *edge_port)
  *		3. A timeout of 3 seconds without activity has expired
  *
  ************************************************************************/
-static void block_until_tx_empty (struct edgeport_port *edge_port)
+static void block_until_tx_empty(struct edgeport_port *edge_port)
 {
 	DEFINE_WAIT(wait);
 	struct TxFifo *fifo = &edge_port->txfifo;
@@ -1027,31 +1102,32 @@ static void block_until_tx_empty (struct edgeport_port *edge_port)
 	int loop = 30;
 
 	while (1) {
-		// Save Last count
+		/* Save Last count */
 		lastCount = fifo->count;
 
-		// Is the Edgeport Buffer empty?
+		/* Is the Edgeport Buffer empty? */
 		if (lastCount == 0) {
 			dbg("%s - TX Buffer Empty", __func__);
 			return;
 		}
 
-		// Block the thread for a while
-		prepare_to_wait (&edge_port->wait_chase, &wait, TASK_UNINTERRUPTIBLE);
+		/* Block the thread for a while */
+		prepare_to_wait(&edge_port->wait_chase, &wait,
+						TASK_UNINTERRUPTIBLE);
 		schedule_timeout(timeout);
 		finish_wait(&edge_port->wait_chase, &wait);
 
 		dbg("%s wait", __func__);
 
 		if (lastCount == fifo->count) {
-			// No activity.. count down.
+			/* No activity.. count down. */
 			loop--;
 			if (loop == 0) {
 				dbg("%s - TIMEOUT", __func__);
 				return;
 			}
 		} else {
-			// Reset timeout value back to seconds
+			/* Reset timeout value back to seconds */
 			loop = 30;
 		}
 	}
@@ -1063,20 +1139,20 @@ static void block_until_tx_empty (struct edgeport_port *edge_port)
  *	this function is called by the tty driver when a port is closed
  *****************************************************************************/
 static void edge_close(struct tty_struct *tty,
-			struct usb_serial_port *port, struct file * filp)
+			struct usb_serial_port *port, struct file *filp)
 {
 	struct edgeport_serial *edge_serial;
 	struct edgeport_port *edge_port;
 	int status;
 
 	dbg("%s - port %d", __func__, port->number);
-			 
+
 	edge_serial = usb_get_serial_data(port->serial);
 	edge_port = usb_get_serial_port_data(port);
-	if ((edge_serial == NULL) || (edge_port == NULL))
+	if (edge_serial == NULL || edge_port == NULL)
 		return;
-	
-	// block until tx is empty
+
+	/* block until tx is empty */
 	block_until_tx_empty(edge_port);
 
 	edge_port->closePending = true;
@@ -1088,13 +1164,12 @@ static void edge_close(struct tty_struct *tty,
 		edge_port->chaseResponsePending = true;
 
 		dbg("%s - Sending IOSP_CMD_CHASE_PORT", __func__);
-		status = send_iosp_ext_cmd (edge_port, IOSP_CMD_CHASE_PORT, 0);
-		if (status == 0) {
-			// block until chase finished
+		status = send_iosp_ext_cmd(edge_port, IOSP_CMD_CHASE_PORT, 0);
+		if (status == 0)
+			/* block until chase finished */
 			block_until_chase_response(edge_port);
-		} else {
+		else
 			edge_port->chaseResponsePending = false;
-		}
 	}
 
 	if ((!edge_serial->is_epic) ||
@@ -1102,10 +1177,10 @@ static void edge_close(struct tty_struct *tty,
 	     (edge_serial->epic_descriptor.Supports.IOSPClose))) {
 	       /* close the port */
 		dbg("%s - Sending IOSP_CMD_CLOSE_PORT", __func__);
-		send_iosp_ext_cmd (edge_port, IOSP_CMD_CLOSE_PORT, 0);
+		send_iosp_ext_cmd(edge_port, IOSP_CMD_CLOSE_PORT, 0);
 	}
 
-	//port->close = true;
+	/* port->close = true; */
 	edge_port->closePending = false;
 	edge_port->open = false;
 	edge_port->openPending = false;
@@ -1113,7 +1188,8 @@ static void edge_close(struct tty_struct *tty,
 	usb_kill_urb(edge_port->write_urb);
 
 	if (edge_port->write_urb) {
-		/* if this urb had a transfer buffer already (old transfer) free it */
+		/* if this urb had a transfer buffer already
+				(old transfer) free it */
 		kfree(edge_port->write_urb->transfer_buffer);
 		usb_free_urb(edge_port->write_urb);
 		edge_port->write_urb = NULL;
@@ -1122,14 +1198,14 @@ static void edge_close(struct tty_struct *tty,
 	edge_port->txfifo.fifo = NULL;
 
 	dbg("%s exited", __func__);
-}   
+}
 
 /*****************************************************************************
  * SerialWrite
- *	this function is called by the tty driver when data should be written to
- *	the port.
- *	If successful, we return the number of bytes written, otherwise we return
- *	a negative error number.
+ *	this function is called by the tty driver when data should be written
+ *	to the port.
+ *	If successful, we return the number of bytes written, otherwise we
+ *	return a negative error number.
  *****************************************************************************/
 static int edge_write(struct tty_struct *tty, struct usb_serial_port *port,
 					const unsigned char *data, int count)
@@ -1147,66 +1223,76 @@ static int edge_write(struct tty_struct *tty, struct usb_serial_port *port,
 	if (edge_port == NULL)
 		return -ENODEV;
 
-	// get a pointer to the Tx fifo
+	/* get a pointer to the Tx fifo */
 	fifo = &edge_port->txfifo;
 
 	spin_lock_irqsave(&edge_port->ep_lock, flags);
 
-	// calculate number of bytes to put in fifo
-	copySize = min ((unsigned int)count, (edge_port->txCredits - fifo->count));
+	/* calculate number of bytes to put in fifo */
+	copySize = min((unsigned int)count,
+				(edge_port->txCredits - fifo->count));
 
-	dbg("%s(%d) of %d byte(s) Fifo room  %d -- will copy %d bytes", __func__,
-	    port->number, count, edge_port->txCredits - fifo->count, copySize);
+	dbg("%s(%d) of %d byte(s) Fifo room  %d -- will copy %d bytes",
+			__func__, port->number, count,
+			edge_port->txCredits - fifo->count, copySize);
 
-	/* catch writes of 0 bytes which the tty driver likes to give us, and when txCredits is empty */
+	/* catch writes of 0 bytes which the tty driver likes to give us,
+	   and when txCredits is empty */
 	if (copySize == 0) {
 		dbg("%s - copySize = Zero", __func__);
 		goto finish_write;
 	}
 
-	// queue the data	
-	// since we can never overflow the buffer we do not have to check for full condition
-
-	// the copy is done is two parts -- first fill to the end of the buffer
-	// then copy the reset from the start of the buffer 
-
+	/* queue the data
+	 * since we can never overflow the buffer we do not have to check for a
+	 * full condition
+	 *
+	 * the copy is done is two parts -- first fill to the end of the buffer
+	 * then copy the reset from the start of the buffer
+	 */
 	bytesleft = fifo->size - fifo->head;
-	firsthalf = min (bytesleft, copySize);
-	dbg("%s - copy %d bytes of %d into fifo ", __func__, firsthalf, bytesleft);
+	firsthalf = min(bytesleft, copySize);
+	dbg("%s - copy %d bytes of %d into fifo ", __func__,
+					firsthalf, bytesleft);
 
 	/* now copy our data */
 	memcpy(&fifo->fifo[fifo->head], data, firsthalf);
-	usb_serial_debug_data(debug, &port->dev, __func__, firsthalf, &fifo->fifo[fifo->head]);
+	usb_serial_debug_data(debug, &port->dev, __func__,
+					firsthalf, &fifo->fifo[fifo->head]);
 
-	// update the index and size
+	/* update the index and size */
 	fifo->head  += firsthalf;
 	fifo->count += firsthalf;
 
-	// wrap the index
-	if (fifo->head == fifo->size) {
+	/* wrap the index */
+	if (fifo->head == fifo->size)
 		fifo->head = 0;
-	}
 
 	secondhalf = copySize-firsthalf;
 
 	if (secondhalf) {
 		dbg("%s - copy rest of data %d", __func__, secondhalf);
 		memcpy(&fifo->fifo[fifo->head], &data[firsthalf], secondhalf);
-		usb_serial_debug_data(debug, &port->dev, __func__, secondhalf, &fifo->fifo[fifo->head]);
-		// update the index and size
+		usb_serial_debug_data(debug, &port->dev, __func__,
+					secondhalf, &fifo->fifo[fifo->head]);
+		/* update the index and size */
 		fifo->count += secondhalf;
 		fifo->head  += secondhalf;
-		// No need to check for wrap since we can not get to end of fifo in this part
+		/* No need to check for wrap since we can not get to end of
+		 * the fifo in this part
+		 */
 	}
 
 finish_write:
 	spin_unlock_irqrestore(&edge_port->ep_lock, flags);
 
-	send_more_port_data((struct edgeport_serial *)usb_get_serial_data(port->serial), edge_port);
+	send_more_port_data((struct edgeport_serial *)
+			usb_get_serial_data(port->serial), edge_port);
 
-	dbg("%s wrote %d byte(s) TxCredits %d, Fifo %d", __func__, copySize, edge_port->txCredits, fifo->count);
+	dbg("%s wrote %d byte(s) TxCredits %d, Fifo %d", __func__,
+				copySize, edge_port->txCredits, fifo->count);
 
-	return copySize;   
+	return copySize;
 }
 
 
@@ -1223,7 +1309,8 @@ finish_write:
  *	can transmit more.
  *
  ************************************************************************/
-static void send_more_port_data(struct edgeport_serial *edge_serial, struct edgeport_port *edge_port)
+static void send_more_port_data(struct edgeport_serial *edge_serial,
+					struct edgeport_port *edge_port)
 {
 	struct TxFifo	*fifo = &edge_port->txfifo;
 	struct urb	*urb;
@@ -1242,67 +1329,78 @@ static void send_more_port_data(struct edgeport_serial *edge_serial, struct edge
 	if (edge_port->write_in_progress ||
 	    !edge_port->open             ||
 	    (fifo->count == 0)) {
-		dbg("%s(%d) EXIT - fifo %d, PendingWrite = %d", __func__, edge_port->port->number, fifo->count, edge_port->write_in_progress);
+		dbg("%s(%d) EXIT - fifo %d, PendingWrite = %d",
+				__func__, edge_port->port->number,
+				fifo->count, edge_port->write_in_progress);
 		goto exit_send;
 	}
 
-	// since the amount of data in the fifo will always fit into the
-	// edgeport buffer we do not need to check the write length
-
-	//	Do we have enough credits for this port to make it worthwhile
-	//	to bother queueing a write. If it's too small, say a few bytes,
-	//	it's better to wait for more credits so we can do a larger
-	//	write.
-	if (edge_port->txCredits < EDGE_FW_GET_TX_CREDITS_SEND_THRESHOLD(edge_port->maxTxCredits,EDGE_FW_BULK_MAX_PACKET_SIZE)) {
-		dbg("%s(%d) Not enough credit - fifo %d TxCredit %d", __func__, edge_port->port->number, fifo->count, edge_port->txCredits );
+	/* since the amount of data in the fifo will always fit into the
+	 * edgeport buffer we do not need to check the write length
+	 *
+	 * Do we have enough credits for this port to make it worthwhile
+	 * to bother queueing a write. If it's too small, say a few bytes,
+	 * it's better to wait for more credits so we can do a larger write.
+	 */
+	if (edge_port->txCredits < EDGE_FW_GET_TX_CREDITS_SEND_THRESHOLD(edge_port->maxTxCredits, EDGE_FW_BULK_MAX_PACKET_SIZE)) {
+		dbg("%s(%d) Not enough credit - fifo %d TxCredit %d",
+			__func__, edge_port->port->number, fifo->count,
+			edge_port->txCredits);
 		goto exit_send;
 	}
 
-	// lock this write
+	/* lock this write */
 	edge_port->write_in_progress = true;
 
-	// get a pointer to the write_urb
+	/* get a pointer to the write_urb */
 	urb = edge_port->write_urb;
 
 	/* make sure transfer buffer is freed */
 	kfree(urb->transfer_buffer);
 	urb->transfer_buffer = NULL;
 
-	/* build the data header for the buffer and port that we are about to send out */
+	/* build the data header for the buffer and port that we are about
+	   to send out */
 	count = fifo->count;
-	buffer = kmalloc (count+2, GFP_ATOMIC);
+	buffer = kmalloc(count+2, GFP_ATOMIC);
 	if (buffer == NULL) {
-		dev_err(&edge_port->port->dev, "%s - no more kernel memory...\n", __func__);
+		dev_err(&edge_port->port->dev,
+				"%s - no more kernel memory...\n", __func__);
 		edge_port->write_in_progress = false;
 		goto exit_send;
 	}
-	buffer[0] = IOSP_BUILD_DATA_HDR1 (edge_port->port->number - edge_port->port->serial->minor, count);
-	buffer[1] = IOSP_BUILD_DATA_HDR2 (edge_port->port->number - edge_port->port->serial->minor, count);
+	buffer[0] = IOSP_BUILD_DATA_HDR1(edge_port->port->number
+				- edge_port->port->serial->minor, count);
+	buffer[1] = IOSP_BUILD_DATA_HDR2(edge_port->port->number
+				- edge_port->port->serial->minor, count);
 
 	/* now copy our data */
 	bytesleft =  fifo->size - fifo->tail;
-	firsthalf = min (bytesleft, count);
+	firsthalf = min(bytesleft, count);
 	memcpy(&buffer[2], &fifo->fifo[fifo->tail], firsthalf);
 	fifo->tail  += firsthalf;
 	fifo->count -= firsthalf;
-	if (fifo->tail == fifo->size) {
+	if (fifo->tail == fifo->size)
 		fifo->tail = 0;
-	}
 
 	secondhalf = count-firsthalf;
 	if (secondhalf) {
-		memcpy(&buffer[2+firsthalf], &fifo->fifo[fifo->tail], secondhalf);
+		memcpy(&buffer[2+firsthalf], &fifo->fifo[fifo->tail],
+								secondhalf);
 		fifo->tail  += secondhalf;
 		fifo->count -= secondhalf;
 	}
 
 	if (count)
-		usb_serial_debug_data(debug, &edge_port->port->dev, __func__, count, &buffer[2]);
+		usb_serial_debug_data(debug, &edge_port->port->dev,
+						__func__, count, &buffer[2]);
 
 	/* fill up the urb with all of our data and submit it */
-	usb_fill_bulk_urb (urb, edge_serial->serial->dev, 
-		       usb_sndbulkpipe(edge_serial->serial->dev, edge_serial->bulk_out_endpoint),
-		       buffer, count+2, edge_bulk_out_data_callback, edge_port);
+	usb_fill_bulk_urb(urb, edge_serial->serial->dev,
+			usb_sndbulkpipe(edge_serial->serial->dev,
+					edge_serial->bulk_out_endpoint),
+			buffer, count+2,
+			edge_bulk_out_data_callback, edge_port);
 
 	/* decrement the number of credits we have by the number we just sent */
 	edge_port->txCredits -= count;
@@ -1312,14 +1410,17 @@ static void send_more_port_data(struct edgeport_serial *edge_serial, struct edge
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status) {
 		/* something went wrong */
-		dev_err(&edge_port->port->dev, "%s - usb_submit_urb(write bulk) failed, status = %d, data lost\n", __func__, status);
+		dev_err(&edge_port->port->dev,
+			"%s - usb_submit_urb(write bulk) failed, status = %d, data lost\n",
+				__func__, status);
 		edge_port->write_in_progress = false;
 
 		/* revert the credits as something bad happened. */
 		edge_port->txCredits += count;
 		edge_port->icount.tx -= count;
 	}
-	dbg("%s wrote %d byte(s) TxCredit %d, Fifo %d", __func__, count, edge_port->txCredits, fifo->count);
+	dbg("%s wrote %d byte(s) TxCredit %d, Fifo %d",
+			__func__, count, edge_port->txCredits, fifo->count);
 
 exit_send:
 	spin_unlock_irqrestore(&edge_port->ep_lock, flags);
@@ -1328,11 +1429,10 @@ exit_send:
 
 /*****************************************************************************
  * edge_write_room
- *	this function is called by the tty driver when it wants to know how many
- *	bytes of data we can accept for a specific port.
- *	If successful, we return the amount of room that we have for this port
- *	(the txCredits), 
- *	Otherwise we return a negative error number.
+ *	this function is called by the tty driver when it wants to know how
+ *	many bytes of data we can accept for a specific port. If successful,
+ *	we return the amount of room that we have for this port	(the txCredits)
+ *	otherwise we return a negative error number.
  *****************************************************************************/
 static int edge_write_room(struct tty_struct *tty)
 {
@@ -1355,7 +1455,7 @@ static int edge_write_room(struct tty_struct *tty)
 		return -EINVAL;
 	}
 
-	// total of both buffers is still txCredit
+	/* total of both buffers is still txCredit */
 	spin_lock_irqsave(&edge_port->ep_lock, flags);
 	room = edge_port->txCredits - edge_port->txfifo.count;
 	spin_unlock_irqrestore(&edge_port->ep_lock, flags);
@@ -1367,11 +1467,11 @@ static int edge_write_room(struct tty_struct *tty)
 
 /*****************************************************************************
  * edge_chars_in_buffer
- *	this function is called by the tty driver when it wants to know how many
- *	bytes of data we currently have outstanding in the port (data that has
- *	been written, but hasn't made it out the port yet)
- *	If successful, we return the number of bytes left to be written in the 
- *	system, 
+ *	this function is called by the tty driver when it wants to know how
+ *	many bytes of data we currently have outstanding in the port (data that
+ *	has been written, but hasn't made it out the port yet)
+ *	If successful, we return the number of bytes left to be written in the
+ *	system,
  *	Otherwise we return a negative error number.
  *****************************************************************************/
 static int edge_chars_in_buffer(struct tty_struct *tty)
@@ -1394,10 +1494,12 @@ static int edge_chars_in_buffer(struct tty_struct *tty)
 	}
 
 	spin_lock_irqsave(&edge_port->ep_lock, flags);
-	num_chars = edge_port->maxTxCredits - edge_port->txCredits + edge_port->txfifo.count;
+	num_chars = edge_port->maxTxCredits - edge_port->txCredits +
+						edge_port->txfifo.count;
 	spin_unlock_irqrestore(&edge_port->ep_lock, flags);
 	if (num_chars) {
-		dbg("%s(port %d) - returns %d", __func__, port->number, num_chars);
+		dbg("%s(port %d) - returns %d", __func__,
+						port->number, num_chars);
 	}
 
 	return num_chars;
@@ -1428,19 +1530,18 @@ static void edge_throttle(struct tty_struct *tty)
 	/* if we are implementing XON/XOFF, send the stop character */
 	if (I_IXOFF(tty)) {
 		unsigned char stop_char = STOP_CHAR(tty);
-		status = edge_write (tty, port, &stop_char, 1);
-		if (status <= 0) {
+		status = edge_write(tty, port, &stop_char, 1);
+		if (status <= 0)
 			return;
-		}
 	}
 
 	/* if we are implementing RTS/CTS, toggle that line */
 	if (tty->termios->c_cflag & CRTSCTS) {
 		edge_port->shadowMCR &= ~MCR_RTS;
-		status = send_cmd_write_uart_register(edge_port, MCR, edge_port->shadowMCR);
-		if (status != 0) {
+		status = send_cmd_write_uart_register(edge_port, MCR,
+							edge_port->shadowMCR);
+		if (status != 0)
 			return;
-		}
 	}
 
 	return;
@@ -1449,8 +1550,8 @@ static void edge_throttle(struct tty_struct *tty)
 
 /*****************************************************************************
  * edge_unthrottle
- *	this function is called by the tty driver when it wants to resume the data
- *	being read from the port (called after SerialThrottle is called)
+ *	this function is called by the tty driver when it wants to resume the
+ *	data being read from the port (called after SerialThrottle is called)
  *****************************************************************************/
 static void edge_unthrottle(struct tty_struct *tty)
 {
@@ -1478,14 +1579,16 @@ static void edge_unthrottle(struct tty_struct *tty)
 	/* if we are implementing RTS/CTS, toggle that line */
 	if (tty->termios->c_cflag & CRTSCTS) {
 		edge_port->shadowMCR |= MCR_RTS;
-		send_cmd_write_uart_register(edge_port, MCR, edge_port->shadowMCR);
+		send_cmd_write_uart_register(edge_port, MCR,
+						edge_port->shadowMCR);
 	}
 }
 
 
 /*****************************************************************************
  * SerialSetTermios
- *	this function is called by the tty driver when it wants to change the termios structure
+ *	this function is called by the tty driver when it wants to change
+ * the termios structure
  *****************************************************************************/
 static void edge_set_termios(struct tty_struct *tty,
 	struct usb_serial_port *port, struct ktermios *old_termios)
@@ -1522,9 +1625,10 @@ static void edge_set_termios(struct tty_struct *tty,
  * 	    release the bus after transmitting. This must be done when
  * 	    the transmit shift register is empty, not be done when the
  * 	    transmit holding register is empty.  This functionality
- * 	    allows an RS485 driver to be written in user space. 
+ * 	    allows an RS485 driver to be written in user space.
  *****************************************************************************/
-static int get_lsr_info(struct edgeport_port *edge_port, unsigned int __user *value)
+static int get_lsr_info(struct edgeport_port *edge_port,
+						unsigned int __user *value)
 {
 	unsigned int result = 0;
 	unsigned long flags;
@@ -1542,7 +1646,8 @@ static int get_lsr_info(struct edgeport_port *edge_port, unsigned int __user *va
 	return 0;
 }
 
-static int edge_tiocmset(struct tty_struct *tty, struct file *file, unsigned int set, unsigned int clear)
+static int edge_tiocmset(struct tty_struct *tty, struct file *file,
+					unsigned int set, unsigned int clear)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
@@ -1597,7 +1702,8 @@ static int edge_tiocmget(struct tty_struct *tty, struct file *file)
 	return result;
 }
 
-static int get_serial_info(struct edgeport_port *edge_port, struct serial_struct __user *retinfo)
+static int get_serial_info(struct edgeport_port *edge_port,
+				struct serial_struct __user *retinfo)
 {
 	struct serial_struct tmp;
 
@@ -1640,60 +1746,61 @@ static int edge_ioctl(struct tty_struct *tty, struct file *file,
 	dbg("%s - port %d, cmd = 0x%x", __func__, port->number, cmd);
 
 	switch (cmd) {
-		case TIOCSERGETLSR:
-			dbg("%s (%d) TIOCSERGETLSR", __func__,  port->number);
-			return get_lsr_info(edge_port, (unsigned int __user *) arg);
-
-		case TIOCGSERIAL:
-			dbg("%s (%d) TIOCGSERIAL", __func__,  port->number);
-			return get_serial_info(edge_port, (struct serial_struct __user *) arg);
-
-		case TIOCMIWAIT:
-			dbg("%s (%d) TIOCMIWAIT", __func__,  port->number);
-			cprev = edge_port->icount;
-			while (1) {
-				prepare_to_wait(&edge_port->delta_msr_wait, &wait, TASK_INTERRUPTIBLE);
-				schedule();
-				finish_wait(&edge_port->delta_msr_wait, &wait);
-				/* see if a signal did it */
-				if (signal_pending(current))
-					return -ERESTARTSYS;
-				cnow = edge_port->icount;
-				if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
-				    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
-					return -EIO; /* no change => error */
-				if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
-				    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
-				    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
-				    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts)) ) {
-					return 0;
-				}
-				cprev = cnow;
+	case TIOCSERGETLSR:
+		dbg("%s (%d) TIOCSERGETLSR", __func__,  port->number);
+		return get_lsr_info(edge_port, (unsigned int __user *) arg);
+
+	case TIOCGSERIAL:
+		dbg("%s (%d) TIOCGSERIAL", __func__,  port->number);
+		return get_serial_info(edge_port, (struct serial_struct __user *) arg);
+
+	case TIOCMIWAIT:
+		dbg("%s (%d) TIOCMIWAIT", __func__,  port->number);
+		cprev = edge_port->icount;
+		while (1) {
+			prepare_to_wait(&edge_port->delta_msr_wait,
+						&wait, TASK_INTERRUPTIBLE);
+			schedule();
+			finish_wait(&edge_port->delta_msr_wait, &wait);
+			/* see if a signal did it */
+			if (signal_pending(current))
+				return -ERESTARTSYS;
+			cnow = edge_port->icount;
+			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
+			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
+				return -EIO; /* no change => error */
+			if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
+			    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
+			    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
+			    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
+				return 0;
 			}
-			/* NOTREACHED */
-			break;
+			cprev = cnow;
+		}
+		/* NOTREACHED */
+		break;
 
-		case TIOCGICOUNT:
-			cnow = edge_port->icount;
-			memset(&icount, 0, sizeof(icount));
-			icount.cts = cnow.cts;
-			icount.dsr = cnow.dsr;
-			icount.rng = cnow.rng;
-			icount.dcd = cnow.dcd;
-			icount.rx = cnow.rx;
-			icount.tx = cnow.tx;
-			icount.frame = cnow.frame;
-			icount.overrun = cnow.overrun;
-			icount.parity = cnow.parity;
-			icount.brk = cnow.brk;
-			icount.buf_overrun = cnow.buf_overrun;
-
-			dbg("%s (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,  port->number, icount.rx, icount.tx );
-			if (copy_to_user((void __user *)arg, &icount, sizeof(icount)))
-				return -EFAULT;
-			return 0;
+	case TIOCGICOUNT:
+		cnow = edge_port->icount;
+		memset(&icount, 0, sizeof(icount));
+		icount.cts = cnow.cts;
+		icount.dsr = cnow.dsr;
+		icount.rng = cnow.rng;
+		icount.dcd = cnow.dcd;
+		icount.rx = cnow.rx;
+		icount.tx = cnow.tx;
+		icount.frame = cnow.frame;
+		icount.overrun = cnow.overrun;
+		icount.parity = cnow.parity;
+		icount.brk = cnow.brk;
+		icount.buf_overrun = cnow.buf_overrun;
+
+		dbg("%s (%d) TIOCGICOUNT RX=%d, TX=%d",
+				__func__,  port->number, icount.rx, icount.tx);
+		if (copy_to_user((void __user *)arg, &icount, sizeof(icount)))
+			return -EFAULT;
+		return 0;
 	}
-
 	return -ENOIOCTLCMD;
 }
 
@@ -1702,7 +1809,7 @@ static int edge_ioctl(struct tty_struct *tty, struct file *file,
  * SerialBreak
  *	this function sends a break to the port
  *****************************************************************************/
-static void edge_break (struct tty_struct *tty, int break_state)
+static void edge_break(struct tty_struct *tty, int break_state)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
@@ -1716,9 +1823,9 @@ static void edge_break (struct tty_struct *tty, int break_state)
 		edge_port->chaseResponsePending = true;
 
 		dbg("%s - Sending IOSP_CMD_CHASE_PORT", __func__);
-		status = send_iosp_ext_cmd (edge_port, IOSP_CMD_CHASE_PORT, 0);
+		status = send_iosp_ext_cmd(edge_port, IOSP_CMD_CHASE_PORT, 0);
 		if (status == 0) {
-			// block until chase finished
+			/* block until chase finished */
 			block_until_chase_response(edge_port);
 		} else {
 			edge_port->chaseResponsePending = false;
@@ -1730,14 +1837,16 @@ static void edge_break (struct tty_struct *tty, int break_state)
 	     (edge_serial->epic_descriptor.Supports.IOSPSetClrBreak))) {
 		if (break_state == -1) {
 			dbg("%s - Sending IOSP_CMD_SET_BREAK", __func__);
-			status = send_iosp_ext_cmd (edge_port, IOSP_CMD_SET_BREAK, 0);
+			status = send_iosp_ext_cmd(edge_port,
+						IOSP_CMD_SET_BREAK, 0);
 		} else {
 			dbg("%s - Sending IOSP_CMD_CLEAR_BREAK", __func__);
-			status = send_iosp_ext_cmd (edge_port, IOSP_CMD_CLEAR_BREAK, 0);
-		}
-		if (status) {
-			dbg("%s - error sending break set/clear command.", __func__);
+			status = send_iosp_ext_cmd(edge_port,
+						IOSP_CMD_CLEAR_BREAK, 0);
 		}
+		if (status)
+			dbg("%s - error sending break set/clear command.",
+				__func__);
 	}
 
 	return;
@@ -1748,7 +1857,8 @@ static void edge_break (struct tty_struct *tty, int break_state)
  * process_rcvd_data
  *	this function handles the data received on the bulk in pipe.
  *****************************************************************************/
-static void process_rcvd_data (struct edgeport_serial *edge_serial, unsigned char * buffer, __u16 bufferLength)
+static void process_rcvd_data(struct edgeport_serial *edge_serial,
+				unsigned char *buffer, __u16 bufferLength)
 {
 	struct usb_serial_port *port;
 	struct edgeport_port *edge_port;
@@ -1769,105 +1879,123 @@ static void process_rcvd_data (struct edgeport_serial *edge_serial, unsigned cha
 		lastBufferLength = bufferLength;
 
 		switch (edge_serial->rxState) {
-			case EXPECT_HDR1:
-				edge_serial->rxHeader1 = *buffer;
-				++buffer;
-				--bufferLength;
+		case EXPECT_HDR1:
+			edge_serial->rxHeader1 = *buffer;
+			++buffer;
+			--bufferLength;
 
-				if (bufferLength == 0) {
-					edge_serial->rxState = EXPECT_HDR2;
+			if (bufferLength == 0) {
+				edge_serial->rxState = EXPECT_HDR2;
+				break;
+			}
+			/* otherwise, drop on through */
+		case EXPECT_HDR2:
+			edge_serial->rxHeader2 = *buffer;
+			++buffer;
+			--bufferLength;
+
+			dbg("%s - Hdr1=%02X Hdr2=%02X", __func__,
+			    edge_serial->rxHeader1, edge_serial->rxHeader2);
+			/* Process depending on whether this header is
+			 * data or status */
+
+			if (IS_CMD_STAT_HDR(edge_serial->rxHeader1)) {
+				/* Decode this status header and go to
+				 * EXPECT_HDR1 (if we can process the status
+				 * with only 2 bytes), or go to EXPECT_HDR3 to
+				 * get the third byte. */
+				edge_serial->rxPort =
+				    IOSP_GET_HDR_PORT(edge_serial->rxHeader1);
+				edge_serial->rxStatusCode =
+				    IOSP_GET_STATUS_CODE(
+						edge_serial->rxHeader1);
+
+				if (!IOSP_STATUS_IS_2BYTE(
+						edge_serial->rxStatusCode)) {
+					/* This status needs additional bytes.
+					 * Save what we have and then wait for
+					 * more data.
+					 */
+					edge_serial->rxStatusParam
+						= edge_serial->rxHeader2;
+					edge_serial->rxState = EXPECT_HDR3;
 					break;
 				}
-				/* otherwise, drop on through */
-
-			case EXPECT_HDR2:
-				edge_serial->rxHeader2 = *buffer;
-				++buffer;
-				--bufferLength;
-
-				dbg("%s - Hdr1=%02X Hdr2=%02X", __func__, edge_serial->rxHeader1, edge_serial->rxHeader2);
-
-				// Process depending on whether this header is
-				// data or status
-
-				if (IS_CMD_STAT_HDR(edge_serial->rxHeader1)) {
-					// Decode this status header and goto EXPECT_HDR1 (if we
-					// can process the status with only 2 bytes), or goto
-					// EXPECT_HDR3 to get the third byte.
-
-					edge_serial->rxPort       = IOSP_GET_HDR_PORT(edge_serial->rxHeader1);
-					edge_serial->rxStatusCode = IOSP_GET_STATUS_CODE(edge_serial->rxHeader1);
-
-					if (!IOSP_STATUS_IS_2BYTE(edge_serial->rxStatusCode)) {
-						// This status needs additional bytes. Save what we have
-						// and then wait for more data.
-						edge_serial->rxStatusParam = edge_serial->rxHeader2;
-
-						edge_serial->rxState = EXPECT_HDR3;
-						break;
-					}
+				/* We have all the header bytes, process the
+				   status now */
+				process_rcvd_status(edge_serial,
+						edge_serial->rxHeader2, 0);
+				edge_serial->rxState = EXPECT_HDR1;
+				break;
+			} else {
+				edge_serial->rxPort =
+				    IOSP_GET_HDR_PORT(edge_serial->rxHeader1);
+				edge_serial->rxBytesRemaining =
+				    IOSP_GET_HDR_DATA_LEN(
+						edge_serial->rxHeader1,
+						edge_serial->rxHeader2);
+				dbg("%s - Data for Port %u Len %u",
+						__func__,
+						edge_serial->rxPort,
+						edge_serial->rxBytesRemaining);
+
+				/* ASSERT(DevExt->RxPort < DevExt->NumPorts);
+				 * ASSERT(DevExt->RxBytesRemaining <
+				 *		IOSP_MAX_DATA_LENGTH);
+				 */
 
-					// We have all the header bytes, process the status now
-					process_rcvd_status (edge_serial, edge_serial->rxHeader2, 0);
-					edge_serial->rxState = EXPECT_HDR1;
+				if (bufferLength == 0) {
+					edge_serial->rxState = EXPECT_DATA;
 					break;
-				} else {
-					edge_serial->rxPort = IOSP_GET_HDR_PORT(edge_serial->rxHeader1);
-					edge_serial->rxBytesRemaining = IOSP_GET_HDR_DATA_LEN(edge_serial->rxHeader1, edge_serial->rxHeader2);
-
-					dbg("%s - Data for Port %u Len %u", __func__, edge_serial->rxPort, edge_serial->rxBytesRemaining);
-
-					//ASSERT( DevExt->RxPort < DevExt->NumPorts );
-					//ASSERT( DevExt->RxBytesRemaining < IOSP_MAX_DATA_LENGTH );
-
-					if (bufferLength == 0 ) {
-						edge_serial->rxState = EXPECT_DATA;
-						break;
-					}
-					// Else, drop through
 				}
+				/* Else, drop through */
+			}
+		case EXPECT_DATA: /* Expect data */
+			if (bufferLength < edge_serial->rxBytesRemaining) {
+				rxLen = bufferLength;
+				/* Expect data to start next buffer */
+				edge_serial->rxState = EXPECT_DATA;
+			} else {
+				/* BufLen >= RxBytesRemaining */
+				rxLen = edge_serial->rxBytesRemaining;
+				/* Start another header next time */
+				edge_serial->rxState = EXPECT_HDR1;
+			}
 
-			case EXPECT_DATA:	// Expect data
-
-				if (bufferLength < edge_serial->rxBytesRemaining) {
-					rxLen = bufferLength;
-					edge_serial->rxState = EXPECT_DATA;	// Expect data to start next buffer
-				} else {
-					// BufLen >= RxBytesRemaining
-					rxLen = edge_serial->rxBytesRemaining;
-					edge_serial->rxState = EXPECT_HDR1;	// Start another header next time
-				}
+			bufferLength -= rxLen;
+			edge_serial->rxBytesRemaining -= rxLen;
 
-				bufferLength -= rxLen;
-				edge_serial->rxBytesRemaining -= rxLen;
-
-				/* spit this data back into the tty driver if this port is open */
-				if (rxLen) {
-					port = edge_serial->serial->port[edge_serial->rxPort];
-					edge_port = usb_get_serial_port_data(port);
-					if (edge_port->open) {
-						tty = edge_port->port->port.tty;
-						if (tty) {
-							dbg("%s - Sending %d bytes to TTY for port %d", __func__, rxLen, edge_serial->rxPort);
-							edge_tty_recv(&edge_serial->serial->dev->dev, tty, buffer, rxLen);
-						}
-						edge_port->icount.rx += rxLen;
+			/* spit this data back into the tty driver if this
+			   port is open */
+			if (rxLen) {
+				port = edge_serial->serial->port[
+							edge_serial->rxPort];
+				edge_port = usb_get_serial_port_data(port);
+				if (edge_port->open) {
+					tty = edge_port->port->port.tty;
+					if (tty) {
+						dbg("%s - Sending %d bytes to TTY for port %d",
+							__func__, rxLen, edge_serial->rxPort);
+						edge_tty_recv(&edge_serial->serial->dev->dev, tty, buffer, rxLen);
 					}
-					buffer += rxLen;
+					edge_port->icount.rx += rxLen;
 				}
+				buffer += rxLen;
+			}
+			break;
 
-				break;
-
-			case EXPECT_HDR3:			// Expect 3rd byte of status header
-				edge_serial->rxHeader3 = *buffer;
-				++buffer;
-				--bufferLength;
-
-				// We have all the header bytes, process the status now
-				process_rcvd_status (edge_serial, edge_serial->rxStatusParam, edge_serial->rxHeader3);
-				edge_serial->rxState = EXPECT_HDR1;
-				break;
-
+		case EXPECT_HDR3:	/* Expect 3rd byte of status header */
+			edge_serial->rxHeader3 = *buffer;
+			++buffer;
+			--bufferLength;
+
+			/* We have all the header bytes, process the
+			   status now */
+			process_rcvd_status(edge_serial,
+				edge_serial->rxStatusParam,
+				edge_serial->rxHeader3);
+			edge_serial->rxState = EXPECT_HDR1;
+			break;
 		}
 	}
 }
@@ -1875,9 +2003,11 @@ static void process_rcvd_data (struct edgeport_serial *edge_serial, unsigned cha
 
 /*****************************************************************************
  * process_rcvd_status
- *	this function handles the any status messages received on the bulk in pipe.
+ *	this function handles the any status messages received on the
+ *	bulk in pipe.
  *****************************************************************************/
-static void process_rcvd_status (struct edgeport_serial *edge_serial, __u8 byte2, __u8 byte3)
+static void process_rcvd_status(struct edgeport_serial *edge_serial,
+						__u8 byte2, __u8 byte3)
 {
 	struct usb_serial_port *port;
 	struct edgeport_port *edge_port;
@@ -1887,7 +2017,9 @@ static void process_rcvd_status (struct edgeport_serial *edge_serial, __u8 byte2
 	port = edge_serial->serial->port[edge_serial->rxPort];
 	edge_port = usb_get_serial_port_data(port);
 	if (edge_port == NULL) {
-		dev_err(&edge_serial->serial->dev->dev, "%s - edge_port == NULL for port %d\n", __func__, edge_serial->rxPort);
+		dev_err(&edge_serial->serial->dev->dev,
+			"%s - edge_port == NULL for port %d\n",
+					__func__, edge_serial->rxPort);
 		return;
 	}
 
@@ -1895,22 +2027,28 @@ static void process_rcvd_status (struct edgeport_serial *edge_serial, __u8 byte2
 
 	if (code == IOSP_EXT_STATUS) {
 		switch (byte2) {
-			case IOSP_EXT_STATUS_CHASE_RSP:
-				// we want to do EXT status regardless of port open/closed 
-				dbg("%s - Port %u EXT CHASE_RSP Data = %02x", __func__, edge_serial->rxPort, byte3 );
-				// Currently, the only EXT_STATUS is Chase, so process here instead of one more call
-				// to one more subroutine. If/when more EXT_STATUS, there'll be more work to do.
-				// Also, we currently clear flag and close the port regardless of content of above's Byte3.
-				// We could choose to do something else when Byte3 says Timeout on Chase from Edgeport,
-				// like wait longer in block_until_chase_response, but for now we don't. 
-				edge_port->chaseResponsePending = false;
-				wake_up (&edge_port->wait_chase);
-				return;
+		case IOSP_EXT_STATUS_CHASE_RSP:
+			/* we want to do EXT status regardless of port
+			 * open/closed */
+			dbg("%s - Port %u EXT CHASE_RSP Data = %02x",
+					__func__, edge_serial->rxPort, byte3);
+			/* Currently, the only EXT_STATUS is Chase, so process
+			 * here instead of one more call to one more subroutine
+			 * If/when more EXT_STATUS, there'll be more work to do
+			 * Also, we currently clear flag and close the port
+			 * regardless of content of above's Byte3.
+			 * We could choose to do something else when Byte3 says
+			 * Timeout on Chase from Edgeport, like wait longer in
+			 * block_until_chase_response, but for now we don't.
+			 */
+			edge_port->chaseResponsePending = false;
+			wake_up(&edge_port->wait_chase);
+			return;
 
-			case IOSP_EXT_STATUS_RX_CHECK_RSP:
-				dbg("%s ========== Port %u CHECK_RSP Sequence = %02x =============\n", __func__, edge_serial->rxPort, byte3 );
-				//Port->RxCheckRsp = true;
-				return;
+		case IOSP_EXT_STATUS_RX_CHECK_RSP:
+			dbg("%s ========== Port %u CHECK_RSP Sequence = %02x =============\n", __func__, edge_serial->rxPort, byte3);
+			/* Port->RxCheckRsp = true; */
+			return;
 		}
 	}
 
@@ -1918,12 +2056,14 @@ static void process_rcvd_status (struct edgeport_serial *edge_serial, __u8 byte2
 		edge_port->txCredits = GET_TX_BUFFER_SIZE(byte3);
 		edge_port->maxTxCredits = edge_port->txCredits;
 		dbg("%s - Port %u Open Response Inital MSR = %02x TxBufferSize = %d", __func__, edge_serial->rxPort, byte2, edge_port->txCredits);
-		handle_new_msr (edge_port, byte2);
+		handle_new_msr(edge_port, byte2);
 
-		/* send the current line settings to the port so we are in sync with any further termios calls */
+		/* send the current line settings to the port so we are
+		   in sync with any further termios calls */
 		/* FIXME: locking on tty */
 		if (edge_port->port->port.tty)
-			change_port_settings(edge_port->port->port.tty, edge_port, edge_port->port->port.tty->termios);
+			change_port_settings(edge_port->port->port.tty,
+				edge_port, edge_port->port->port.tty->termios);
 
 		/* we have completed the open */
 		edge_port->openPending = false;
@@ -1932,45 +2072,49 @@ static void process_rcvd_status (struct edgeport_serial *edge_serial, __u8 byte2
 		return;
 	}
 
-	// If port is closed, silently discard all rcvd status. We can
-	// have cases where buffered status is received AFTER the close
-	// port command is sent to the Edgeport.
-	if (!edge_port->open || edge_port->closePending) {
+	/* If port is closed, silently discard all rcvd status. We can
+	 * have cases where buffered status is received AFTER the close
+	 * port command is sent to the Edgeport.
+	 */
+	if (!edge_port->open || edge_port->closePending)
 		return;
-	}
 
 	switch (code) {
-		// Not currently sent by Edgeport
-		case IOSP_STATUS_LSR:
-			dbg("%s - Port %u LSR Status = %02x", __func__, edge_serial->rxPort, byte2);
-			handle_new_lsr(edge_port, false, byte2, 0);
-			break;
+	/* Not currently sent by Edgeport */
+	case IOSP_STATUS_LSR:
+		dbg("%s - Port %u LSR Status = %02x",
+					__func__, edge_serial->rxPort, byte2);
+		handle_new_lsr(edge_port, false, byte2, 0);
+		break;
 
-		case IOSP_STATUS_LSR_DATA:
-			dbg("%s - Port %u LSR Status = %02x, Data = %02x", __func__, edge_serial->rxPort, byte2, byte3);
-			// byte2 is LSR Register
-			// byte3 is broken data byte
-			handle_new_lsr(edge_port, true, byte2, byte3);
-			break;
-			//
-			//	case IOSP_EXT_4_STATUS:
-			//		dbg("%s - Port %u LSR Status = %02x Data = %02x", __func__, edge_serial->rxPort, byte2, byte3);
-			//		break;
-			//
-		case IOSP_STATUS_MSR:
-			dbg("%s - Port %u MSR Status = %02x", __func__, edge_serial->rxPort, byte2);
-
-			// Process this new modem status and generate appropriate
-			// events, etc, based on the new status. This routine
-			// also saves the MSR in Port->ShadowMsr.
-			handle_new_msr(edge_port, byte2);
-			break;
+	case IOSP_STATUS_LSR_DATA:
+		dbg("%s - Port %u LSR Status = %02x, Data = %02x",
+				__func__, edge_serial->rxPort, byte2, byte3);
+		/* byte2 is LSR Register */
+		/* byte3 is broken data byte */
+		handle_new_lsr(edge_port, true, byte2, byte3);
+		break;
+	/*
+	 *	case IOSP_EXT_4_STATUS:
+	 *		dbg("%s - Port %u LSR Status = %02x Data = %02x",
+	 *			__func__, edge_serial->rxPort, byte2, byte3);
+	 *		break;
+	 */
+	case IOSP_STATUS_MSR:
+		dbg("%s - Port %u MSR Status = %02x",
+					__func__, edge_serial->rxPort, byte2);
+		/*
+		 * Process this new modem status and generate appropriate
+		 * events, etc, based on the new status. This routine
+		 * also saves the MSR in Port->ShadowMsr.
+		 */
+		handle_new_msr(edge_port, byte2);
+		break;
 
-		default:
-			dbg("%s - Unrecognized IOSP status code %u\n", __func__, code);
-			break;
+	default:
+		dbg("%s - Unrecognized IOSP status code %u\n", __func__, code);
+		break;
 	}
-
 	return;
 }
 
@@ -1979,7 +2123,8 @@ static void process_rcvd_status (struct edgeport_serial *edge_serial, __u8 byte2
  * edge_tty_recv
  *	this function passes data on to the tty flip buffer
  *****************************************************************************/
-static void edge_tty_recv(struct device *dev, struct tty_struct *tty, unsigned char *data, int length)
+static void edge_tty_recv(struct device *dev, struct tty_struct *tty,
+					unsigned char *data, int length)
 {
 	int cnt;
 
@@ -1988,7 +2133,7 @@ static void edge_tty_recv(struct device *dev, struct tty_struct *tty, unsigned c
 		if (cnt < length) {
 			dev_err(dev, "%s - dropping data, %d bytes lost\n",
 					__func__, length - cnt);
-			if(cnt == 0)
+			if (cnt == 0)
 				break;
 		}
 		tty_insert_flip_string(tty, data, cnt);
@@ -2010,22 +2155,19 @@ static void handle_new_msr(struct edgeport_port *edge_port, __u8 newMsr)
 
 	dbg("%s %02x", __func__, newMsr);
 
-	if (newMsr & (EDGEPORT_MSR_DELTA_CTS | EDGEPORT_MSR_DELTA_DSR | EDGEPORT_MSR_DELTA_RI | EDGEPORT_MSR_DELTA_CD)) {
+	if (newMsr & (EDGEPORT_MSR_DELTA_CTS | EDGEPORT_MSR_DELTA_DSR |
+			EDGEPORT_MSR_DELTA_RI | EDGEPORT_MSR_DELTA_CD)) {
 		icount = &edge_port->icount;
 
 		/* update input line counters */
-		if (newMsr & EDGEPORT_MSR_DELTA_CTS) {
+		if (newMsr & EDGEPORT_MSR_DELTA_CTS)
 			icount->cts++;
-		}
-		if (newMsr & EDGEPORT_MSR_DELTA_DSR) {
+		if (newMsr & EDGEPORT_MSR_DELTA_DSR)
 			icount->dsr++;
-		}
-		if (newMsr & EDGEPORT_MSR_DELTA_CD) {
+		if (newMsr & EDGEPORT_MSR_DELTA_CD)
 			icount->dcd++;
-		}
-		if (newMsr & EDGEPORT_MSR_DELTA_RI) {
+		if (newMsr & EDGEPORT_MSR_DELTA_RI)
 			icount->rng++;
-		}
 		wake_up_interruptible(&edge_port->delta_msr_wait);
 	}
 
@@ -2040,42 +2182,41 @@ static void handle_new_msr(struct edgeport_port *edge_port, __u8 newMsr)
  * handle_new_lsr
  *	this function handles any change to the lsr register for a port.
  *****************************************************************************/
-static void handle_new_lsr(struct edgeport_port *edge_port, __u8 lsrData, __u8 lsr, __u8 data)
+static void handle_new_lsr(struct edgeport_port *edge_port, __u8 lsrData,
+							__u8 lsr, __u8 data)
 {
-	__u8    newLsr = (__u8)(lsr & (__u8)(LSR_OVER_ERR | LSR_PAR_ERR | LSR_FRM_ERR | LSR_BREAK));
-	struct  async_icount *icount;
+	__u8 newLsr = (__u8) (lsr & (__u8)
+		(LSR_OVER_ERR | LSR_PAR_ERR | LSR_FRM_ERR | LSR_BREAK));
+	struct async_icount *icount;
 
 	dbg("%s - %02x", __func__, newLsr);
 
 	edge_port->shadowLSR = lsr;
 
 	if (newLsr & LSR_BREAK) {
-		//
-		// Parity and Framing errors only count if they
-		// occur exclusive of a break being
-		// received.
-		//
+		/*
+		 * Parity and Framing errors only count if they
+		 * occur exclusive of a break being
+		 * received.
+		 */
 		newLsr &= (__u8)(LSR_OVER_ERR | LSR_BREAK);
 	}
 
 	/* Place LSR data byte into Rx buffer */
 	if (lsrData && edge_port->port->port.tty)
-		edge_tty_recv(&edge_port->port->dev, edge_port->port->port.tty, &data, 1);
+		edge_tty_recv(&edge_port->port->dev,
+					edge_port->port->port.tty, &data, 1);
 
 	/* update input line counters */
 	icount = &edge_port->icount;
-	if (newLsr & LSR_BREAK) {
+	if (newLsr & LSR_BREAK)
 		icount->brk++;
-	}
-	if (newLsr & LSR_OVER_ERR) {
+	if (newLsr & LSR_OVER_ERR)
 		icount->overrun++;
-	}
-	if (newLsr & LSR_PAR_ERR) {
+	if (newLsr & LSR_PAR_ERR)
 		icount->parity++;
-	}
-	if (newLsr & LSR_FRM_ERR) {
+	if (newLsr & LSR_FRM_ERR)
 		icount->frame++;
-	}
 
 	return;
 }
@@ -2083,12 +2224,13 @@ static void handle_new_lsr(struct edgeport_port *edge_port, __u8 lsrData, __u8 l
 
 /****************************************************************************
  * sram_write
- *	writes a number of bytes to the Edgeport device's sram starting at the 
+ *	writes a number of bytes to the Edgeport device's sram starting at the
  *	given address.
  *	If successful returns the number of bytes written, otherwise it returns
  *	a negative error number of the problem.
  ****************************************************************************/
-static int sram_write (struct usb_serial *serial, __u16 extAddr, __u16 addr, __u16 length, __u8 *data)
+static int sram_write(struct usb_serial *serial, __u16 extAddr, __u16 addr,
+						__u16 length, __u8 *data)
 {
 	int result;
 	__u16 current_length;
@@ -2096,32 +2238,37 @@ static int sram_write (struct usb_serial *serial, __u16 extAddr, __u16 addr, __u
 
 	dbg("%s - %x, %x, %d", __func__, extAddr, addr, length);
 
-	transfer_buffer =  kmalloc (64, GFP_KERNEL);
+	transfer_buffer =  kmalloc(64, GFP_KERNEL);
 	if (!transfer_buffer) {
-		dev_err(&serial->dev->dev, "%s - kmalloc(%d) failed.\n", __func__, 64);
+		dev_err(&serial->dev->dev, "%s - kmalloc(%d) failed.\n",
+							__func__, 64);
 		return -ENOMEM;
 	}
 
 	/* need to split these writes up into 64 byte chunks */
 	result = 0;
 	while (length > 0) {
-		if (length > 64) {
+		if (length > 64)
 			current_length = 64;
-		} else {
+		else
 			current_length = length;
-		}
-//		dbg("%s - writing %x, %x, %d", __func__, extAddr, addr, current_length);
-		memcpy (transfer_buffer, data, current_length);
-		result = usb_control_msg (serial->dev, usb_sndctrlpipe(serial->dev, 0), USB_REQUEST_ION_WRITE_RAM, 
-					  0x40, addr, extAddr, transfer_buffer, current_length, 300);
+
+/*		dbg("%s - writing %x, %x, %d", __func__,
+					extAddr, addr, current_length); */
+		memcpy(transfer_buffer, data, current_length);
+		result = usb_control_msg(serial->dev,
+					usb_sndctrlpipe(serial->dev, 0),
+					USB_REQUEST_ION_WRITE_RAM,
+					0x40, addr, extAddr, transfer_buffer,
+					current_length, 300);
 		if (result < 0)
 			break;
 		length -= current_length;
 		addr += current_length;
 		data += current_length;
-	}       
+	}
 
-	kfree (transfer_buffer);
+	kfree(transfer_buffer);
 	return result;
 }
 
@@ -2133,40 +2280,46 @@ static int sram_write (struct usb_serial *serial, __u16 extAddr, __u16 addr, __u
  *	If successful returns the number of bytes written, otherwise it returns
  *	a negative error number of the problem.
  ****************************************************************************/
-static int rom_write (struct usb_serial *serial, __u16 extAddr, __u16 addr, __u16 length, __u8 *data)
+static int rom_write(struct usb_serial *serial, __u16 extAddr, __u16 addr,
+						__u16 length, __u8 *data)
 {
 	int result;
 	__u16 current_length;
 	unsigned char *transfer_buffer;
 
-//	dbg("%s - %x, %x, %d", __func__, extAddr, addr, length);
+/*	dbg("%s - %x, %x, %d", __func__, extAddr, addr, length); */
 
-	transfer_buffer =  kmalloc (64, GFP_KERNEL);
+	transfer_buffer =  kmalloc(64, GFP_KERNEL);
 	if (!transfer_buffer) {
-		dev_err(&serial->dev->dev, "%s - kmalloc(%d) failed.\n", __func__, 64);
+		dev_err(&serial->dev->dev, "%s - kmalloc(%d) failed.\n",
+								__func__, 64);
 		return -ENOMEM;
 	}
 
 	/* need to split these writes up into 64 byte chunks */
 	result = 0;
 	while (length > 0) {
-		if (length > 64) {
+		if (length > 64)
 			current_length = 64;
-		} else {
+		else
 			current_length = length;
-		}
-//		dbg("%s - writing %x, %x, %d", __func__, extAddr, addr, current_length);
-		memcpy (transfer_buffer, data, current_length);
-		result = usb_control_msg (serial->dev, usb_sndctrlpipe(serial->dev, 0), USB_REQUEST_ION_WRITE_ROM, 
-					  0x40, addr, extAddr, transfer_buffer, current_length, 300);
+
+/*		dbg("%s - writing %x, %x, %d", __func__,
+					extAddr, addr, current_length); */
+		memcpy(transfer_buffer, data, current_length);
+		result = usb_control_msg(serial->dev,
+					usb_sndctrlpipe(serial->dev, 0),
+					USB_REQUEST_ION_WRITE_ROM, 0x40,
+					addr, extAddr,
+					transfer_buffer, current_length, 300);
 		if (result < 0)
 			break;
 		length -= current_length;
 		addr += current_length;
 		data += current_length;
-	}       
+	}
 
-	kfree (transfer_buffer);
+	kfree(transfer_buffer);
 	return result;
 }
 
@@ -2178,7 +2331,8 @@ static int rom_write (struct usb_serial *serial, __u16 extAddr, __u16 addr, __u1
  *	If successful returns the number of bytes read, otherwise it returns
  *	a negative error number of the problem.
  ****************************************************************************/
-static int rom_read (struct usb_serial *serial, __u16 extAddr, __u16 addr, __u16 length, __u8 *data)
+static int rom_read(struct usb_serial *serial, __u16 extAddr,
+					__u16 addr, __u16 length, __u8 *data)
 {
 	int result;
 	__u16 current_length;
@@ -2186,32 +2340,36 @@ static int rom_read (struct usb_serial *serial, __u16 extAddr, __u16 addr, __u16
 
 	dbg("%s - %x, %x, %d", __func__, extAddr, addr, length);
 
-	transfer_buffer =  kmalloc (64, GFP_KERNEL);
+	transfer_buffer =  kmalloc(64, GFP_KERNEL);
 	if (!transfer_buffer) {
-		dev_err(&serial->dev->dev, "%s - kmalloc(%d) failed.\n", __func__, 64);
+		dev_err(&serial->dev->dev,
+			"%s - kmalloc(%d) failed.\n", __func__, 64);
 		return -ENOMEM;
 	}
 
 	/* need to split these reads up into 64 byte chunks */
 	result = 0;
 	while (length > 0) {
-		if (length > 64) {
+		if (length > 64)
 			current_length = 64;
-		} else {
+		else
 			current_length = length;
-		}
-//		dbg("%s - %x, %x, %d", __func__, extAddr, addr, current_length);
-		result = usb_control_msg (serial->dev, usb_rcvctrlpipe(serial->dev, 0), USB_REQUEST_ION_READ_ROM, 
-					  0xC0, addr, extAddr, transfer_buffer, current_length, 300);
+/*		dbg("%s - %x, %x, %d", __func__,
+				extAddr, addr, current_length); */
+		result = usb_control_msg(serial->dev,
+					usb_rcvctrlpipe(serial->dev, 0),
+					USB_REQUEST_ION_READ_ROM,
+					0xC0, addr, extAddr, transfer_buffer,
+					current_length, 300);
 		if (result < 0)
 			break;
-		memcpy (data, transfer_buffer, current_length);
+		memcpy(data, transfer_buffer, current_length);
 		length -= current_length;
 		addr += current_length;
 		data += current_length;
-	}       
+	}
 
-	kfree (transfer_buffer);
+	kfree(transfer_buffer);
 	return result;
 }
 
@@ -2220,7 +2378,8 @@ static int rom_read (struct usb_serial *serial, __u16 extAddr, __u16 addr, __u16
  * send_iosp_ext_cmd
  *	Is used to send a IOSP message to the Edgeport device
  ****************************************************************************/
-static int send_iosp_ext_cmd (struct edgeport_port *edge_port, __u8 command, __u8 param)
+static int send_iosp_ext_cmd(struct edgeport_port *edge_port,
+						__u8 command, __u8 param)
 {
 	unsigned char   *buffer;
 	unsigned char   *currentCommand;
@@ -2229,19 +2388,20 @@ static int send_iosp_ext_cmd (struct edgeport_port *edge_port, __u8 command, __u
 
 	dbg("%s - %d, %d", __func__, command, param);
 
-	buffer =  kmalloc (10, GFP_ATOMIC);
+	buffer = kmalloc(10, GFP_ATOMIC);
 	if (!buffer) {
-		dev_err(&edge_port->port->dev, "%s - kmalloc(%d) failed.\n", __func__, 10);
+		dev_err(&edge_port->port->dev,
+				"%s - kmalloc(%d) failed.\n", __func__, 10);
 		return -ENOMEM;
 	}
 
 	currentCommand = buffer;
 
-	MAKE_CMD_EXT_CMD (&currentCommand, &length,
-			  edge_port->port->number - edge_port->port->serial->minor,
-			  command, param);
+	MAKE_CMD_EXT_CMD(&currentCommand, &length,
+		edge_port->port->number - edge_port->port->serial->minor,
+		command, param);
 
-	status = write_cmd_usb (edge_port, buffer, length);
+	status = write_cmd_usb(edge_port, buffer, length);
 	if (status) {
 		/* something bad happened, let's free up the memory */
 		kfree(buffer);
@@ -2255,43 +2415,50 @@ static int send_iosp_ext_cmd (struct edgeport_port *edge_port, __u8 command, __u
  * write_cmd_usb
  *	this function writes the given buffer out to the bulk write endpoint.
  *****************************************************************************/
-static int write_cmd_usb (struct edgeport_port *edge_port, unsigned char *buffer, int length)
+static int write_cmd_usb(struct edgeport_port *edge_port,
+					unsigned char *buffer, int length)
 {
-	struct edgeport_serial *edge_serial = usb_get_serial_data(edge_port->port->serial);
+	struct edgeport_serial *edge_serial =
+				usb_get_serial_data(edge_port->port->serial);
 	int status = 0;
 	struct urb *urb;
 	int timeout;
 
-	usb_serial_debug_data(debug, &edge_port->port->dev, __func__, length, buffer);
+	usb_serial_debug_data(debug, &edge_port->port->dev,
+						__func__, length, buffer);
 
 	/* Allocate our next urb */
-	urb = usb_alloc_urb (0, GFP_ATOMIC);
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb)
 		return -ENOMEM;
 
 	atomic_inc(&CmdUrbs);
-	dbg("%s - ALLOCATE URB %p (outstanding %d)", __func__, urb, atomic_read(&CmdUrbs));
+	dbg("%s - ALLOCATE URB %p (outstanding %d)",
+				__func__, urb, atomic_read(&CmdUrbs));
 
-	usb_fill_bulk_urb (urb, edge_serial->serial->dev, 
-		       usb_sndbulkpipe(edge_serial->serial->dev, edge_serial->bulk_out_endpoint),
-		       buffer, length, edge_bulk_out_cmd_callback, edge_port);
+	usb_fill_bulk_urb(urb, edge_serial->serial->dev,
+			usb_sndbulkpipe(edge_serial->serial->dev,
+					edge_serial->bulk_out_endpoint),
+			buffer, length, edge_bulk_out_cmd_callback, edge_port);
 
 	edge_port->commandPending = true;
 	status = usb_submit_urb(urb, GFP_ATOMIC);
 
 	if (status) {
 		/* something went wrong */
-		dev_err(&edge_port->port->dev, "%s - usb_submit_urb(write command) failed, status = %d\n", __func__, status);
+		dev_err(&edge_port->port->dev,
+		    "%s - usb_submit_urb(write command) failed, status = %d\n",
+							__func__, status);
 		usb_kill_urb(urb);
 		usb_free_urb(urb);
 		atomic_dec(&CmdUrbs);
 		return status;
 	}
 
-	// wait for command to finish
+	/* wait for command to finish */
 	timeout = COMMAND_TIMEOUT;
 #if 0
-	wait_event (&edge_port->wait_command, !edge_port->commandPending);
+	wait_event(&edge_port->wait_command, !edge_port->commandPending);
 
 	if (edge_port->commandPending) {
 		/* command timed out */
@@ -2308,15 +2475,18 @@ static int write_cmd_usb (struct edgeport_port *edge_port, unsigned char *buffer
  *	this function sends the proper command to change the baud rate of the
  *	specified port.
  *****************************************************************************/
-static int send_cmd_write_baud_rate (struct edgeport_port *edge_port, int baudRate)
+static int send_cmd_write_baud_rate(struct edgeport_port *edge_port,
+								int baudRate)
 {
-	struct edgeport_serial *edge_serial = usb_get_serial_data(edge_port->port->serial);
+	struct edgeport_serial *edge_serial =
+				usb_get_serial_data(edge_port->port->serial);
 	unsigned char *cmdBuffer;
 	unsigned char *currCmd;
 	int cmdLen = 0;
 	int divisor;
 	int status;
-	unsigned char number = edge_port->port->number - edge_port->port->serial->minor;
+	unsigned char number =
+		edge_port->port->number - edge_port->port->serial->minor;
 
 	if (edge_serial->is_epic &&
 	    !edge_serial->epic_descriptor.Supports.IOSPSetBaudRate) {
@@ -2325,36 +2495,40 @@ static int send_cmd_write_baud_rate (struct edgeport_port *edge_port, int baudRa
 		return 0;
 	}
 
-	dbg("%s - port = %d, baud = %d", __func__, edge_port->port->number, baudRate);
+	dbg("%s - port = %d, baud = %d", __func__,
+					edge_port->port->number, baudRate);
 
-	status = calc_baud_rate_divisor (baudRate, &divisor);
+	status = calc_baud_rate_divisor(baudRate, &divisor);
 	if (status) {
-		dev_err(&edge_port->port->dev, "%s - bad baud rate\n", __func__);
+		dev_err(&edge_port->port->dev, "%s - bad baud rate\n",
+								__func__);
 		return status;
 	}
 
-	// Alloc memory for the string of commands.
-	cmdBuffer =  kmalloc (0x100, GFP_ATOMIC);
+	/* Alloc memory for the string of commands. */
+	cmdBuffer =  kmalloc(0x100, GFP_ATOMIC);
 	if (!cmdBuffer) {
-		dev_err(&edge_port->port->dev, "%s - kmalloc(%d) failed.\n", __func__, 0x100);
+		dev_err(&edge_port->port->dev,
+			"%s - kmalloc(%d) failed.\n", __func__, 0x100);
 		return -ENOMEM;
 	}
 	currCmd = cmdBuffer;
 
-	// Enable access to divisor latch
-	MAKE_CMD_WRITE_REG( &currCmd, &cmdLen, number, LCR, LCR_DL_ENABLE );
+	/* Enable access to divisor latch */
+	MAKE_CMD_WRITE_REG(&currCmd, &cmdLen, number, LCR, LCR_DL_ENABLE);
 
-	// Write the divisor itself
-	MAKE_CMD_WRITE_REG( &currCmd, &cmdLen, number, DLL, LOW8 (divisor) );
-	MAKE_CMD_WRITE_REG( &currCmd, &cmdLen, number, DLM, HIGH8(divisor) );
+	/* Write the divisor itself */
+	MAKE_CMD_WRITE_REG(&currCmd, &cmdLen, number, DLL, LOW8(divisor));
+	MAKE_CMD_WRITE_REG(&currCmd, &cmdLen, number, DLM, HIGH8(divisor));
 
-	// Restore original value to disable access to divisor latch
-	MAKE_CMD_WRITE_REG( &currCmd, &cmdLen, number, LCR, edge_port->shadowLCR);
+	/* Restore original value to disable access to divisor latch */
+	MAKE_CMD_WRITE_REG(&currCmd, &cmdLen, number, LCR,
+						edge_port->shadowLCR);
 
-	status = write_cmd_usb(edge_port, cmdBuffer, cmdLen );
+	status = write_cmd_usb(edge_port, cmdBuffer, cmdLen);
 	if (status) {
 		/* something bad happened, let's free up the memory */
-		kfree (cmdBuffer);
+		kfree(cmdBuffer);
 	}
 
 	return status;
@@ -2366,7 +2540,7 @@ static int send_cmd_write_baud_rate (struct edgeport_port *edge_port, int baudRa
  *	this function calculates the proper baud rate divisor for the specified
  *	baud rate.
  *****************************************************************************/
-static int calc_baud_rate_divisor (int baudrate, int *divisor)
+static int calc_baud_rate_divisor(int baudrate, int *divisor)
 {
 	int i;
 	__u16 custom;
@@ -2375,17 +2549,17 @@ static int calc_baud_rate_divisor (int baudrate, int *divisor)
 	dbg("%s - %d", __func__, baudrate);
 
 	for (i = 0; i < ARRAY_SIZE(divisor_table); i++) {
-		if ( divisor_table[i].BaudRate == baudrate ) {
+		if (divisor_table[i].BaudRate == baudrate) {
 			*divisor = divisor_table[i].Divisor;
 			return 0;
 		}
 	}
 
-	// We have tried all of the standard baud rates
-	// lets try to calculate the divisor for this baud rate
-	// Make sure the baud rate is reasonable
+	/* We have tried all of the standard baud rates
+	 * lets try to calculate the divisor for this baud rate
+	 * Make sure the baud rate is reasonable */
 	if (baudrate > 50 && baudrate < 230400) {
-		// get divisor
+		/* get divisor */
 		custom = (__u16)((230400L + baudrate/2) / baudrate);
 
 		*divisor = custom;
@@ -2400,17 +2574,20 @@ static int calc_baud_rate_divisor (int baudrate, int *divisor)
 
 /*****************************************************************************
  * send_cmd_write_uart_register
- *	this function builds up a uart register message and sends to to the device.
+ *  this function builds up a uart register message and sends to to the device.
  *****************************************************************************/
-static int send_cmd_write_uart_register (struct edgeport_port *edge_port, __u8 regNum, __u8 regValue)
+static int send_cmd_write_uart_register(struct edgeport_port *edge_port,
+						__u8 regNum, __u8 regValue)
 {
-	struct edgeport_serial *edge_serial = usb_get_serial_data(edge_port->port->serial);
+	struct edgeport_serial *edge_serial =
+				usb_get_serial_data(edge_port->port->serial);
 	unsigned char *cmdBuffer;
 	unsigned char *currCmd;
 	unsigned long cmdLen = 0;
 	int status;
 
-	dbg("%s - write to %s register 0x%02x", (regNum == MCR) ? "MCR" : "LCR", __func__, regValue);
+	dbg("%s - write to %s register 0x%02x",
+			(regNum == MCR) ? "MCR" : "LCR", __func__, regValue);
 
 	if (edge_serial->is_epic &&
 	    !edge_serial->epic_descriptor.Supports.IOSPWriteMCR &&
@@ -2422,27 +2599,26 @@ static int send_cmd_write_uart_register (struct edgeport_port *edge_port, __u8 r
 	if (edge_serial->is_epic &&
 	    !edge_serial->epic_descriptor.Supports.IOSPWriteLCR &&
 	    regNum == LCR) {
-		dbg ("SendCmdWriteUartReg - Not writing to LCR Register");
+		dbg("SendCmdWriteUartReg - Not writing to LCR Register");
 		return 0;
 	}
 
-	// Alloc memory for the string of commands.
-	cmdBuffer = kmalloc (0x10, GFP_ATOMIC);
-	if (cmdBuffer == NULL ) {
+	/* Alloc memory for the string of commands. */
+	cmdBuffer = kmalloc(0x10, GFP_ATOMIC);
+	if (cmdBuffer == NULL)
 		return -ENOMEM;
-	}
 
 	currCmd = cmdBuffer;
 
-	// Build a cmd in the buffer to write the given register
-	MAKE_CMD_WRITE_REG (&currCmd, &cmdLen,
-			    edge_port->port->number - edge_port->port->serial->minor,
-			    regNum, regValue);
+	/* Build a cmd in the buffer to write the given register */
+	MAKE_CMD_WRITE_REG(&currCmd, &cmdLen,
+		edge_port->port->number - edge_port->port->serial->minor,
+		regNum, regValue);
 
 	status = write_cmd_usb(edge_port, cmdBuffer, cmdLen);
 	if (status) {
 		/* something bad happened, let's free up the memory */
-		kfree (cmdBuffer);
+		kfree(cmdBuffer);
 	}
 
 	return status;
@@ -2451,14 +2627,15 @@ static int send_cmd_write_uart_register (struct edgeport_port *edge_port, __u8 r
 
 /*****************************************************************************
  * change_port_settings
- *	This routine is called to set the UART on the device to match the specified
- *	new settings.
+ *	This routine is called to set the UART on the device to match the
+ *	specified new settings.
  *****************************************************************************/
 
 static void change_port_settings(struct tty_struct *tty,
 	struct edgeport_port *edge_port, struct ktermios *old_termios)
 {
-	struct edgeport_serial *edge_serial = usb_get_serial_data(edge_port->port->serial);
+	struct edgeport_serial *edge_serial =
+			usb_get_serial_data(edge_port->port->serial);
 	int baud;
 	unsigned cflag;
 	__u8 mask = 0xff;
@@ -2480,11 +2657,23 @@ static void change_port_settings(struct tty_struct *tty,
 	cflag = tty->termios->c_cflag;
 
 	switch (cflag & CSIZE) {
-		case CS5:   lData = LCR_BITS_5; mask = 0x1f;    dbg("%s - data bits = 5", __func__);   break;
-		case CS6:   lData = LCR_BITS_6; mask = 0x3f;    dbg("%s - data bits = 6", __func__);   break;
-		case CS7:   lData = LCR_BITS_7; mask = 0x7f;    dbg("%s - data bits = 7", __func__);   break;
-		default:
-		case CS8:   lData = LCR_BITS_8;                 dbg("%s - data bits = 8", __func__);   break;
+	case CS5:
+		lData = LCR_BITS_5; mask = 0x1f;
+		dbg("%s - data bits = 5", __func__);
+		break;
+	case CS6:
+		lData = LCR_BITS_6; mask = 0x3f;
+		dbg("%s - data bits = 6", __func__);
+		break;
+	case CS7:
+		lData = LCR_BITS_7; mask = 0x7f;
+		dbg("%s - data bits = 7", __func__);
+		break;
+	default:
+	case CS8:
+		lData = LCR_BITS_8;
+		dbg("%s - data bits = 8", __func__);
+		break;
 	}
 
 	lParity = LCR_PAR_NONE;
@@ -2526,7 +2715,8 @@ static void change_port_settings(struct tty_struct *tty,
 		dbg("%s - RTS/CTS is disabled", __func__);
 	}
 
-	/* if we are implementing XON/XOFF, set the start and stop character in the device */
+	/* if we are implementing XON/XOFF, set the start and stop character
+	   in the device */
 	if (I_IXOFF(tty) || I_IXON(tty)) {
 		unsigned char stop_char  = STOP_CHAR(tty);
 		unsigned char start_char = START_CHAR(tty);
@@ -2534,14 +2724,17 @@ static void change_port_settings(struct tty_struct *tty,
 		if ((!edge_serial->is_epic) ||
 		    ((edge_serial->is_epic) &&
 		     (edge_serial->epic_descriptor.Supports.IOSPSetXChar))) {
-			send_iosp_ext_cmd(edge_port, IOSP_CMD_SET_XON_CHAR, start_char);
-			send_iosp_ext_cmd(edge_port, IOSP_CMD_SET_XOFF_CHAR, stop_char);
+			send_iosp_ext_cmd(edge_port,
+					IOSP_CMD_SET_XON_CHAR, start_char);
+			send_iosp_ext_cmd(edge_port,
+					IOSP_CMD_SET_XOFF_CHAR, stop_char);
 		}
 
 		/* if we are implementing INBOUND XON/XOFF */
 		if (I_IXOFF(tty)) {
 			rxFlow |= IOSP_RX_FLOW_XON_XOFF;
-			dbg("%s - INBOUND XON/XOFF is enabled, XON = %2x, XOFF = %2x", __func__, start_char, stop_char);
+			dbg("%s - INBOUND XON/XOFF is enabled, XON = %2x, XOFF = %2x",
+					__func__, start_char, stop_char);
 		} else {
 			dbg("%s - INBOUND XON/XOFF is disabled", __func__);
 		}
@@ -2549,7 +2742,8 @@ static void change_port_settings(struct tty_struct *tty,
 		/* if we are implementing OUTBOUND XON/XOFF */
 		if (I_IXON(tty)) {
 			txFlow |= IOSP_TX_FLOW_XON_XOFF;
-			dbg("%s - OUTBOUND XON/XOFF is enabled, XON = %2x, XOFF = %2x", __func__, start_char, stop_char);
+			dbg("%s - OUTBOUND XON/XOFF is enabled, XON = %2x, XOFF = %2x",
+					__func__, start_char, stop_char);
 		} else {
 			dbg("%s - OUTBOUND XON/XOFF is disabled", __func__);
 		}
@@ -2572,20 +2766,20 @@ static void change_port_settings(struct tty_struct *tty,
 	edge_port->validDataMask = mask;
 
 	/* Send the updated LCR value to the EdgePort */
-	status = send_cmd_write_uart_register(edge_port, LCR, edge_port->shadowLCR);
-	if (status != 0) {
+	status = send_cmd_write_uart_register(edge_port, LCR,
+							edge_port->shadowLCR);
+	if (status != 0)
 		return;
-	}
 
 	/* set up the MCR register and send it to the EdgePort */
 	edge_port->shadowMCR = MCR_MASTER_IE;
-	if (cflag & CBAUD) {
+	if (cflag & CBAUD)
 		edge_port->shadowMCR |= (MCR_DTR | MCR_RTS);
-	}
-	status = send_cmd_write_uart_register(edge_port, MCR, edge_port->shadowMCR);
-	if (status != 0) {
+
+	status = send_cmd_write_uart_register(edge_port, MCR,
+						edge_port->shadowMCR);
+	if (status != 0)
 		return;
-	}
 
 	/* Determine divisor based on baud rate */
 	baud = tty_get_baud_rate(tty);
@@ -2595,7 +2789,7 @@ static void change_port_settings(struct tty_struct *tty,
 	}
 
 	dbg("%s - baud rate = %d", __func__, baud);
-	status = send_cmd_write_baud_rate (edge_port, baud);
+	status = send_cmd_write_baud_rate(edge_port, baud);
 	if (status == -1) {
 		/* Speed change was not possible - put back the old speed */
 		baud = tty_termios_baud_rate(old_termios);
@@ -2612,7 +2806,8 @@ static void change_port_settings(struct tty_struct *tty,
  *	ASCII range, but it's only for debugging...
  *	NOTE: expects the unicode in LE format
  ****************************************************************************/
-static void unicode_to_ascii(char *string, int buflen, __le16 *unicode, int unicode_size)
+static void unicode_to_ascii(char *string, int buflen,
+					__le16 *unicode, int unicode_size)
 {
 	int i;
 
@@ -2631,75 +2826,99 @@ static void unicode_to_ascii(char *string, int buflen, __le16 *unicode, int unic
 
 /****************************************************************************
  * get_manufacturing_desc
- *	reads in the manufacturing descriptor and stores it into the serial 
+ *	reads in the manufacturing descriptor and stores it into the serial
  *	structure.
  ****************************************************************************/
-static void get_manufacturing_desc (struct edgeport_serial *edge_serial)
+static void get_manufacturing_desc(struct edgeport_serial *edge_serial)
 {
 	int response;
 
 	dbg("getting manufacturer descriptor");
 
-	response = rom_read (edge_serial->serial, (EDGE_MANUF_DESC_ADDR & 0xffff0000) >> 16, 
-			    (__u16)(EDGE_MANUF_DESC_ADDR & 0x0000ffff), EDGE_MANUF_DESC_LEN,
-			    (__u8 *)(&edge_serial->manuf_descriptor));
+	response = rom_read(edge_serial->serial,
+				(EDGE_MANUF_DESC_ADDR & 0xffff0000) >> 16,
+				(__u16)(EDGE_MANUF_DESC_ADDR & 0x0000ffff),
+				EDGE_MANUF_DESC_LEN,
+				(__u8 *)(&edge_serial->manuf_descriptor));
 
-	if (response < 1) {
-		dev_err(&edge_serial->serial->dev->dev, "error in getting manufacturer descriptor\n");
-	} else {
+	if (response < 1)
+		dev_err(&edge_serial->serial->dev->dev,
+			"error in getting manufacturer descriptor\n");
+	else {
 		char string[30];
 		dbg("**Manufacturer Descriptor");
-		dbg("  RomSize:        %dK", edge_serial->manuf_descriptor.RomSize);
-		dbg("  RamSize:        %dK", edge_serial->manuf_descriptor.RamSize);
-		dbg("  CpuRev:         %d", edge_serial->manuf_descriptor.CpuRev);
-		dbg("  BoardRev:       %d", edge_serial->manuf_descriptor.BoardRev);
-		dbg("  NumPorts:       %d", edge_serial->manuf_descriptor.NumPorts);
-		dbg("  DescDate:       %d/%d/%d", edge_serial->manuf_descriptor.DescDate[0], edge_serial->manuf_descriptor.DescDate[1], edge_serial->manuf_descriptor.DescDate[2]+1900);
+		dbg("  RomSize:        %dK",
+			edge_serial->manuf_descriptor.RomSize);
+		dbg("  RamSize:        %dK",
+			edge_serial->manuf_descriptor.RamSize);
+		dbg("  CpuRev:         %d",
+			edge_serial->manuf_descriptor.CpuRev);
+		dbg("  BoardRev:       %d",
+			edge_serial->manuf_descriptor.BoardRev);
+		dbg("  NumPorts:       %d",
+			edge_serial->manuf_descriptor.NumPorts);
+		dbg("  DescDate:       %d/%d/%d",
+			edge_serial->manuf_descriptor.DescDate[0],
+			edge_serial->manuf_descriptor.DescDate[1],
+			edge_serial->manuf_descriptor.DescDate[2]+1900);
 		unicode_to_ascii(string, sizeof(string),
-		    edge_serial->manuf_descriptor.SerialNumber,
-		    edge_serial->manuf_descriptor.SerNumLength/2);
+			edge_serial->manuf_descriptor.SerialNumber,
+			edge_serial->manuf_descriptor.SerNumLength/2);
 		dbg("  SerialNumber: %s", string);
 		unicode_to_ascii(string, sizeof(string),
-		    edge_serial->manuf_descriptor.AssemblyNumber,
-		    edge_serial->manuf_descriptor.AssemblyNumLength/2);
+			edge_serial->manuf_descriptor.AssemblyNumber,
+			edge_serial->manuf_descriptor.AssemblyNumLength/2);
 		dbg("  AssemblyNumber: %s", string);
 		unicode_to_ascii(string, sizeof(string),
 		    edge_serial->manuf_descriptor.OemAssyNumber,
 		    edge_serial->manuf_descriptor.OemAssyNumLength/2);
 		dbg("  OemAssyNumber:  %s", string);
-		dbg("  UartType:       %d", edge_serial->manuf_descriptor.UartType);
-		dbg("  IonPid:         %d", edge_serial->manuf_descriptor.IonPid);
-		dbg("  IonConfig:      %d", edge_serial->manuf_descriptor.IonConfig);
+		dbg("  UartType:       %d",
+			edge_serial->manuf_descriptor.UartType);
+		dbg("  IonPid:         %d",
+			edge_serial->manuf_descriptor.IonPid);
+		dbg("  IonConfig:      %d",
+			edge_serial->manuf_descriptor.IonConfig);
 	}
 }
 
 
 /****************************************************************************
  * get_boot_desc
- *	reads in the bootloader descriptor and stores it into the serial 
+ *	reads in the bootloader descriptor and stores it into the serial
  *	structure.
  ****************************************************************************/
-static void get_boot_desc (struct edgeport_serial *edge_serial)
+static void get_boot_desc(struct edgeport_serial *edge_serial)
 {
 	int response;
 
 	dbg("getting boot descriptor");
 
-	response = rom_read (edge_serial->serial, (EDGE_BOOT_DESC_ADDR & 0xffff0000) >> 16, 
-			    (__u16)(EDGE_BOOT_DESC_ADDR & 0x0000ffff), EDGE_BOOT_DESC_LEN,
-			    (__u8 *)(&edge_serial->boot_descriptor));
+	response = rom_read(edge_serial->serial,
+				(EDGE_BOOT_DESC_ADDR & 0xffff0000) >> 16,
+				(__u16)(EDGE_BOOT_DESC_ADDR & 0x0000ffff),
+				EDGE_BOOT_DESC_LEN,
+				(__u8 *)(&edge_serial->boot_descriptor));
 
-	if (response < 1) {
-		dev_err(&edge_serial->serial->dev->dev, "error in getting boot descriptor\n");
-	} else {
+	if (response < 1)
+		dev_err(&edge_serial->serial->dev->dev,
+				"error in getting boot descriptor\n");
+	else {
 		dbg("**Boot Descriptor:");
-		dbg("  BootCodeLength: %d", le16_to_cpu(edge_serial->boot_descriptor.BootCodeLength));
-		dbg("  MajorVersion:   %d", edge_serial->boot_descriptor.MajorVersion);
-		dbg("  MinorVersion:   %d", edge_serial->boot_descriptor.MinorVersion);
-		dbg("  BuildNumber:    %d", le16_to_cpu(edge_serial->boot_descriptor.BuildNumber));
-		dbg("  Capabilities:   0x%x", le16_to_cpu(edge_serial->boot_descriptor.Capabilities));
-		dbg("  UConfig0:       %d", edge_serial->boot_descriptor.UConfig0);
-		dbg("  UConfig1:       %d", edge_serial->boot_descriptor.UConfig1);
+		dbg("  BootCodeLength: %d",
+		    le16_to_cpu(edge_serial->boot_descriptor.BootCodeLength));
+		dbg("  MajorVersion:   %d",
+			edge_serial->boot_descriptor.MajorVersion);
+		dbg("  MinorVersion:   %d",
+			edge_serial->boot_descriptor.MinorVersion);
+		dbg("  BuildNumber:    %d",
+			le16_to_cpu(edge_serial->boot_descriptor.BuildNumber));
+		dbg("  Capabilities:   0x%x",
+		      le16_to_cpu(edge_serial->boot_descriptor.Capabilities));
+		dbg("  UConfig0:       %d",
+			edge_serial->boot_descriptor.UConfig0);
+		dbg("  UConfig1:       %d",
+			edge_serial->boot_descriptor.UConfig1);
 	}
 }
 
@@ -2708,7 +2927,7 @@ static void get_boot_desc (struct edgeport_serial *edge_serial)
  * load_application_firmware
  *	This is called to load the application firmware to the device
  ****************************************************************************/
-static void load_application_firmware (struct edgeport_serial *edge_serial)
+static void load_application_firmware(struct edgeport_serial *edge_serial)
 {
 	struct edge_firmware_image_record *record;
 	unsigned char *firmware;
@@ -2718,53 +2937,60 @@ static void load_application_firmware (struct edgeport_serial *edge_serial)
 
 
 	switch (edge_serial->product_info.iDownloadFile) {
-		case EDGE_DOWNLOAD_FILE_I930:
-			dbg("downloading firmware version (930) %d.%d.%d", 
-			    OperationalCodeImageVersion_GEN1.MajorVersion, 
-			    OperationalCodeImageVersion_GEN1.MinorVersion, 
-			    OperationalCodeImageVersion_GEN1.BuildNumber);
-			firmware = &OperationalCodeImage_GEN1[0];
-			FirmwareImage = &OperationalCodeImage_GEN1[0];
-			ImageSize = sizeof(OperationalCodeImage_GEN1);
-			break;
+	case EDGE_DOWNLOAD_FILE_I930:
+		dbg("downloading firmware version (930) %d.%d.%d",
+		    OperationalCodeImageVersion_GEN1.MajorVersion,
+		    OperationalCodeImageVersion_GEN1.MinorVersion,
+		    OperationalCodeImageVersion_GEN1.BuildNumber);
+		firmware = &OperationalCodeImage_GEN1[0];
+		FirmwareImage = &OperationalCodeImage_GEN1[0];
+		ImageSize = sizeof(OperationalCodeImage_GEN1);
+		break;
 
-		case EDGE_DOWNLOAD_FILE_80251:
-			dbg("downloading firmware version (80251) %d.%d.%d", 
-			    OperationalCodeImageVersion_GEN2.MajorVersion, 
-			    OperationalCodeImageVersion_GEN2.MinorVersion, 
-			    OperationalCodeImageVersion_GEN2.BuildNumber);
-			firmware = &OperationalCodeImage_GEN2[0];
-			FirmwareImage = &OperationalCodeImage_GEN2[0];
-			ImageSize = sizeof(OperationalCodeImage_GEN2);
-			break;
+	case EDGE_DOWNLOAD_FILE_80251:
+		dbg("downloading firmware version (80251) %d.%d.%d",
+		    OperationalCodeImageVersion_GEN2.MajorVersion,
+		    OperationalCodeImageVersion_GEN2.MinorVersion,
+		    OperationalCodeImageVersion_GEN2.BuildNumber);
+		firmware = &OperationalCodeImage_GEN2[0];
+		FirmwareImage = &OperationalCodeImage_GEN2[0];
+		ImageSize = sizeof(OperationalCodeImage_GEN2);
+		break;
 
-		case EDGE_DOWNLOAD_FILE_NONE:
-			dbg     ("No download file specified, skipping download\n");
-			return;
+	case EDGE_DOWNLOAD_FILE_NONE:
+		dbg("No download file specified, skipping download\n");
+		return;
 
-		default:
-			return;
+	default:
+		return;
 	}
 
-
 	for (;;) {
 		record = (struct edge_firmware_image_record *)firmware;
-		response = sram_write (edge_serial->serial, le16_to_cpu(record->ExtAddr), le16_to_cpu(record->Addr), le16_to_cpu(record->Len), &record->Data[0]);
+		response = sram_write(edge_serial->serial,
+						le16_to_cpu(record->ExtAddr),
+						le16_to_cpu(record->Addr),
+						le16_to_cpu(record->Len),
+						&record->Data[0]);
 		if (response < 0) {
-			dev_err(&edge_serial->serial->dev->dev, "sram_write failed (%x, %x, %d)\n", le16_to_cpu(record->ExtAddr), le16_to_cpu(record->Addr), le16_to_cpu(record->Len));
+			dev_err(&edge_serial->serial->dev->dev,
+				"sram_write failed (%x, %x, %d)\n",
+						le16_to_cpu(record->ExtAddr),
+						le16_to_cpu(record->Addr),
+						le16_to_cpu(record->Len));
 			break;
 		}
-		firmware += sizeof (struct edge_firmware_image_record) + le16_to_cpu(record->Len);
-		if (firmware >= &FirmwareImage[ImageSize]) {
+		firmware += sizeof(struct edge_firmware_image_record)
+						+ le16_to_cpu(record->Len);
+		if (firmware >= &FirmwareImage[ImageSize])
 			break;
-		}
 	}
 
 	dbg("sending exec_dl_code");
-	response = usb_control_msg (edge_serial->serial->dev, 
-				    usb_sndctrlpipe(edge_serial->serial->dev, 0), 
-				    USB_REQUEST_ION_EXEC_DL_CODE, 
-				    0x40, 0x4000, 0x0001, NULL, 0, 3000);
+	response = usb_control_msg(edge_serial->serial->dev,
+			    usb_sndctrlpipe(edge_serial->serial->dev, 0),
+			    USB_REQUEST_ION_EXEC_DL_CODE,
+			    0x40, 0x4000, 0x0001, NULL, 0, 3000);
 
 	return;
 }
@@ -2773,7 +2999,7 @@ static void load_application_firmware (struct edgeport_serial *edge_serial)
 /****************************************************************************
  * edge_startup
  ****************************************************************************/
-static int edge_startup (struct usb_serial *serial)
+static int edge_startup(struct usb_serial *serial)
 {
 	struct edgeport_serial *edge_serial;
 	struct edgeport_port *edge_port;
@@ -2815,10 +3041,10 @@ static int edge_startup (struct usb_serial *serial)
 		       sizeof(struct edge_compatibility_bits));
 
 		/* get the manufacturing descriptor for this device */
-		get_manufacturing_desc (edge_serial);
+		get_manufacturing_desc(edge_serial);
 
 		/* get the boot descriptor */
-		get_boot_desc (edge_serial);
+		get_boot_desc(edge_serial);
 
 		get_product_info(edge_serial);
 	}
@@ -2839,37 +3065,40 @@ static int edge_startup (struct usb_serial *serial)
 	/* If not an EPiC device */
 	if (!edge_serial->is_epic) {
 		/* now load the application firmware into this device */
-		load_application_firmware (edge_serial);
+		load_application_firmware(edge_serial);
 
 		dbg("%s - time 2 %ld", __func__, jiffies);
 
 		/* Check current Edgeport EEPROM and update if necessary */
-		update_edgeport_E2PROM (edge_serial);
+		update_edgeport_E2PROM(edge_serial);
 
 		dbg("%s - time 3 %ld", __func__, jiffies);
 
 		/* set the configuration to use #1 */
-//		dbg("set_configuration 1");
-//		usb_set_configuration (dev, 1);
+/*		dbg("set_configuration 1"); */
+/*		usb_set_configuration (dev, 1); */
 	}
 
-	/* we set up the pointers to the endpoints in the edge_open function, 
+	/* we set up the pointers to the endpoints in the edge_open function,
 	 * as the structures aren't created yet. */
 
 	/* set up our port private structures */
 	for (i = 0; i < serial->num_ports; ++i) {
-		edge_port = kmalloc (sizeof(struct edgeport_port), GFP_KERNEL);
+		edge_port = kmalloc(sizeof(struct edgeport_port), GFP_KERNEL);
 		if (edge_port == NULL) {
-			dev_err(&serial->dev->dev, "%s - Out of memory\n", __func__);
+			dev_err(&serial->dev->dev,
+					"%s - Out of memory\n", __func__);
 			for (j = 0; j < i; ++j) {
-				kfree (usb_get_serial_port_data(serial->port[j]));
-				usb_set_serial_port_data(serial->port[j],  NULL);
+				kfree(usb_get_serial_port_data(
+							serial->port[j]));
+				usb_set_serial_port_data(serial->port[j],
+									NULL);
 			}
 			usb_set_serial_data(serial, NULL);
 			kfree(edge_serial);
 			return -ENOMEM;
 		}
-		memset (edge_port, 0, sizeof(struct edgeport_port));
+		memset(edge_port, 0, sizeof(struct edgeport_port));
 		spin_lock_init(&edge_port->ep_lock);
 		edge_port->port = serial->port[i];
 		usb_set_serial_port_data(serial->port[i], edge_port);
@@ -2878,14 +3107,16 @@ static int edge_startup (struct usb_serial *serial)
 	response = 0;
 
 	if (edge_serial->is_epic) {
-		/* EPIC thing, set up our interrupt polling now and our read urb, so
-		 * that the device knows it really is connected. */
+		/* EPIC thing, set up our interrupt polling now and our read
+		 * urb, so that the device knows it really is connected. */
 		interrupt_in_found = bulk_in_found = bulk_out_found = false;
-		for (i = 0; i < serial->interface->altsetting[0].desc.bNumEndpoints; ++i) {
+		for (i = 0; i < serial->interface->altsetting[0]
+						.desc.bNumEndpoints; ++i) {
 			struct usb_endpoint_descriptor *endpoint;
 			int buffer_size;
 
-			endpoint = &serial->interface->altsetting[0].endpoint[i].desc;
+			endpoint = &serial->interface->altsetting[0].
+							endpoint[i].desc;
 			buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
 			if (!interrupt_in_found &&
 			    (usb_endpoint_is_int_in(endpoint))) {
@@ -2893,58 +3124,67 @@ static int edge_startup (struct usb_serial *serial)
 				dbg("found interrupt in");
 
 				/* not set up yet, so do it now */
-				edge_serial->interrupt_read_urb = usb_alloc_urb(0, GFP_KERNEL);
+				edge_serial->interrupt_read_urb =
+						usb_alloc_urb(0, GFP_KERNEL);
 				if (!edge_serial->interrupt_read_urb) {
 					err("out of memory");
 					return -ENOMEM;
 				}
-				edge_serial->interrupt_in_buffer = kmalloc(buffer_size, GFP_KERNEL);
+				edge_serial->interrupt_in_buffer =
+					kmalloc(buffer_size, GFP_KERNEL);
 				if (!edge_serial->interrupt_in_buffer) {
 					err("out of memory");
 					usb_free_urb(edge_serial->interrupt_read_urb);
 					return -ENOMEM;
 				}
-				edge_serial->interrupt_in_endpoint = endpoint->bEndpointAddress;
+				edge_serial->interrupt_in_endpoint =
+						endpoint->bEndpointAddress;
 
 				/* set up our interrupt urb */
-				usb_fill_int_urb(edge_serial->interrupt_read_urb,
-						 dev,
-						 usb_rcvintpipe(dev, endpoint->bEndpointAddress),
-						 edge_serial->interrupt_in_buffer,
-						 buffer_size,
-						 edge_interrupt_callback,
-						 edge_serial,
-						 endpoint->bInterval);
+				usb_fill_int_urb(
+					edge_serial->interrupt_read_urb,
+					dev,
+					usb_rcvintpipe(dev,
+						endpoint->bEndpointAddress),
+					edge_serial->interrupt_in_buffer,
+					buffer_size,
+					edge_interrupt_callback,
+					edge_serial,
+					endpoint->bInterval);
 
 				interrupt_in_found = true;
 			}
 
 			if (!bulk_in_found &&
-			    (usb_endpoint_is_bulk_in(endpoint))) {
+				(usb_endpoint_is_bulk_in(endpoint))) {
 				/* we found a bulk in endpoint */
 				dbg("found bulk in");
 
 				/* not set up yet, so do it now */
-				edge_serial->read_urb = usb_alloc_urb(0, GFP_KERNEL);
+				edge_serial->read_urb =
+						usb_alloc_urb(0, GFP_KERNEL);
 				if (!edge_serial->read_urb) {
 					err("out of memory");
 					return -ENOMEM;
 				}
-				edge_serial->bulk_in_buffer = kmalloc(buffer_size, GFP_KERNEL);
+				edge_serial->bulk_in_buffer =
+					kmalloc(buffer_size, GFP_KERNEL);
 				if (!edge_serial->bulk_in_buffer) {
-					err ("out of memory");
+					err("out of memory");
 					usb_free_urb(edge_serial->read_urb);
 					return -ENOMEM;
 				}
-				edge_serial->bulk_in_endpoint = endpoint->bEndpointAddress;
+				edge_serial->bulk_in_endpoint =
+						endpoint->bEndpointAddress;
 
 				/* set up our bulk in urb */
 				usb_fill_bulk_urb(edge_serial->read_urb, dev,
-						  usb_rcvbulkpipe(dev, endpoint->bEndpointAddress),
-						  edge_serial->bulk_in_buffer,
-						  le16_to_cpu(endpoint->wMaxPacketSize),
-						  edge_bulk_in_callback,
-						  edge_serial);
+					usb_rcvbulkpipe(dev,
+						endpoint->bEndpointAddress),
+					edge_serial->bulk_in_buffer,
+					le16_to_cpu(endpoint->wMaxPacketSize),
+					edge_bulk_in_callback,
+					edge_serial);
 				bulk_in_found = true;
 			}
 
@@ -2952,21 +3192,24 @@ static int edge_startup (struct usb_serial *serial)
 			    (usb_endpoint_is_bulk_out(endpoint))) {
 				/* we found a bulk out endpoint */
 				dbg("found bulk out");
-				edge_serial->bulk_out_endpoint = endpoint->bEndpointAddress;
+				edge_serial->bulk_out_endpoint =
+						endpoint->bEndpointAddress;
 				bulk_out_found = true;
 			}
 		}
 
 		if (!interrupt_in_found || !bulk_in_found || !bulk_out_found) {
-			err ("Error - the proper endpoints were not found!");
+			err("Error - the proper endpoints were not found!");
 			return -ENODEV;
 		}
 
 		/* start interrupt read for this edgeport this interrupt will
 		 * continue as long as the edgeport is connected */
-		response = usb_submit_urb(edge_serial->interrupt_read_urb, GFP_KERNEL);
+		response = usb_submit_urb(edge_serial->interrupt_read_urb,
+								GFP_KERNEL);
 		if (response)
-			err("%s - Error %d submitting control urb", __func__, response);
+			err("%s - Error %d submitting control urb",
+							__func__, response);
 	}
 	return response;
 }
@@ -2976,7 +3219,7 @@ static int edge_startup (struct usb_serial *serial)
  * edge_shutdown
  *	This function is called whenever the device is removed from the usb bus.
  ****************************************************************************/
-static void edge_shutdown (struct usb_serial *serial)
+static void edge_shutdown(struct usb_serial *serial)
 {
 	struct edgeport_serial *edge_serial = usb_get_serial_data(serial);
 	int i;
@@ -2984,8 +3227,8 @@ static void edge_shutdown (struct usb_serial *serial)
 	dbg("%s", __func__);
 
 	/* stop reads and writes on all ports */
-	for (i=0; i < serial->num_ports; ++i) {
-		kfree (usb_get_serial_port_data(serial->port[i]));
+	for (i = 0; i < serial->num_ports; ++i) {
+		kfree(usb_get_serial_port_data(serial->port[i]));
 		usb_set_serial_port_data(serial->port[i],  NULL);
 	}
 	/* free up our endpoint stuff */
@@ -3025,7 +3268,7 @@ static int __init edgeport_init(void)
 	if (retval)
 		goto failed_epic_device_register;
 	retval = usb_register(&io_driver);
-	if (retval) 
+	if (retval)
 		goto failed_usb_register;
 	atomic_set(&CmdUrbs, 0);
 	info(DRIVER_DESC " " DRIVER_VERSION);
@@ -3050,19 +3293,19 @@ failed_2port_device_register:
  ****************************************************************************/
 static void __exit edgeport_exit (void)
 {
-	usb_deregister (&io_driver);
-	usb_serial_deregister (&edgeport_2port_device);
-	usb_serial_deregister (&edgeport_4port_device);
-	usb_serial_deregister (&edgeport_8port_device);
-	usb_serial_deregister (&epic_device);
+	usb_deregister(&io_driver);
+	usb_serial_deregister(&edgeport_2port_device);
+	usb_serial_deregister(&edgeport_4port_device);
+	usb_serial_deregister(&edgeport_8port_device);
+	usb_serial_deregister(&epic_device);
 }
 
 module_init(edgeport_init);
 module_exit(edgeport_exit);
 
 /* Module information */
-MODULE_AUTHOR( DRIVER_AUTHOR );
-MODULE_DESCRIPTION( DRIVER_DESC );
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
 module_param(debug, bool, S_IRUGO | S_IWUSR);
diff --git a/drivers/usb/serial/io_tables.h b/drivers/usb/serial/io_tables.h
index 2ec8589..7eb9d67 100644
--- a/drivers/usb/serial/io_tables.h
+++ b/drivers/usb/serial/io_tables.h
@@ -8,7 +8,7 @@
  *	it under the terms of the GNU General Public License as published by
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
- * 
+ *
  */
 
 #ifndef IO_TABLES_H
@@ -90,10 +90,10 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(USB_VENDOR_ID_AXIOHM, AXIOHM_DEVICE_ID_EPIC_A758) },
 	{ USB_DEVICE(USB_VENDOR_ID_AXIOHM, AXIOHM_DEVICE_ID_EPIC_A794) },
 	{ USB_DEVICE(USB_VENDOR_ID_AXIOHM, AXIOHM_DEVICE_ID_EPIC_A225) },
-	{ }							/* Terminating entry */
+	{ } /* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE (usb, id_table_combined);
+MODULE_DEVICE_TABLE(usb, id_table_combined);
 
 static struct usb_driver io_driver = {
 	.name =		"io_edgeport",

