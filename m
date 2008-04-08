Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbYDHQ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbYDHQ1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYDHQ1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:27:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbYDHQ1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:27:03 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net,
       amit.shah@qumranet.com, avi@qumranet.com
Subject: [PATCH 0/28] integrate dma_ops
Date: Tue,  8 Apr 2008 13:20:42 -0300
Message-Id: <12076716702129-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the final integration of dma_ops between x86_64 and i386.
The final code is closer to x86_64 than to i386, which is obviously expected.

At the end, pci-dma_{32,64}.c are gone, pci-nommu_64.c is gone, and the temporary
pci-base_32.c is gone too.

This patchset received the same level of scrutiny as the others from my side:
compiled tested in at least 6 different random configs, boot tested in my hardware.

The final diffstat says:

 Documentation/feature-removal-schedule.txt |    7 
 arch/x86/kernel/Makefile                   |    9 
 arch/x86/kernel/pci-base_32.c              |   72 ---
 arch/x86/kernel/pci-dma.c                  |  524 +++++++++++++++++++++++++++++
 arch/x86/kernel/pci-dma_32.c               |  503 +++++++--------------------
 arch/x86/kernel/pci-dma_64.c               |  443 +-----------------------
 arch/x86/kernel/pci-nommu.c                |  100 +++++
 arch/x86/kernel/pci-nommu_64.c             |  140 -------
 arch/x86/mm/init_64.c                      |    4 
 include/asm-x86/dma-mapping.h              |   14 
 include/asm-x86/scatterlist.h              |    3 
 11 files changed, 832 insertions(+), 987 deletions(-)


