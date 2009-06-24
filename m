Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbZFXW7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbZFXW7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZFXW7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:59:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:54284 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbZFXW7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:59:12 -0400
Message-ID: <4A42AFAC.6000300@kernel.org>
Date: Wed, 24 Jun 2009 15:58:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       Larry Finger <Larry.Finger@lwfinger.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: [PATCH] x86/pci: don't use crs for root if we only have one root
 bus
References: <20090624122433.GA24781@elte.hu> <20090624145119.GA12664@elte.hu> <4A429EBB.5010209@kernel.org>
In-Reply-To: <4A429EBB.5010209@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


for AMD system, when only one PCI root, just set PCI_NO_ROOT_CRS for it

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/amd_bus.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/pci/amd_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/amd_bus.c
+++ linux-2.6/arch/x86/pci/amd_bus.c
@@ -561,6 +561,10 @@ static int __init early_fill_mp_bus_info
 		}
 	}
 
+	/* don't use _CRS if we only have one root */
+	if (pci_root_num <= 1)
+		pci_probe |= PCI_NO_ROOT_CRS;
+
 	return 0;
 }
 
