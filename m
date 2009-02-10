Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbZBJRxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbZBJRxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:53:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbZBJRxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:53:12 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:33076 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbZBJRxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:53:11 -0500
Date: Tue, 10 Feb 2009 09:53:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH] oqo: depends on INPUT_POLLDEV
Message-Id: <20090210095319.b1848fd2.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4991BEF9.0247:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

oqo driver uses polled input functions, so make it depend
on INPUT_POLLDEV.

ERROR: "input_register_polled_device" [drivers/platform/x86/oqo-wmi.ko] undefined!
ERROR: "input_allocate_polled_device" [drivers/platform/x86/oqo-wmi.ko] undefined!
ERROR: "input_free_polled_device" [drivers/platform/x86/oqo-wmi.ko] undefined!
ERROR: "input_unregister_polled_device" [drivers/platform/x86/oqo-wmi.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc:	Matthew Garrett <mjg59@srcf.ucam.org>
---
 drivers/platform/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090210.orig/drivers/platform/x86/Kconfig
+++ linux-next-20090210/drivers/platform/x86/Kconfig
@@ -137,7 +137,7 @@ config MSI_LAPTOP
 config OQO_WMI
        tristate "OQO WMI extras"
        depends on ACPI_WMI
-       depends on INPUT
+       depends on INPUT && INPUT_POLLDEV
        depends on RFKILL
        depends on BACKLIGHT_CLASS_DEVICE
        help
