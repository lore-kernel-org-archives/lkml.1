Return-Path: <linux-kernel-owner+w=401wt.eu-S1762184AbYCCKMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762184AbYCCKMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbYCCKMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:12:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbYCCKMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:12:08 -0500
Date: Mon, 3 Mar 2008 11:11:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Zhao Yakui <yakui.zhao@intel.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: Unneccessary to scan the PCI bus already scanned.
Message-ID: <20080303101151.GH18281@elte.hu>
References: <1204525186.4080.11.camel@yakui_zhao.sh.intel.com> <20080303073214.GA5934@elte.hu> <86802c440803030006m1879838awc238f07bc98ed43e@mail.gmail.com> <86802c440803030030p4ff9cec5tdb25d1cdc131d377@mail.gmail.com> <86802c440803030201i684f31c1m97fb3f1f1927d4f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803030201i684f31c1m97fb3f1f1927d4f4@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i also had to hand-merge the x86.git#testing patch below - could you 
double-check that it's needed in this form?

	Ingo

----------->
Subject: x86/acpi: make dev_to_node return online node
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Date: Wed, 20 Feb 2008 12:41:52 -0800

some numa system (with multi HT chains) may return node without ram. aka it
is not online. Try to get an online node, otherwise return -1

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/pci/acpi.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-x86.q/arch/x86/pci/acpi.c
===================================================================
--- linux-x86.q.orig/arch/x86/pci/acpi.c
+++ linux-x86.q/arch/x86/pci/acpi.c
@@ -213,6 +213,9 @@ struct pci_bus * __devinit pci_acpi_scan
 		set_mp_bus_to_node(busnum, node);
 	else
 		node = get_mp_bus_to_node(busnum);
+
+	if (node != -1 && !node_online(node))
+		node = -1;
 #endif
 
 	bus = pci_find_bus(domain, busnum);

