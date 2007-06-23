Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbXFWDzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbXFWDzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 23:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXFWDyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 23:54:54 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:52247 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750925AbXFWDyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 23:54:53 -0400
Date: Sat, 23 Jun 2007 05:54:51 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Manoj Kasichainula <manoj@io.com>, linux-kernel@vger.kernel.org
Subject: Re: SATA RAID5 speed drop of 100 MB/s
Message-ID: <20070623035451.GA5522@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
	Manoj Kasichainula <manoj@io.com>, linux-kernel@vger.kernel.org
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <20070622214410.GB6970@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622214410.GB6970@alinoe.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For what it's worth... I tried applying

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -516,6 +516,8 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
         * reset.  Values without are used for driver operation.
         */
        hpriv->saved_cap = cap = readl(mmio + HOST_CAP);
+       hpriv->saved_cap &= ( (1<<28) | (1<<17) );
+       hpriv->saved_cap |= (1 << 27);
        hpriv->saved_port_map = port_map = readl(mmio + HOST_PORTS_IMPL);

        /* some chips lie about 64bit support */

to 2.6.22-rc5, but it had no effect :*)

I'll await any comments from a kernel developer for now.
Please let me know if you want me to test something.

-- 
Carlo Wood <carlo@alinoe.com>
