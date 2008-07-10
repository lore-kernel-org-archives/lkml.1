Return-Path: <linux-kernel-owner+w=401wt.eu-S1758711AbYGJSlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711AbYGJSlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbYGJSll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:28099 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbYGJSll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="409061561"
Message-Id: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:34 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x2APIC architecture provides a new x2apic mode, which allows for the
increased range of processor addressability ( > 8 bit apic ID support),
MSR access to APIC registers, etc. x2apic specification can be found at
http://download.intel.com/design/processor/specupdt/318148.pdf
(located under http://developer.intel.com/products/processor/manuals/index.htm )

Interrupt-remapping is part of Intel Virtualization Technology for
Directed I/O architecture and the specification can be found from
http://download.intel.com/technology/computing/vptech/Intel(r)_VT_for_Direct_IO.pdf
(above link seems to be broken for the moment, but in general it should be
found under http://www.intel.com/technology/virtualization/ )

Interrupt-remapping architecture enables extended Interrupt Mode on x86
platforms supporting 32-bit APIC-IDs. This infrastructure allows
the existing interrupt sources such as I/OxAPICs and MSI/MSI-X devices work
seamlessly with apic-id's > 8 bits. As such, this is a pre-requisite for
enabling x2apic mode in the CPU.

This patchset adds 64-bit support for interrupt-remapping and x2apic, which
introduces apic_ops for basic APIC ops(uncached memory Vs MSR accesses etc),
new irq_chip's for supporting interrupt-remapping and new genapic for
supporting IPI's, logical cluster/physical x2apic modes.

irq migration in the presence of interrupt-remapping is done from the
process-context as opposed to interrupt-context. Interrupt-remapping
infrastrucutre allows us to do this migration in a simple fashion (atleast for
edge triggered interrupts).

Interrupt-remapping (CONFIG_INTR_REMAP) and DMA-remapping (CONFIG_DMAR)
can be enabled separately.

More details in the individual patches that follow.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
-- 

