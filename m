Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbZDQIlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbZDQIlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745AbZDQIlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:41:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:41767 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbZDQIlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:41:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,203,1239001200"; 
   d="scan'208";a="448762604"
From: Weidong Han <weidong.han@intel.com>
To: mingo@elte.hu, dwmw2@infradead.org, allen.m.kay@intel.com,
       fenghua.yu@intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Weidong Han <weidong.han@intel.com>
Subject: [PATCH 0/5] fix bugs of x2apic/intr-remap
Date: Fri, 17 Apr 2009 16:42:11 +0800
Message-Id: <1239957736-6161-1-git-send-email-weidong.han@intel.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interupt remapping was decoupled from x2apic already, but there are still
some issues, such as doesn't ack remapped interrupts correctly, and doesn't
remap ioapic interrupt when x2apic is not enabled.

This patchset fixes the ack for remapped interrupts, and alwasys enables
interrupt remapping before ioapic setup to guarantee ioapic interrupts are
remapped, adjusts the dependency of x2apic and interrupt remapping in
lapic_resume. In addition, add option "nointremap" to disable interrupt
remapping.

The patchset can be applied on linux head. Thanks.

Weidong Han (5):
  docs: add nox2apic back to kernel-parameters.txt
  x86,intr-remap: fix ack for interrupt remapping
  x86, intr-remap: enable interrupt remapping early
  x86, intr-remap: add option to disable interrupt remapping
  x86: fix x2apic/intr-remap resume

 Documentation/kernel-parameters.txt |    5 ++
 arch/x86/include/asm/apic.h         |   15 +-----
 arch/x86/kernel/apic/apic.c         |   91 +++++++++++++++++------------------
 arch/x86/kernel/apic/io_apic.c      |   32 ++----------
 drivers/pci/intel-iommu.c           |    9 ----
 drivers/pci/intr_remapping.c        |   39 ++++++++++-----
 include/linux/dmar.h                |    1 +
 7 files changed, 84 insertions(+), 108 deletions(-)

