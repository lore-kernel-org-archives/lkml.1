Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbZEOEao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbZEOEao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 00:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757762AbZEOE3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 00:29:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:41568 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540AbZEOE3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 00:29:39 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu,
       linux-kernel-owner@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [GIT PATCH 2.6.30-rc5] x86,percpu: fix pageattr handling with remap allocator, take#2
Date: Fri, 15 May 2009 13:28:54 +0900
Message-Id: <1242361739-21186-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 15 May 2009 04:29:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Upon ack, please pull from the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-percpu-pageattr

This is the second take of x86-percpu-fix-pageattr patchset.  Changes
from the last take[L] are...

* 0002 and renamed as per Jan's comment.

* 0003 updated accordingly.

* 0004 updated so that selection logic is left in individual setup
  functions.  This way is easier to add more complex selection logic.

* 0005 added.  This patch makes sure remap allocator doesn't consume
  too much of vmalloc space.  The cutoff is currently 20%.

This patchset contains the following five patches.

  0001-x86-prepare-setup_pcpu_remap-for-pageattr-fix.patch
  0002-x86-reorganize-cpa_process_alias.patch
  0003-x86-fix-pageattr-handling-for-remap-percpu-allocato.patch
  0004-x86-implement-percpu_alloc-kernel-parameter.patch
  0005-x86-ensure-percpu-remap-doesn-t-consume-too-much-vm.patch

and is on top of the current linux-2.6#master (45d44740).

Ingo, 0001-0003 are bug fixes and although 0004-0005 aren't exactly
bug fixes, I think it would be better to include them in 2.6.30.

diffstat follows.

 Documentation/kernel-parameters.txt |    6 +
 arch/x86/include/asm/percpu.h       |    9 +
 arch/x86/kernel/setup_percpu.c      |  199 +++++++++++++++++++++++++++---------
 arch/x86/mm/pageattr.c              |   63 +++++++----
 mm/percpu.c                         |   13 +-
 5 files changed, 218 insertions(+), 72 deletions(-)

Thanks.

--
tejun
