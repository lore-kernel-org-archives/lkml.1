Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab0BOHNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 02:13:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51199 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727Ab0BOHNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 02:13:37 -0500
Date: Mon, 15 Feb 2010 18:13:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michal Simek <michal.simek@petalogix.com>
Subject: linux-next: manual merge of the devicetree tree with the microblaze
 tree
Message-Id: <20100215181335.f53ad8a0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
arch/microblaze/include/asm/prom.h between commit
8d0fd5d72f5bcc597427afd73c6d5ba97fe4780f ("microblaze: Enable PCI,
missing files") from the microblaze tree and commit
df0edeb59eb559be0bee53452fda2f5cc0ae133f ("of: remove undefined
request_OF_resource & release_OF_resource") from the devicetree tree.

Just context changes. I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/microblaze/include/asm/prom.h
index 7675ce2,03f45a9..0000000
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@@ -40,32 -31,6 +31,21 @@@
  /* Other Prototypes */
  extern int early_uartlite_console(void);
  
 +#ifdef CONFIG_PCI
 +/*
 + * PCI <-> OF matching functions
 + * (XXX should these be here?)
 + */
 +struct pci_bus;
 +struct pci_dev;
 +extern int pci_device_from_OF_node(struct device_node *node,
 +					u8 *bus, u8 *devfn);
 +extern struct device_node *pci_busdev_to_OF_node(struct pci_bus *bus,
 +							int devfn);
 +extern struct device_node *pci_device_to_OF_node(struct pci_dev *dev);
 +extern void pci_create_OF_bus_map(void);
 +#endif
 +
- extern struct resource *request_OF_resource(struct device_node *node,
- 				int index, const char *name_postfix);
- extern int release_OF_resource(struct device_node *node, int index);
- 
  /*
   * OF address retreival & translation
   */
