Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbZCSNd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbZCSNd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZCSNdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:33:20 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:39311 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZCSNdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:33:19 -0400
Date: Thu, 19 Mar 2009 15:33:14 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Lava dual parallel PCI card IRQ problem
In-Reply-To: <20090319131002.4040b4dd@lxorguk.ukuu.org.uk>
Message-ID: <Pine.SOC.4.64.0903191525001.26750@math.ut.ee>
References: <20090318143921.22B5B13A4B0@koiott.tartu-labor>
 <Pine.LNX.4.64.0903191500520.4721@ondatra.tartu-labor>
 <20090319131002.4040b4dd@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You may need to stick a few printks in the port registration path to see
> why it made that decision.

Got it - it's a simple copypaste mistake:

+               irq = dev->irq;
+               if (irq == IRQ_NONE) {
+                       printk (KERN_DEBUG
+       "PCI parallel port detected: %04x:%04x, I/O at %#lx(%#lx)\n",
+                               parport_pc_pci_tbl[i + last_sio].vendor,
+                               parport_pc_pci_tbl[i + last_sio].device,
+                               io_lo, io_hi);
+                       irq = PARPORT_IRQ_NONE;
+               } else {
+                       printk (KERN_DEBUG
+       "PCI parallel port detected: %04x:%04x, I/O at %#lx(%#lx), IRQ %d\n",
+                               parport_pc_pci_tbl[i + last_sio].vendor,
+                               parport_pc_pci_tbl[i + last_sio].device,
+                               io_lo, io_hi, irq);
+                       irq = PARPORT_IRQ_NONE;
+               }

If I remove the second "irq = PARPORT_IRQ_NONE;" it starts to load fine. 
Will test later with a rela printer attached.

-- 
Meelis Roos (mroos@linux.ee)
