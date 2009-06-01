Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZFAGfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZFAGfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 02:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbZFAGfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 02:35:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:33056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbZFAGfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 02:35:17 -0400
From: Tejun Heo <tj@kernel.org>
To: JBeulich@novell.com, andi@firstfloor.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [GIT PATCH core/percpu] x86,percpu: fix pageattr handling with remap allocator, take#3
Date: Mon,  1 Jun 2009 15:34:46 +0900
Message-Id: <1243838091-28591-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 06:34:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Upon ack, please pull from the following git tree.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-percpu-fix-remap

This is the third take of x86-percpu-fix-pageattr patchset.  Changes
from the last take[L] are...

* Rebased to reflect changes in linus#master.

* After fixing remap pageattr buf, reenable remap allocator which was
  disabled in upstream.

This patchset contains the following five patches.

  0001-x86-prepare-setup_pcpu_remap-for-pageattr-fix.patch
  0002-x86-reorganize-cpa_process_alias.patch
  0003-x86-fix-pageattr-handling-for-remap-percpu-allocato.patch
  0004-x86-implement-percpu_alloc-kernel-parameter.patch
  0005-x86-ensure-percpu-remap-doesn-t-consume-too-much-vm.patch

This patchset is on top of

core/percpu (e1b9aa3f47242e757c776a3771bb6613e675bf9c)
+ linus-2.6#master (3218911f839b6c85acbf872ad264ea69aa4d89ad)

and contains the following changes.

 Documentation/kernel-parameters.txt |    6 +
 arch/x86/include/asm/percpu.h       |    9 +
 arch/x86/kernel/setup_percpu.c      |  201 +++++++++++++++++++++++++++---------
 arch/x86/mm/pageattr.c              |   70 ++++++++----
 mm/percpu.c                         |   13 +-
 5 files changed, 222 insertions(+), 77 deletions(-)

Thanks.

--
tejun
