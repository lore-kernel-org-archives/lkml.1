Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbZFYJFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbZFYJFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbZFYJFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:05:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59812
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbZFYJFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:05:02 -0400
Date: Thu, 25 Jun 2009 02:05:07 -0700 (PDT)
Message-Id: <20090625.020507.203808859.davem@davemloft.net>
To: tj@kernel.org
Cc: greg@kroah.com, hancockr@shaw.ca, alan@lxorguk.ukuu.org.uk,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       daniel.ritz@gmx.ch, linux@dominikbrodowski.net,
       kaneshige.kenji@jp.fujitsu.com, towerlexa@gmx.de,
       benh@kernel.crashing.org, mingo@elte.hu, tglx@linutronix.de,
       tony.luck@intel.com
Subject: Re: [RFC PATCH 1/2] pci: determine CLS more intelligently
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A43234D.9050608@kernel.org>
References: <4A43234D.9050608@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Thu, 25 Jun 2009 16:12:13 +0900

> sparc64 is currently the only one using PCI_CACHE_LINE_BYTES.

Feel free to add the patch below and:

Acked-by: David S. Miller <davem@davemloft.net>

Although I think it's better to declare pci_dfl_cache_line_size in
linux/pci.h instead of making every arch do the extern decl.

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index 57859ad..511a592 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -1081,3 +1081,12 @@ void pci_resource_to_user(const struct pci_dev *pdev, int bar,
 	*start = rp->start - offset;
 	*end = rp->end - offset;
 }
+
+extern u8 pci_dfl_cache_line_size;
+
+static int __init pcibios_init(void)
+{
+	pci_dfl_cache_line_size = 64 >> 2;
+	return 0;
+}
+subsys_initcall(pcibios_init);
