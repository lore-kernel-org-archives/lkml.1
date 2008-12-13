Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYLMLnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYLMLnQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 06:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYLMLnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 06:43:03 -0500
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:44358
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752343AbYLMLnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 06:43:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhUBANAuQ0l8qszs/2dsb2JhbAAIxByGNoUggn0
X-IronPort-AV: E=Sophos;i="4.36,216,1228057200"; 
   d="scan'208";a="363830807"
Message-ID: <49439FBD.20504@uts.edu.au>
Date: Sat, 13 Dec 2008 22:42:53 +1100
From: Matthew Arnold <Matthew.Arnold-1@uts.edu.au>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: greg@kroah.com
CC: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Re: [Bug 12212] add 5372:2303 to /drivers/usb/serial/pl2303
References: <20081213085654.5CBFB108040@picon.linux-foundation.org>
In-Reply-To: <20081213085654.5CBFB108040@picon.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12212
>
>
>
>
>
> ------- Comment #1 from greg@kroah.com  2008-12-13 00:56 -------
> On Sat, Dec 13, 2008 at 12:29:04AM -0800, bugme-daemon@bugzilla.kernel.org
> wrote:
>   
>> Problem: an unbranded USB-serial converter is not detected
>> Steps taken to resolve the problem: 
>> (unsuccessful) force usb-serial detection by adding (Debian?) udev rules -
>> detects device but incorrectly defaults to generic which doesn't work
>> (successful) added vendor:product to pl2303 / recompile / insert module
>>     
>
> Can you send me the patch that you made, in the format described in
> Documentation/SubmittingPatches, through email, and I will be able to
> apply it and give you the proper credit.
>
>
>   
ok, I'm not at all familiar with kernel development but here's my 
contribution.
I got the idea from:
http://www.linuxquestions.org/questions/linux-hardware-18/obscure-usb-serial-adapter-368278/

This patch adds the "Superial" USB-Serial converter to pl2303 so that it 
is detected, by the correct driver.
Adds the relevant vendor:product (5372:2303) to the device tables in 
pl2303.c & pl2303.h.
The patch has been tested against 2.6.24-22-generic.

Signed-off-by: Matthew D Arnold <matthew.arnold-1[AT]uts.edu[DOT]au>


------------------------------------------------------------------------------------------
diff -uprN -X ./linux-source-2.6.24-vanilla/Documentation/dontdiff 
./linux-sourc
e-2.6.24-vanilla/drivers/usb/serial/pl2303.c 
./linux-source-2.6.24-patched/drive
rs/usb/serial/pl2303.c
--- ./linux-source-2.6.24-vanilla/drivers/usb/serial/pl2303.c    
2008-11-25 04:46
:05.000000000 +1100
+++ ./linux-source-2.6.24-patched/drivers/usb/serial/pl2303.c    
2008-12-13 21:52
:36.000000000 +1100
@@ -90,6 +90,7 @@ static struct usb_device_id id_table []
     { USB_DEVICE(HL340_VENDOR_ID, HL340_PRODUCT_ID) },
     { USB_DEVICE(YCCABLE_VENDOR_ID, YCCABLE_PRODUCT_ID) },
     { USB_DEVICE(SANWA_VENDOR_ID, SANWA_PRODUCT_ID) },
+    { USB_DEVICE(SUPERIAL_VENDOR_ID, SUPERIAL_PRODUCT_ID) },
     { }                    /* Terminating entry */
 };
 
diff -uprN -X ./linux-source-2.6.24-vanilla/Documentation/dontdiff 
./linux-sourc
e-2.6.24-vanilla/drivers/usb/serial/pl2303.h 
./linux-source-2.6.24-patched/drive
rs/usb/serial/pl2303.h
--- ./linux-source-2.6.24-vanilla/drivers/usb/serial/pl2303.h    
2008-11-25 04:46
:05.000000000 +1100
+++ ./linux-source-2.6.24-patched/drivers/usb/serial/pl2303.h    
2008-12-13 21:52
:09.000000000 +1100
@@ -116,3 +116,8 @@
 /* Sanwa KB-USB2 multimeter cable (ID: 11ad:0001) */
 #define SANWA_VENDOR_ID        0x11ad
 #define SANWA_PRODUCT_ID    0x0001
+
+/* "Superial" USB - Serial */
+#define SUPERIAL_VENDOR_ID    0x5372
+#define SUPERIAL_PRODUCT_ID    0x2303
+

