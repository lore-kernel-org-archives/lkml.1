Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZEUQPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZEUQPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZEUQPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:15:34 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26689 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbZEUQPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:15:33 -0400
X-IronPort-AV: E=Sophos;i="4.41,228,1241409600"; 
   d="scan'208";a="52100748"
From: Ian Campbell <ian.campbell@citrix.com>
To: ian.campbell@citrix.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <beckyb@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       xen-devel <xendevel@lists.xensource.com>,
       x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: swiotlb: remove __weak hooks in favour of architecture-specific functions
Date: Thu, 21 May 2009 17:15:21 +0100
Message-Id: <1242922528-5982-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 21 May 2009 16:15:34.0125 (UTC) FILETIME=[5E8AE9D0:01C9DA2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the end of this series there are no more __weak functions in
lib/swiotlb.c

The series adds several hook functions to the x86 architecture. Would
they be preferred as a struct x86_swiotlb_ops or as individual hooks?

I was unsure what to do about powerpc in most places since the
existing support seems to in-progress so it wasn't always clear where
to put the implementation. If there is a tree somewhere with more
complete support I'll be happy to provide additional patches.

Boot tested on x86 under xen but not even compiled for ia64 or
powerpc. If someone can point me to a decent source of cross compilers
I can sort that out. (http://www.kernel.org/pub/tools/crosstool/ seems
to be out-of-date and only has ia64 in any case)

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Cc: Olaf Kirch <okir@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>
Cc: xen-devel <xendevel@lists.xensource.com>
Cc: x86 maintainers <x86@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>

--- 
 arch/ia64/include/asm/dma-mapping.h    |   29 ++++++++++++++
 arch/ia64/kernel/pci-swiotlb.c         |   11 +++++
 arch/powerpc/include/asm/dma-mapping.h |    5 ++
 arch/x86/include/asm/agp.h             |    4 +-
 arch/x86/include/asm/dma-mapping.h     |   34 +++++++++++++++++
 arch/x86/include/asm/xen/iommu.h       |    4 ++
 arch/x86/kernel/pci-dma.c              |    6 ++-
 arch/x86/kernel/pci-gart_64.c          |    4 +-
 arch/x86/kernel/pci-nommu.c            |    3 +-
 arch/x86/kernel/pci-swiotlb.c          |   32 ++++++++++++++++
 arch/x86/xen/Makefile                  |    3 +-
 arch/x86/xen/pci-swiotlb.c             |   53 --------------------------
 drivers/pci/xen-iommu.c                |   20 ++++++++--
 include/linux/dma-mapping.h            |    5 --
 include/linux/swiotlb.h                |   10 -----
 include/xen/swiotlb.h                  |    5 --
 lib/swiotlb.c                          |   64 +++++++-------------------------
 17 files changed, 156 insertions(+), 136 deletions(-)
