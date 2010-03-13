Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934878Ab0CMAT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:19:56 -0500
Received: from kroah.org ([198.145.64.141]:60520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934729Ab0CMATd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:33 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:05 2010
Message-Id: <20100313001505.506290918@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 004/123] PCI hotplug: check ioremap() return value in ibmphp_ebda.c
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Andrew Morton <akpm@linux-foundation.org>

commit ba02b242bbf8e4e1bc63d62e8ccec33b4e5ea132 upstream.

check ioremap() return value.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/hotplug/ibmphp_ebda.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -261,6 +261,8 @@ int __init ibmphp_access_ebda (void)
 	debug ("returned ebda segment: %x\n", ebda_seg);
 	
 	io_mem = ioremap(ebda_seg<<4, 1);
+	if (!io_mem)
+		return -ENOMEM;
 	ebda_sz = readb(io_mem);
 	iounmap(io_mem);
 	debug("ebda size: %d(KiB)\n", ebda_sz);


