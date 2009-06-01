Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZFAPj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZFAPj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 11:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbZFAPjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 11:39:51 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:55962 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbZFAPju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 11:39:50 -0400
Message-ID: <4A23F6B5.6010000@oracle.com>
Date: Mon, 01 Jun 2009 08:41:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>, Len Brown <lenb@kernel.org>
Subject: [PATCH] eeepc: fix kconfig problem
References: <20090601200510.7b5334ab.sfr@canb.auug.org.au>
In-Reply-To: <20090601200510.7b5334ab.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4A23F5FD.0127:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090529:


Resend.  linux-next still needs this patch.

Len, what mailing list(s) should drivers/platform/x86/ patches
be sent to?


---
From: Randy Dunlap <randy.dunlap@oracle.com>

EEEPC_LAPTOP selects HOTPLUG_PCI.  This causes failures (build error below)
when CONFIG_HOTPLUG is not enabled, so additionally select HOTPLUG since
kconfig 'select' doesn't follow its dependency chain.
Also, only select HOTPLUG_PCI if PCI is already enabled.

drivers/pci/hotplug/fakephp.c:55: error: implicit declaration of function 'pci_rescan_bus'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Corentin Chary <corentincj@iksaif.net>
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
