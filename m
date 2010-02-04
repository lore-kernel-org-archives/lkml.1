Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab0BDRfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:35:22 -0500
Received: from kroah.org ([198.145.64.141]:34628 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758519Ab0BDRVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:21:38 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:14:57 2010
Message-Id: <20100204171455.992389734@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:11:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhao Yakui <yakui.zhao@intel.com>, Len Brown <len.brown@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [15/74] ACPI: Advertise to BIOS in _OSC: _OST on _PPC changes
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit 6a4e2b7503d1f630bface040cf0f5a7aac1fabdb upstream.

If the BIOS pokes the system-wide OSC bits to see if Linux
supports evaluating _OST after a _PPC change notification,
answer yes.

Also, fix an oversight where we neglected to set the OSC
bit advertising processor aggregator device support
when acpi-pad is compiled as a module.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/bus.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -490,9 +490,14 @@ static void acpi_bus_osc_support(void)
 
 	capbuf[OSC_QUERY_TYPE] = OSC_QUERY_ENABLE;
 	capbuf[OSC_SUPPORT_TYPE] = OSC_SB_PR3_SUPPORT; /* _PR3 is in use */
-#ifdef CONFIG_ACPI_PROCESSOR_AGGREGATOR
+#if defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR) ||\
+			defined(CONFIG_ACPI_PROCESSOR_AGGREGATOR_MODULE)
 	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_PAD_SUPPORT;
 #endif
+
+#if defined(CONFIG_ACPI_PROCESSOR) || defined(CONFIG_ACPI_PROCESSOR_MODULE)
+	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_PPC_OST_SUPPORT;
+#endif
 	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))
 		return;
 	if (ACPI_SUCCESS(acpi_run_osc(handle, &context)))


