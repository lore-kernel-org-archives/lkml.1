Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbZLRUKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbZLRUKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbZLRUKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:10:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:55322 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932568AbZLRUKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:10:37 -0500
Message-ID: <4B2BE17C.2030105@kernel.org>
Date: Fri, 18 Dec 2009 12:09:32 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 1/7] x86/pci: intel ioh bus num reg accessing fix
References: <4B2BE063.4040704@kernel.org>
In-Reply-To: <4B2BE063.4040704@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



it is above 0x100, so if mmconf is not enable, need to skip it

Reported-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/intel_bus.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/pci/intel_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/intel_bus.c
+++ linux-2.6/arch/x86/pci/intel_bus.c
@@ -49,6 +49,10 @@ static void __devinit pci_root_bus_res(s
 	u64 mmioh_base, mmioh_end;
 	int bus_base, bus_end;
 
+	/* some sys doesn't get mmconf enabled */
+	if (dev->cfg_size < 0x200)
+		return;
+
 	if (pci_root_num >= PCI_ROOT_NR) {
 		printk(KERN_DEBUG "intel_bus.c: PCI_ROOT_NR is too small\n");
 		return;

