Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbYGARFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbYGARFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 13:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYGAREz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 13:04:55 -0400
Received: from outbound-mail-130.bluehost.com ([67.222.38.30]:44278 "HELO
	outbound-mail-130.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751331AbYGAREy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 13:04:54 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [git pull] PCI fixes for 2.6.26
Date: Tue, 1 Jul 2008 10:04:47 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011004.47487.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll stop making predictions about whether this is the last pull request for 
2.6.26 or not, but it is an important one.  It turns out that we've had a 
trivial DoS on machines containing PCI devices with bad VPDs.  We're 
entertaining a few options for a scalable, long term fix, but in the 
meantime, restricting access to the sysfs VPD file seems prudent.  I've 
included the patch in lieu of a diffstat since it's so small.

Thanks,
Jesse

Ben Hutchings (1):
      PCI: Restrict VPD read permission to root

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 6f3c744..1f855f0 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -738,7 +738,7 @@ int __must_check pci_create_sysfs_dev_files (struct 
pci_dev
                        pdev->vpd->attr = attr;
                        attr->size = pdev->vpd->ops->get_size(pdev);
                        attr->attr.name = "vpd";
-                       attr->attr.mode = S_IRUGO | S_IWUSR;
+                       attr->attr.mode = S_IRUSR | S_IWUSR;
                        attr->read = pci_read_vpd;
                        attr->write = pci_write_vpd;
                        retval = sysfs_create_bin_file(&pdev->dev.kobj, attr);

