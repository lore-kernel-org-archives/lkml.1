Return-Path: <linux-kernel-owner+w=401wt.eu-S1752648AbZFQDxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbZFQDxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 23:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762623AbZFQDwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 23:52:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:49485 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764311AbZFQDwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 23:52:45 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, JBeulich@novell.com, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: [GIT PATCH core/percpu] x86,percpu: fix pageattr handling with remap allocator, take#4
Date: Wed, 17 Jun 2009 12:52:12 +0900
Message-Id: <1245210739-25699-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 03:52:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Upon ack, please pull from the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu-fix-remap

This is the third take of x86-percpu-fix-pageattr patchset.  Changes
from the last take[L] are...

* Rebased on top of linus#master + tj-percpu-convert-most-archs, take#3

* Dup free in setup_pcpu_remap() fixed.

* remap allocator renamed to lpage.

* Changes to cpa_process_alias() updated such that the remap handling
  code doesn't consider multipage case and trigger WARN_ON() if @cpa
  at that point has numpages higher than 1.  Because the target PMD
  page is always partially recycled, it always ends up splitted to 4k
  pages and thus numpages is guaranteed to be 1 at that point.

This patchset contains the following seven patches.

 0001-x86-fix-duplicate-free-in-setup_pcpu_remap-failur.patch
 0002-x86-rename-remap-percpu-first-chunk-allocator-to-lp.patch
 0003-x86-prepare-setup_pcpu_lpage-for-pageattr-fix.patch
 0004-x86-reorganize-cpa_process_alias.patch
 0005-x86-fix-pageattr-handling-for-lpage-percpu-allocato.patch
 0006-x86-implement-percpu_alloc-kernel-parameter.patch
 0007-x86-ensure-percpu-lpage-doesn-t-consume-too-much-vm.patch

0001 and 0002 are new ones.  0005 has the cpa_process_alias() change
updated describd above.  Other than that, no notable changes.

This patchset is on top of

linus-2.6#master (300df7dc89cc276377fc020704e34875d5c473b6)
+ [1] tj-percpu-convert-most-archs, take#3

and contains the following changes.

 Documentation/kernel-parameters.txt |    6 
 arch/x86/include/asm/percpu.h       |    9 +
 arch/x86/kernel/setup_percpu.c      |  219 ++++++++++++++++++++++++++----------
 arch/x86/mm/pageattr.c              |   65 ++++++----
 mm/percpu.c                         |   13 +-
 5 files changed, 226 insertions(+), 86 deletions(-)

Thanks.

--
tejun

[L] http://thread.gmane.org/gmane.linux.kernel/844298
[1] http://thread.gmane.org/gmane.linux.kernel.cross-arch/3818
