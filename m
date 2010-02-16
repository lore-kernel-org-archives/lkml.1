Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab0BPBBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 20:01:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33298 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab0BPBBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 20:01:07 -0500
Date: Tue, 16 Feb 2010 12:01:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
       Gertjan van Wingerde <gwingerde@gmail.com>
Subject: linux-next: manual merge of the wireless tree with the net tree
Message-Id: <20100216120103.7128b0f4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/net/wireless/rt2x00/rt2800pci.c between commit
a3aa18842a5303fc28fcc4d57dbd16618bd830a0 ("drivers/net/: use
DEFINE_PCI_DEVICE_TABLE()") from the net tree and commit
de1ebdceb6a4fe1b7073b81d273285b7c8bed312 ("rt2x00: rt2800 - Make rt30xx
and rt35xx chipsets configurable") from the wireless tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/rt2x00/rt2800pci.c
index d64181c,0e4c417..0000000
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@@ -1190,8 -1184,11 +1184,11 @@@ static const struct rt2x00_ops rt2800pc
  /*
   * RT2800pci module information.
   */
 -static struct pci_device_id rt2800pci_device_table[] = {
 +static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
- 	{ PCI_DEVICE(0x1462, 0x891a), PCI_DEVICE_DATA(&rt2800pci_ops) },
+ 	{ PCI_DEVICE(0x1814, 0x0601), PCI_DEVICE_DATA(&rt2800pci_ops) },
+ 	{ PCI_DEVICE(0x1814, 0x0681), PCI_DEVICE_DATA(&rt2800pci_ops) },
+ 	{ PCI_DEVICE(0x1814, 0x0701), PCI_DEVICE_DATA(&rt2800pci_ops) },
+ 	{ PCI_DEVICE(0x1814, 0x0781), PCI_DEVICE_DATA(&rt2800pci_ops) },
  	{ PCI_DEVICE(0x1432, 0x7708), PCI_DEVICE_DATA(&rt2800pci_ops) },
  	{ PCI_DEVICE(0x1432, 0x7727), PCI_DEVICE_DATA(&rt2800pci_ops) },
  	{ PCI_DEVICE(0x1432, 0x7728), PCI_DEVICE_DATA(&rt2800pci_ops) },
