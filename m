Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbYDPMsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbYDPMsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761658AbYDPMrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:47:48 -0400
Received: from saeurebad.de ([85.214.36.134]:58537 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761472AbYDPMrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:47:47 -0400
X-Mailbox-Line: From hannes@skyscraper.fehenstaub.lan Wed Apr 16 13:37:18 2008
Message-Id: <20080416113629.947746497@skyscraper.fehenstaub.lan>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 13:36:29 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux MM <linux-mm@kvack.org>
Subject: [RFC][patch 0/5] Bootmem fixes
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are a bunch of fixes for the bootmem allocator.  These are tested
on boring x86_32 UMA hardware, but 3 patches only show their effects
on multi-node systems, so please review and test.

Only the first two patches are real code changes, the others are
cleanups.

`Node-setup agnostic free_bootmem()' assumes that all bootmem
descriptors describe contiguous regions and bdata_list is in ascending
order.  Yinghai was unsure about this fact, Ingo could you ACK/NAK
this?

	Hannes

 arch/alpha/mm/numa.c             |    8 ++--
 arch/arm/mm/discontig.c          |   34 +++++++--------
 arch/ia64/mm/discontig.c         |   11 ++---
 arch/m32r/mm/discontig.c         |    4 +-
 arch/m68k/mm/init.c              |    4 +-
 arch/mips/sgi-ip27/ip27-memory.c |    3 +-
 arch/parisc/mm/init.c            |    3 +-
 arch/powerpc/mm/numa.c           |    3 +-
 arch/sh/mm/numa.c                |    5 +-
 arch/x86/mm/discontig_32.c       |    3 +-
 arch/x86/mm/numa_64.c            |    4 +-
 include/linux/bootmem.h          |    7 +--
 mm/bootmem.c                     |   82 ++++++++++++++++++++++----------------
 mm/page_alloc.c                  |    4 +-
 14 files changed, 84 insertions(+), 91 deletions(-)

--

