Return-Path: <linux-kernel-owner+w=401wt.eu-S1758448AbZDXMBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758448AbZDXMBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbZDXL7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:59:16 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:17564
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755976AbZDXL7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:59:13 -0400
X-BigFish: VPS-4(zz4015Mzz1202hzzz32i62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KILT9Z-01-ALV-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.or>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH 0/7] KVM support for 1GB pages v2
Date: Fri, 24 Apr 2009 13:58:40 +0200
Message-ID: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.2.3
X-OriginalArrivalTime: 24 Apr 2009 11:58:48.0096 (UTC) FILETIME=[06AE3200:01C9C4D4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the second version of the patches implementing support for 1GB
pages in KVM. There are too many changes to the first version to mention
them all here. The core support was rewritten to work with mapping
levels instead of page sizes. This was the main part of the change.
The patches still only support KVM with nested paging enabled.
All patches apply to avi/master and can be pulled from

	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-kvm.git kvm-gb-pages

Here is the complete diffstat:

 arch/ia64/include/asm/kvm_host.h    |    3 +-
 arch/powerpc/include/asm/kvm_host.h |    3 +-
 arch/x86/include/asm/kvm_host.h     |   16 ++-
 arch/x86/kvm/mmu.c                  |  213 +++++++++++++++++++++-------------
 arch/x86/kvm/paging_tmpl.h          |   11 +-
 arch/x86/kvm/svm.c                  |    7 +
 arch/x86/kvm/vmx.c                  |    7 +
 arch/x86/kvm/x86.c                  |    6 +-
 include/linux/kvm.h                 |    1 +
 include/linux/kvm_host.h            |    2 +-
 mm/hugetlb.c                        |    1 +
 virt/kvm/kvm_main.c                 |   46 +++++---
 12 files changed, 204 insertions(+), 112 deletions(-)

Please give these patches a good review :)

Thanks,

	Joerg


