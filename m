Return-Path: <linux-kernel-owner+w=401wt.eu-S1752108AbZHSNp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbZHSNp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZHSNp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:45:27 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:15697 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751590AbZHSNp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:45:26 -0400
Date: Wed, 19 Aug 2009 15:45:20 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
Cc: Dhaval Vasa <dhaval.vasa@einfochips.com>, nico@cam.org,
       linux-kernel@vger.kernel.org, rabeeh@marvell.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH v2] [ARM] Kirkwood: Marvell OpenRD-Base board support
 added to v2.6.31-rc5
Message-ID: <20090819154520.61e33fc1@marrow.netinsight.se>
In-Reply-To: <20090819151814.7167bad0@marrow.netinsight.se>
References: <1249906054-572-1-git-send-email-dhaval.vasa@einfochips.com>
	<20090819151814.7167bad0@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 15:18:14 +0200
Simon Kagstrom <simon.kagstrom@netinsight.net> wrote:

> In my patch, I also called kirkwood_i2c_init (see below), which at
> least make the I2C bus appear (not that I've tested it very much).

And also from my patch, I added initialization of PCIe as well (taken
from rd88f6281-setup.c). So you could perhaps also add that to your
patch as well?

If needed:

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>

// Simon

diff --git a/arch/arm/mach-kirkwood/openrd_base-setup.c b/arch/arm/mach-kirkwood/openrd_base-setup.c
index f9a2166..30f84b1 100644
--- a/arch/arm/mach-kirkwood/openrd_base-setup.c
+++ b/arch/arm/mach-kirkwood/openrd_base-setup.c
@@ -71,7 +71,18 @@ static void __init openrd_base_init(void)
        kirkwood_ge00_init(&openrd_base_ge00_data);
        kirkwood_sata_init(&openrd_base_sata_data);
        kirkwood_sdio_init(&openrd_base_mvsdio_data);
+
+       kirkwood_i2c_init();
+}
+
+static int __init openrd_base_pci_init(void)
+{
+       if (machine_is_openrd_base())
+               kirkwood_pcie_init();
+
+       return 0;
 }
+subsys_initcall(openrd_base_pci_init);
 
 MACHINE_START(OPENRD_BASE, "Marvell OpenRD Base Board")
        /* Maintainer: Dhaval Vasa <dhaval.vasa@einfochips.com> */
