Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbZEOD62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbZEOD62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 23:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbZEOD4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 23:56:55 -0400
Received: from sh.osrg.net ([192.16.179.4]:52096 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488AbZEOD4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 23:56:50 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, arnd@arndb.de, joerg.roedel@amd.com
Subject: [PATCH -tip v2 0/5] add common functions for struct dma_map_ops
Date: Fri, 15 May 2009 12:55:00 +0900
Message-Id: <1242359705-2117-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 15 May 2009 12:56:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We unified x86 and IA64's handling of multiple dma mapping operations
(struct dma_map_ops in linux/dma-mapping.h) so we can remove
duplication in their arch/include/asm/dma-mapping.h.

This patchset adds include/asm-generic/dma-mapping-common.h that
provides some generic dma mapping function definitions for the users
of struct dma_map_ops. This enables us to remove about 100 lines. This
also enables us to easily add CONFIG_DMA_API_DEBUG support, which only
x86 supports for now. The 4th patch adds CONFIG_DMA_API_DEBUG support
to IA64 by adding only 8 lines.

This is against tip/master since tip has some changes to
arch/x86/include/asm/dma-mapping.h.

The changes since the first version are

- fixed a bug that dma_attrs is not passed properly (thanks to Arnd
Bergmann).

- used a new name, dma-mapping-common.h, instead of dma-mapping.h
(suggested by Arnd Bergmann).

- added Joerg's Acked-by

=
 arch/ia64/Kconfig                        |    1 +
 arch/ia64/include/asm/dma-mapping.h      |  110 ++----------------
 arch/x86/Kconfig                         |    1 +
 arch/x86/include/asm/dma-mapping.h       |  174 +---------------------------
 include/asm-generic/dma-mapping-common.h |  190 ++++++++++++++++++++++++++++++
 lib/dma-debug.c                          |   82 ++++++++------
 6 files changed, 252 insertions(+), 306 deletions(-)



