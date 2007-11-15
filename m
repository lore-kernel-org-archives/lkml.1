Return-Path: <linux-kernel-owner+w=401wt.eu-S1762822AbXKOGSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762822AbXKOGSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761978AbXKOGQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51011 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761638AbXKOGQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:19 -0500
Date: Wed, 14 Nov 2007 22:14:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Ellerman <michael@ellerman.id.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: [patch 06/19] POWERPC: Make sure to of_node_get() the result of
	pci_device_to_OF_node()
Message-ID: <20071115061441.GG7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-make-sure-to-of_node_get-the-result-of-pci_device_to_of_node.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Ellerman <michael@ellerman.id.au>

patch db220b234da9f183b127b9c3077c253b94756e35 in mainline.

pci_device_to_OF_node() returns the device node attached to a PCI device,
but doesn't actually grab a reference - we need to do it ourselves.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/cell/axon_msi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -126,7 +126,7 @@ static struct axon_msic *find_msi_transl
 	const phandle *ph;
 	struct axon_msic *msic = NULL;
 
-	dn = pci_device_to_OF_node(dev);
+	dn = of_node_get(pci_device_to_OF_node(dev));
 	if (!dn) {
 		dev_dbg(&dev->dev, "axon_msi: no pci_dn found\n");
 		return NULL;
@@ -183,7 +183,7 @@ static int setup_msi_msg_address(struct 
 	int len;
 	const u32 *prop;
 
-	dn = pci_device_to_OF_node(dev);
+	dn = of_node_get(pci_device_to_OF_node(dev));
 	if (!dn) {
 		dev_dbg(&dev->dev, "axon_msi: no pci_dn found\n");
 		return -ENODEV;

-- 
