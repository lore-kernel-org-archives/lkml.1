Return-Path: <linux-kernel-owner+w=401wt.eu-S1755591AbZHPSkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591AbZHPSkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 14:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZHPSkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 14:40:45 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45715 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZHPSko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 14:40:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc
         :disposition-notification-to:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=KlvYLb0TW55ZyG8dzqYLkTOdsjne+YVk4cYwfuVt195WpkWbtowmGp058AQ4bW6z4j
         HZGjSZCkbEqLJtcXveTfJ4mPmxCM0rQelGbRaZCSXPz+elL/StHlHEktP7GyHGR0iD9m
         ZaY1irwqYKnuP0VlLePR7u9OQi46n+GsnE71Q=
From: Leonardo Potenza <lpotenza@inwind.it>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/pci: fix section mismatch warnings in intel-iommu.c
Date: Sun, 16 Aug 2009 20:40:08 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-smp1; KDE/4.3.0; x86_64; ; )
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908162040.08661.lpotenza@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>

The functions si_domain_init() and iommu_prepare_static_identity_mapping() have been marked __init, in order to address the following section mismatch messages:

WARNING: drivers/pci/built-in.o(.text+0x3c4e5): Section mismatch in reference from the function si_domain_init() to the function .init.text:si_domain_work_fn()
The function si_domain_init() references
the function __init si_domain_work_fn().
This is often because si_domain_init lacks a __init 
annotation or the annotation of si_domain_work_fn is wrong.

WARNING: drivers/built-in.o(.text+0x415a5): Section mismatch in reference from the function si_domain_init() to the function .init.text:si_domain_work_fn()
The function si_domain_init() references
the function __init si_domain_work_fn().
This is often because si_domain_init lacks a __init 
annotation or the annotation of si_domain_work_fn is wrong.

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
---
Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c	2009-08-16 19:29:32.000000000 +0200
+++ linux-2.6/drivers/pci/intel-iommu.c	2009-08-16 19:31:12.000000000 +0200
@@ -2047,7 +2047,7 @@ static int __init si_domain_work_fn(unsi
 
 }
 
-static int si_domain_init(void)
+static int __init si_domain_init(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct intel_iommu *iommu;
@@ -2165,7 +2165,7 @@ static int iommu_should_identity_map(str
 	return 1;
 }
 
-static int iommu_prepare_static_identity_mapping(void)
+static int __init iommu_prepare_static_identity_mapping(void)
 {
 	struct pci_dev *pdev = NULL;
 	int ret;
