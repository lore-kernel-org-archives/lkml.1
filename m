Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZESA4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZESA4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 20:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZESA4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 20:56:39 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:22068 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZESA4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 20:56:38 -0400
Date: Mon, 18 May 2009 17:57:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, corentincj@iksaif.net
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lenb@kernel.org
Subject: [PATCH -next] eeepc: fix kconfig selects
Message-Id: <20090518175745.da1f943f.randy.dunlap@oracle.com>
In-Reply-To: <20090518184225.d5721ac8.sfr@canb.auug.org.au>
References: <20090518184225.d5721ac8.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt005.oracle.com [141.146.116.14]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A12037C.0165:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

EEEPC_LAPTOP selects HOTPLUG_PCI.  This causes failures (build error below)
when CONFIG_HOTPLUG is not enabled, so additionally select HOTPLUG since
kconfig 'select' doesn't follow its dependency chain.
Also, only select HOTPLUG_PCI if PCI is already enabled.

drivers/pci/hotplug/fakephp.c:55: error: implicit declaration of function 'pci_rescan_bus'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/platform/x86/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20090518.orig/drivers/platform/x86/Kconfig
+++ linux-next-20090518/drivers/platform/x86/Kconfig
@@ -354,7 +354,8 @@ config EEEPC_LAPTOP
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON
 	select RFKILL
-	select HOTPLUG_PCI
+	select HOTPLUG
+	select HOTPLUG_PCI if PCI
 	---help---
 	  This driver supports the Fn-Fx keys on Eee PC laptops.
 	  It also adds the ability to switch camera/wlan on/off.
