Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZFSNR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZFSNR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZFSNQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:16:48 -0400
Received: from wa4ehsobe002.messaging.microsoft.com ([216.32.181.12]:9709 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752256AbZFSNQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:16:46 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i17ch61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KLHM7M-01-2N6-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8 v3] KVM support for 1GB pages
Date: Fri, 19 Jun 2009 15:16:21 +0200
Message-ID: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
X-OriginalArrivalTime: 19 Jun 2009 13:16:38.0443 (UTC) FILETIME=[2D8E97B0:01C9F0E0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the third version of the patches for KVM to support 1GB pages. Changes
to the last version include:

	- changed reporting of 1GB page support to userspace to use
	  SUPPORTED_CPUID ioctl
	- added support for 1GB pages to the software page walker code too

This code still only can make use of 1GB pages with nested paging enabled. I
will give the shadow paging code another debug round soon. Please comment or
consider to apply these patches.

Thanks,

	Joerg

Shortlog:

Joerg Roedel (8):
      hugetlbfs: export vma_kernel_pagsize to modules
      kvm: change memslot data structures for multiple hugepage sizes
      kvm/mmu: rename is_largepage_backed to mapping_level
      kvm/mmu: make rmap code aware of mapping levels
      kvm/mmu: make direct mapping paths aware of mapping levels
      kvm/mmu: add support for another level to page walker
      kvm/mmu: enable gbpages by increasing nr of pagesizes
      kvm x86: report 1GB page support to userspace

Diffstat:

 arch/ia64/include/asm/kvm_host.h    |    3 +-
 arch/powerpc/include/asm/kvm_host.h |    3 +-
 arch/x86/include/asm/kvm_host.h     |   15 ++-
 arch/x86/kvm/mmu.c                  |  219 ++++++++++++++++++++++-------------
 arch/x86/kvm/paging_tmpl.h          |   27 ++++-
 arch/x86/kvm/svm.c                  |    6 +
 arch/x86/kvm/vmx.c                  |    6 +
 arch/x86/kvm/x86.c                  |    3 +-
 include/linux/kvm_host.h            |    2 +-
 mm/hugetlb.c                        |    1 +
 virt/kvm/kvm_main.c                 |   53 ++++++---
 11 files changed, 222 insertions(+), 116 deletions(-)


