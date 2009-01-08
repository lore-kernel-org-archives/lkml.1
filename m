Return-Path: <linux-kernel-owner+w=401wt.eu-S1762480AbZAHUGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480AbZAHUGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZAHUGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:06:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49581 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbZAHUGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:06:01 -0500
Date: Thu, 8 Jan 2009 12:05:38 -0800
From: Dirk Hohndel <hohndel@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, iommu@lists.linux-foundation.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: git-latest: kernel oops in IOMMU setup
Message-ID: <20090108120538.0176d348@infradead.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


latest git from Linus. On a Thinkpad x200s with VT-d enabled (if I
disable VT-d, this of course goes away). 

The oops happens very early during boot in device_to_iommu (called
from domain_context_mapping_one).

Looking at the code dump and the disassembled function here's where
the error happens:

static struct intel_iommu *device_to_iommu(u8 bus, u8 devfn)
{
        struct dmar_drhd_unit *drhd = NULL;
        int i;

        for_each_drhd_unit(drhd) {
                if (drhd->ignored)
                        continue;

                for (i = 0; i < drhd->devices_cnt; i++)
                        if (drhd->devices[i]->bus->number == bus &&
--> drhd->devices[0] is NULL
                            drhd->devices[i]->devfn == devfn)
                                return drhd->iommu;


Given how early this happens it's a little hard to provide logs, etc. I
literally used delay_boot=100 and wrote things down by hand (forgot my
digital camera) and then added printk's to verify).

please let me know what other data I should collect.

The system ran fine with the 2.6.28 release kernel.

/D

-- 
Dirk Hohndel
Intel Open Source Technology Center
