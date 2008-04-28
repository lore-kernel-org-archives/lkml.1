Return-Path: <linux-kernel-owner+w=401wt.eu-S965510AbYD1Qdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965510AbYD1Qdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933680AbYD1Qdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:33:32 -0400
Received: from web52007.mail.re2.yahoo.com ([206.190.48.56]:43091 "HELO
	web52007.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S964889AbYD1Qda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:33:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=bhT4/fvORdYioHcf6gQsnW+ALA7127pwwBf4v8gmIKna7R5B8L2r9uYYyL4oDfeZB3OCXw83gHxXSR8VVa/EMI3ja4RAPoP6H2aJmSmXa+HTv6IkIVAQthfBgDqy7k4kFMvOYWWgMqcjPiItf0ljIGD5tLbiljpzxfh6wuJHSI0=;
X-YMail-OSG: 5.ywu7EVM1myQh2db2G1sQiN2Ozk3M8ZtaBC0SfqYk8F5mK5IilJVpV3Q2kLx9dKUACjcME8vImekVhqq7MY0lx3r5FtnSSONQGZRaLgHgK_wLnmsGTrIWLzPw--
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Mon, 28 Apr 2008 09:33:27 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [patch] doc: fix an incorrect suggestion to pass NULL for PCI like buses
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       willy@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <392740.53131.qm@web52007.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Fix an incorrect suggestion to pass NULL to pci_alloc_consistent
for PCI like buses where devices don't have struct pci_dev (like ISA, EISA).

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

---

This patch is to be applied on top of
[patch v3] doc: DMA-mapping.txt has undeclared variables [Bug 10397]

--- linux-2.6/Documentation/DMA-mapping.txt    2008-04-28 19:09:36.124693500 +0300
+++ linux/Documentation/DMA-mapping.txt    2008-04-28 19:17:07.711024500 +0300
@@ -317,9 +317,9 @@ you should do:
 
     cpu_addr = pci_alloc_consistent(pdev, size, &dma_handle);
 
-where pdev is a struct pci_dev *. You should pass NULL for PCI like buses
-where devices don't have struct pci_dev (like ISA, EISA).  This may be
-called in interrupt context. 
+where pdev is a struct pci_dev *. This may be called in interrupt context.
+You should use dma_alloc_coherent (see DMA-API.txt) for buses
+where devices don't have struct pci_dev (like ISA, EISA).
 
 This argument is needed because the DMA translations may be bus
 specific (and often is private to the bus which the device is attached


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
