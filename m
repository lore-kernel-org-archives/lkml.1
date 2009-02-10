Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbZBJR02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbZBJR02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684AbZBJR0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:26:08 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:47584 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbZBJR0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:26:07 -0500
Date: Tue, 10 Feb 2009 09:25:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH] dell-laptop: depends on POWER_SUPPLY
Message-Id: <20090210092526.c0e376bd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4991B87E.00C7:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Build breaks when DELL_LAPTOP=y and POWER_SUPPLY=m. DELL_LAPTOP needs
to depend on POWER_SUPPLY.

dell-laptop.c:(.text+0x1ef3c4): undefined reference to `power_supply_is_system_supplied'
dell-laptop.c:(.text+0x1ef45e): undefined reference to `power_supply_is_system_supplied'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Matthew Garrett <mjg59@srcf.ucam.org>
---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090210.orig/drivers/platform/x86/Kconfig
+++ linux-next-20090210/drivers/platform/x86/Kconfig
@@ -62,6 +62,7 @@ config DELL_LAPTOP
 	depends on EXPERIMENTAL
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL
+	depends on POWER_SUPPLY
 	default n
 	---help---
 	This driver adds support for rfkill and backlight control to Dell
