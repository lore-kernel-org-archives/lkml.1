Return-Path: <linux-kernel-owner+w=401wt.eu-S1761844AbZJIXT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844AbZJIXT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761802AbZJIXT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:19:27 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:23066 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761724AbZJIXT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:19:26 -0400
Date: Fri, 9 Oct 2009 16:17:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, lenb@kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Borislav Deianov <borislav@users.sf.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH -next] thinkpad_acpi: fix build, HOTKEY_POLL is optional
Message-Id: <20091009161723.b68b91a7.randy.dunlap@oracle.com>
In-Reply-To: <20091009190654.741eeffd.sfr@canb.auug.org.au>
References: <20091009190654.741eeffd.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4ACFC487.00E0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix optional part of driver to be built optionally:

drivers/platform/x86/thinkpad_acpi.c:6251: error: implicit declaration of function 'tpacpi_hotkey_driver_mask_set'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/platform/x86/thinkpad_acpi.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20091009.orig/drivers/platform/x86/thinkpad_acpi.c
+++ linux-next-20091009/drivers/platform/x86/thinkpad_acpi.c
@@ -6245,12 +6245,14 @@ static int __init brightness_init(struct
 	ibm_backlight_device->props.brightness = b & TP_EC_BACKLIGHT_LVLMSK;
 	backlight_update_status(ibm_backlight_device);
 
+#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
 	vdbg_printk(TPACPI_DBG_INIT | TPACPI_DBG_BRGHT,
 			"brightness: registering brightness hotkeys "
 			"as change notification\n");
 	tpacpi_hotkey_driver_mask_set(hotkey_driver_mask
 				| TP_ACPI_HKEY_BRGHTUP_MASK
 				| TP_ACPI_HKEY_BRGHTDWN_MASK);;
+#endif
 	return 0;
 }
 
