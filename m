Return-Path: <linux-kernel-owner+w=401wt.eu-S1763049AbZCNBj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763049AbZCNBj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZCNBU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:56 -0400
Received: from kroah.org ([198.145.64.141]:35300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753877AbZCNBUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:39 2009
Message-Id: <20090314011039.403536326@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alex Chiang <achiang@hp.com>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: [patch 054/114] PCIe: portdrv: call pci_disable_device during remove
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=pcie-portdrv-call-pci_disable_device-during-remove.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Chiang <achiang@hp.com>

commit d89987193631bf23d1735c55d13a06d4b8d0e9bd upstream.

The PCIe port driver calls pci_enable_device() during probe but
never calls pci_disable_device() during remove.

Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pcie/portdrv_pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -109,6 +109,7 @@ static int __devinit pcie_portdrv_probe 
 static void pcie_portdrv_remove (struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
+	pci_disable_device(dev);
 	kfree(pci_get_drvdata(dev));
 }
 


