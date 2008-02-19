Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbYBST3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbYBST3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYBST3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:29:39 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:36929 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbYBST3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:29:38 -0500
Date: Tue, 19 Feb 2008 21:29:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Patterson <andrew.patterson@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: pci/pcie/aer/aerdrv_acpi.c: inconsequent NULL checking
Message-ID: <20080219192902.GD31955@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following inconsequent NULL checking 
introduced by commit 3c75e23784e6ed5f4841de43d0750fd9b37bafcb:

<--  snip  -->

...
int aer_osc_setup(struct pcie_device *pciedev)
{
...            vvvvvvvvv
        while (pdev->bus && pdev->bus->self)
                pdev = pdev->bus->self;
        handle = acpi_get_pci_rootbridge_handle(
                pci_domain_nr(pdev->bus), pdev->bus->number);
...                                       ^^^^^^^^^^^^^^^^^

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

