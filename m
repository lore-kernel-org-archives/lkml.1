Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbZGFKv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbZGFKv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 06:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZGFKvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 06:51:50 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:63403 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753738AbZGFKvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 06:51:50 -0400
Subject: [RFC PATCH 0/3] kmemleak: Add support for the bootmem allocator
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>
Date: Mon, 06 Jul 2009 11:51:43 +0100
Message-ID: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2009 10:51:44.0346 (UTC) FILETIME=[C07E6BA0:01C9FE27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the last few days, I went through of false positives reported by
kmemleak and it turns out some of them were caused by not tracking
alloc_bootmem* calls. Rather than adding more and more kmemleak
annotations throughout the kernel, I decided to add support for tracking
all the alloc_bootmem* and free_bootmem calls.

The latter may not have a corresponding alloc_bootmem* pair or it may
only free part of a block. I changed kmemleak to support this usage.

Thanks for your feedback.


Catalin Marinas (3):
      kmemleak: Remove alloc_bootmem annotations introduced in the past
      kmemleak: Add callbacks to the bootmem allocator
      kmemleak: Allow partial freeing of memory blocks


 include/linux/kmemleak.h |    4 +++
 kernel/pid.c             |    7 ------
 mm/bootmem.c             |   36 ++++++++++++++++++++++++------
 mm/kmemleak.c            |   55 ++++++++++++++++++++++++++++++++++++++++++----
 mm/page_alloc.c          |   14 +++---------
 5 files changed, 86 insertions(+), 30 deletions(-)

-- 
Catalin
