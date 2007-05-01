Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbXEAQGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbXEAQGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbXEAQGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:06:38 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36545 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbXEAQGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:06:37 -0400
Date: Tue, 1 May 2007 09:10:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Thomas Backlund <tmb@mandriva.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] Add support for picopower irq router
Message-Id: <20070501091007.fd649833.randy.dunlap@oracle.com>
In-Reply-To: <46370B06.4030600@mandriva.org>
References: <46370B06.4030600@mandriva.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2007 12:40:22 +0300 Thomas Backlund wrote:

> arg, attachment.  :(

[parts of patch copy/pasted here for comments]


+static int pirq_pico_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
+{
+	outb(0x10+((pirq-1)>>1), 0x24);
+	return ((pirq-1)&1) ? (inb(0x26)>>4) : (inb(0x26)&0xf);
+}

Be more liberal with the spacebar.  It helps readability.  Like so:
(and see Documentation/CodingStyle)

+	outb(0x10 + ((pirq - 1) >> 1), 0x24);
+	return ((pirq -1 ) & 1) ? (inb(0x26) >> 4) : (inb(0x26) & 0xf);


Same for following functions.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

+static int pirq_pico_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+{
+	outb(0x10+((pirq-1)>>1), 0x24);
+	unsigned int x;
+	x = inb(0x26);

Data declarations must come before code.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

+static __init int pico_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
+{
+	switch(device)

space after "switch".

+	{
+	        case PCI_DEVICE_ID_PICOPOWER_PT86C523:

Don't indent cases.  Put at same column as {.

BTW, this is all in CodingStyle.



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
