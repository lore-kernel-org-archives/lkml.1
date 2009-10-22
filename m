Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbZJVXom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbZJVXom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 19:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbZJVXom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 19:44:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58842 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZJVXol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 19:44:41 -0400
Date: Fri, 23 Oct 2009 01:44:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Please pull hwpoison updates for 2.6.32-rc5
Message-ID: <20091022234443.GX32470@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Here are the hwpoison updates for 2.6.32-rc5. These contain bug fixes
from various people, including a workaround for the page flags
races that were discussed earlier, a fix for a workqueue in workqueue
deadlock and a couple of smaller fixes.

I also improved the documentation and did some clean up to the prctl()
interface before it is set in stone.

Please pull.

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6 hwpoison-2.6.32

Andi Kleen (4):
      HWPOISON: Clean up PR_MCE_KILL interface
      HWPOISON: Add brief hwpoison description to Documentation
      HWPOISON: Fix page count leak in hwpoison late kill in do_swap_page
      HWPOISON: Allow schedule_on_each_cpu() from keventd

Hugh Dickins (2):
      HWPOISON: fix oops on ksm pages
      HWPOISON: fix/proc/meminfo alignment

Wu Fengguang (2):
      HWPOISON: return early on non-LRU pages
      HWPOISON: fix invalid page count in printk output

 Documentation/vm/hwpoison.txt |  136 +++++++++++++++++++++++++++++++++++++++++
 fs/proc/meminfo.c             |    2 +-
 include/linux/prctl.h         |   12 ++++
 kernel/sys.c                  |   23 ++++++--
 kernel/workqueue.c            |   21 ++++++-
 mm/memory-failure.c           |   59 +++++++++---------
 mm/memory.c                   |    3 +-
 7 files changed, 219 insertions(+), 37 deletions(-)
 create mode 100644 Documentation/vm/hwpoison.txt

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
