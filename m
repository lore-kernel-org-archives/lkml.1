Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbYBHCNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbYBHCNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 21:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYBHCN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 21:13:26 -0500
Received: from relay2.sgi.com ([192.48.171.30]:49734 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753487AbYBHCNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:13:25 -0500
Date: Thu, 7 Feb 2008 18:13:22 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [git pull] more SLUB updates for 2.6.25
Message-ID: <Pine.LNX.4.64.0802071755580.7473@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/christoph/vm.git slub-linus

(includes the cmpxchg_local fastpath since the cmpxchg_local work
by Matheiu is in now, and the non atomic unlock by Nick. Verified that 
this is not doing any harm after some other patches had been removed. 
cmpxchg_local fastpath was stripped of support for CONFIG_PREEMPT since
that uglified the code and did not seem to work right. We will be 
able to handle preempt much better in the future with some upcoming 
patches)

Christoph Lameter (4):
      SLUB: Deal with annoying gcc warning on kfree()
      SLUB: Use unique end pointer for each slab page.
      SLUB: Alternate fast paths using cmpxchg_local
      SLUB: Support for performance statistics

Ingo Molnar (1):
      SLUB: fix checkpatch warnings

Nick Piggin (1):
      Use non atomic unlock

 Documentation/vm/slabinfo.c |  149 ++++++++++++++++++--
 arch/x86/Kconfig            |    4 +
 include/linux/mm_types.h    |    5 +-
 include/linux/slub_def.h    |   23 +++
 lib/Kconfig.debug           |   13 ++
 mm/slub.c                   |  326 
++++++++++++++++++++++++++++++++++++-------
 6 files changed, 457 insertions(+), 63 deletions(-)

