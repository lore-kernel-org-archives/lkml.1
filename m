Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbZFQMBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbZFQMBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbZFQMBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:01:39 -0400
Received: from smtp.nokia.com ([192.100.122.230]:28651 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769AbZFQMBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:01:39 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 17 Jun 2009 16:53:48 +0300
Message-Id: <20090617135348.2686.45475.sendpatchset@localhost.localdomain>
Subject: [GIT PULL] UBIFS changes for 2.6.31
X-OriginalArrivalTime: 17 Jun 2009 12:01:19.0609 (UTC) FILETIME=[534BBE90:01C9EF43]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull UBIFS changes from

git://git.infradead.org/ubifs-2.6.git linux-next

The following changes since commit 091438dd5668396328a3419abcbc6591159eb8d1:
  Linus Torvalds (1):
        Linux 2.6.30-rc4

are available:

Adrian Hunter (1):
      UBIFS: reset no_space flag after inode deletion

Artem Bityutskiy (6):
      UBIFS: use anonymous device
      UBIFS: remove dead code
      UBIFS: allow sync option in rootflags
      UBIFS: do not forget to register BDI device
      hrtimer: export ktime_add_safe
      UBIFS: start using hrtimers

Corentin Chary (1):
      UBIFS: return proper error code if the compr is not present

Hunter Adrian (1):
      UBIFS: return error if link and unlink race

 fs/ubifs/budget.c   |    4 +-
 fs/ubifs/dir.c      |   19 +++++++++++++
 fs/ubifs/io.c       |   34 ++++++++++++++---------
 fs/ubifs/recovery.c |   31 +++------------------
 fs/ubifs/super.c    |   76 ++++++++++++++++++++++++++++++++++-----------------
 fs/ubifs/ubifs.h    |   13 +++++---
 kernel/hrtimer.c    |    2 +
 7 files changed, 107 insertions(+), 72 deletions(-)

There is one trivial hrtimer patch:


commit 8daa21e61be47a5b136c4ee1be82e391a5788696
Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Date:   Thu May 28 16:21:24 2009 +0300

    hrtimer: export ktime_add_safe

    We want to use hrtimers in UBIFS (for write-buffer write-back timer).
    We need the 'hrtimer_set_expires_range_ns()', which is an in-line
    function which uses 'ktime_add_safe()'.

    Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
    Acked-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cb8a15c..18f6906 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -332,6 +332,8 @@ ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs)
        return res;
 }

+EXPORT_SYMBOL_GPL(ktime_add_safe);
+
 #ifdef CONFIG_DEBUG_OBJECTS_TIMERS

 static struct debug_obj_descr hrtimer_debug_descr;


I have green light from Ingo for merging this patch via ubifs tree:
http://lkml.org/lkml/2009/6/1/331

Thanks,
Artem.
