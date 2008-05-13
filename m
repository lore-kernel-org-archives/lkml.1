Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbYEMGRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbYEMGRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 02:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbYEMGRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 02:17:13 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:48080 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755783AbYEMGRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 02:17:13 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, muli@il.ibm.com, alexisb@us.ibm.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 0/2] x86: per-device dma_mapping_ops
Date: Tue, 13 May 2008 15:04:50 +0900
Message-Id: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds per-device dma_mapping_ops support for
CONFIG_X86_64 like POWER architecture does. This change enables us to
cleanly fix the Calgary IOMMU issue that some devices are not behind
the IOMMU [1]. It also would be helpful to handle KVM PCI passthrough.

A pointer to dma_mapping_ops to struct dev_archdata is added. If the
pointer is non NULL, DMA operations in asm/dma-mapping.h use it. If
it's NULL, the system-wide dma_ops pointer is used as before.

The major obstacle is that dma_mapping_error doesn't take a pointer to
the device unlike other DMA operations. So x86 can't have
dma_mapping_ops per device. Note all the POWER IOMMUs use the same
dma_mapping_error function so this is not a problem for POWER but x86
IOMMUs use different dma_mapping_error functions.

The first patch adds the device argument to dma_mapping_error. The
patch is trivial but large since it touches lots of drivers and
dma-mapping.h in all the architecture.

[1] http://lkml.org/lkml/2008/5/8/423


