Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYAQTgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYAQTgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYAQTg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:36:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751542AbYAQTg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:36:27 -0500
Date: Thu, 17 Jan 2008 11:35:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, raisch@de.ibm.com,
       jgarzik@pobox.com, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.24-rc8-mm1 powerpc build errors
Message-Id: <20080117113523.d802f991.akpm@linux-foundation.org>
In-Reply-To: <20080117190639.GA9499@lixom.net>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<20080117190639.GA9499@lixom.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 13:06:39 -0600 Olof Johansson <olof@lixom.net> wrote:

> Hi,
> 
> My powerpc build-all-defconfigs script found the following:

thanks.

> mpc837x_mds_defconfig. Brokage looks like it came from libata's
> for_each_sg() patch.
> 
> drivers/ata/sata_fsl.c: In function 'sata_fsl_fill_sg':
> drivers/ata/sata_fsl.c:337: error: redeclaration of 'si' with no linkage
> drivers/ata/sata_fsl.c:326: error: previous declaration of 'si' was here

--- a/drivers/ata/sata_fsl.c~git-libata-all-fix-drivers-ata-sata_fslc
+++ a/drivers/ata/sata_fsl.c
@@ -323,7 +323,6 @@ static unsigned int sata_fsl_fill_sg(str
 	struct scatterlist *sg;
 	unsigned int num_prde = 0;
 	u32 ttl_dwords = 0;
-	unsigned int si;
 
 	/*
 	 * NOTE : direct & indirect prdt's are contigiously allocated
_

> powerpc_allyesconfig:
> 
> drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_add':
> drivers/net/ehea/ehea_main.c:2812: error: 'struct device_driver' has no member named 'kobj'
> drivers/net/ehea/ehea_main.c:2815: error: 'struct device_driver' has no member named 'kobj'
> drivers/net/ehea/ehea_main.c:2818: error: 'struct device_driver' has no member named 'kobj'
> drivers/net/ehea/ehea_main.c: In function 'ehea_driver_sysfs_remove':
> drivers/net/ehea/ehea_main.c:2830: error: 'struct device_driver' has no member named 'kobj'

Looks like the driver tree wrecking ball failed to visit that driver.

