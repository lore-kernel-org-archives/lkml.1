Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZEGEgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZEGEgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 00:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZEGEft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 00:35:49 -0400
Received: from sh.osrg.net ([192.16.179.4]:55115 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbZEGEfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 00:35:48 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tony.luck@intel.com, linux-ia64@vger.kernel.org
Subject: [PATCH -tip 0/5] add generic dma-mappig.h
Date: Thu,  7 May 2009 13:35:43 +0900
Message-Id: <1241670948-5818-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 07 May 2009 13:35:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We unified x86 and IA64's handling of multiple dma mapping operations
(struct dma_map_ops in linux/dma-mapping.h) so we can remove
duplication in their arch/include/asm/dma-mapping.h.

This patchset adds include/asm-generic/dma-mapping.h that provides
some generic dma mapping function definitions for the users of struct
dma_map_ops. This enables us to remove about 100 lines. This also
enables us to easily add CONFIG_DMA_API_DEBUG support, which only x86
supports for now. The 4th patch adds CONFIG_DMA_API_DEBUG support to
IA64 by adding only 8 lines.

This is against tip/master since tip has some changes to
arch/x86/include/asm/dma-mapping.h.

=
 arch/ia64/Kconfig                   |    1 +
 arch/ia64/include/asm/dma-mapping.h |  110 ++------------------
 arch/x86/Kconfig                    |    1 +
 arch/x86/include/asm/dma-mapping.h  |  174 +-------------------------------
 include/asm-generic/dma-mapping.h   |  190 +++++++++++++++++++++++++++++++++++
 lib/dma-debug.c                     |   82 +++++++++------
 6 files changed, 252 insertions(+), 306 deletions(-)


