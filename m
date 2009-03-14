Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbZCNAhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbZCNAhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbZCNAT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:26 -0400
Received: from kroah.org ([198.145.64.141]:34741 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752777AbZCNATO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:47 2009
Message-Id: <20090314000747.199528565@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:02 -0700
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
Subject: [patch 54/96] PCIe: portdrv: call pci_disable_device during remove
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=pcie-portdrv-call-pci_disable_device-during-remove.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -115,6 +115,7 @@ static int __devinit pcie_portdrv_probe 
 static void pcie_portdrv_remove (struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
+	pci_disable_device(dev);
 	kfree(pci_get_drvdata(dev));
 }
 


