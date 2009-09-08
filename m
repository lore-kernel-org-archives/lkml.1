Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZIHAIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZIHAIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 20:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZIHAIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 20:08:49 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:51420 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbZIHAIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 20:08:49 -0400
Date: Mon, 7 Sep 2009 17:08:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Stephen Rothwell . David Brownell <dbrownell@users.sourceforge.net>" 
	<sfr@canb.auug.org.au>,
       gregkh <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: [PATCH -next] usb gadget: ether needs to select CRC32
Message-Id: <20090907170839.50ddeef7.randy.dunlap@oracle.com>
In-Reply-To: <20090907210206.7830ba68.sfr@canb.auug.org.au>
References: <20090907210206.7830ba68.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4AA5A08A.0065:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error, ether uses/needs to select CRC32 config symbol:

ether.c:(.text+0x271480): undefined reference to `crc32_le'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/gadget/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090907.orig/drivers/usb/gadget/Kconfig
+++ linux-next-20090907/drivers/usb/gadget/Kconfig
@@ -627,6 +627,7 @@ config USB_AUDIO
 config USB_ETH
 	tristate "Ethernet Gadget (with CDC Ethernet support)"
 	depends on NET
+	select CRC32
 	help
 	  This driver implements Ethernet style communication, in one of
 	  several ways:




---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
