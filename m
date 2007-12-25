Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbXLYRv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbXLYRv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 12:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbXLYRvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 12:51:50 -0500
Received: from mailout02.sul.t-online.de ([194.25.134.17]:60248 "EHLO
	mailout02.aul.t-online.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750744AbXLYRvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 12:51:49 -0500
X-Greylist: delayed 1164 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Dec 2007 12:51:49 EST
Message-ID: <47713E98.6010809@t-online.de>
Date: Tue, 25 Dec 2007 18:32:08 +0100
From: Peter Stark <Peter.Stark@t-online.de>
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net
Subject: [PATCH] USB serial ftdi_sio - enabling multiple ELV devices, adding
 EM1010PC
References: <476F79A7.9020204@t-online.de> <20071225040836.GA3299@suse.de>
In-Reply-To: <20071225040836.GA3299@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: Th9IweZe8hVN1-r-nBNSYNmEaAepvZ3touIv0xHRI33P6BKdeftWbu84Fz4ITaVwLe
X-TOI-MSGID: 043a836e-26cf-4502-954b-621f92ef59aa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I work with a group of people on a free home automation tool called FHEM. 
Some of the users own more than one USB-serial device by ELV. The ftdi_sio 
driver has most of the ELV devices disabled by default and needs to be 
re-enabled every time you get a new kernel. Additionally a new device (EM 
1010 PC - enegry monitor) is missing in the list.
Currently our users have to follow the instructions we provide at 
http://www.koeniglich.de/fhem/linux.html
... However, to some users it is too complicated to compile their own kernel 
module.

We are aware that you can specify one additional device using the 
vendor/product option of the module. But lot's of users own more than one 
device.

Signed-off-by: Peter Stark <peter.stark@t-online.de>

---
diff -uprN -X linux-2.6.23.12-vanilla/Documentation/dontdiff 
linux-2.6.23.12-vanilla/drivers/usb/serial/ftdi_sio.c 
linux-2.6.23.12/drivers/usb/serial/ftdi_sio.c
--- linux-2.6.23.12-vanilla/drivers/usb/serial/ftdi_sio.c       
2007-12-18 22:55:57.000000000 +0100
+++ linux-2.6.23.12/drivers/usb/serial/ftdi_sio.c       2007-12-25 
17:41:20.000000000 +0100
@@ -17,6 +17,9 @@
  * See http://ftdi-usb-sio.sourceforge.net for upto date testing info
  *     and extra documentation
  *
+ * (25/Dec/2007) Peter Stark
+ *      Made ELV devices included by default. Added EM1010PC.
+ *
  * (21/Jul/2004) Ian Abbott
  *      Incorporated Steven Turner's code to add support for the 
FT2232C chip.
  *      The prelimilary port to the 2.6 kernel was by Rus V. 
Brushkoff.  I have
@@ -471,30 +474,29 @@ static struct usb_device_id id_table_com
        { USB_DEVICE(FTDI_VID, FTDI_IBS_PEDO_PID) },
        { USB_DEVICE(FTDI_VID, FTDI_IBS_PROD_PID) },
        /*
-        * These will probably use user-space drivers.  Uncomment them if
-        * you need them or use the user-specified vendor/product module
-        * parameters (see ftdi_sio.h for the numbers).  Make a fuss if
-        * you think the driver should recognize any of them by default.
+        * Due to many user requests for multiple ELV devices we enable
+        * them by default.
         */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_CLI7000_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_PPS7330_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_TFM100_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_UDF77_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_UIO88_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_UAD8_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_UDA7_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_USI2_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_T1100_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_PCD200_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_ULA200_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_CSI8_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_EM1000DL_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_PCK100_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_RFP500_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_FS20SIG_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_WS300PC_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_FHZ1300PC_PID) }, */
-       /* { USB_DEVICE(FTDI_VID, FTDI_ELV_WS500_PID) }, */
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_CLI7000_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_PPS7330_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_TFM100_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_UDF77_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_UIO88_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_UAD8_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_UDA7_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_USI2_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_T1100_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_PCD200_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_ULA200_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_CSI8_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_EM1000DL_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_PCK100_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_RFP500_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_FS20SIG_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_WS300PC_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_FHZ1300PC_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_WS500_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_ELV_EM1010PC_PID) },
        { USB_DEVICE(FTDI_VID, LINX_SDMUSBQSS_PID) },
        { USB_DEVICE(FTDI_VID, LINX_MASTERDEVEL2_PID) },
        { USB_DEVICE(FTDI_VID, LINX_FUTURE_0_PID) },
diff -uprN -X linux-2.6.23.12-vanilla/Documentation/dontdiff 
linux-2.6.23.12-vanilla/drivers/usb/serial/ftdi_sio.h 
linux-2.6.23.12/drivers/usb/serial/ftdi_sio.h
--- linux-2.6.23.12-vanilla/drivers/usb/serial/ftdi_sio.h       
2007-12-18 22:55:57.000000000 +0100
+++ linux-2.6.23.12/drivers/usb/serial/ftdi_sio.h       2007-12-25 
17:39:57.000000000 +0100
@@ -245,6 +245,7 @@
 #define FTDI_ELV_WS300PC_PID   0xE0F6  /* PC-Wetterstation (WS 300 PC) */
 #define FTDI_ELV_FHZ1300PC_PID 0xE0E8  /* FHZ 1300 PC */
 #define FTDI_ELV_WS500_PID     0xE0E9  /* PC-Wetterstation (WS 500) */
+#define FTDI_ELV_EM1010PC_PID 0xE0EF /* Engery monitor EM 1010 PC */

 /*
  * Definitions for ID TECH (www.idt-net.com) devices
...
regards,
Peter
