Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYJMHAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYJMHAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 03:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYJMHAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 03:00:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60511
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbYJMHAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 03:00:40 -0400
Date: Mon, 13 Oct 2008 00:00:17 -0700 (PDT)
Message-Id: <20081013.000017.171095053.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bug fixes:

1) The change adding notify_cpu_starting() broke the sparc32 build
   (fix from Robert Reif), and missed adding the hook to sparc64.

2) chmc driver module init can crash on sun4v systems, because reading
   the %ver register is illegal on those chips, but since we didn't
   mark the %ver register asm with __volatile__ gcc could move it
   before the platform type guard test

Please pull, thanks a lot!

The following changes since commit 4480f15b3306f43bbb0310d461142b4e897ca45b:
  Randy Dunlap (1):
        MAINTAINERS: remove colon from headings

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (2):
      sparc64: Add missing notify_cpu_starting() call.
      chmc: Mark %ver register inline asm with __volatile__

Robert Reif (1):
      sparc32: fix build errors

 arch/sparc/kernel/sun4d_smp.c |    1 +
 arch/sparc/kernel/sun4m_smp.c |    1 +
 arch/sparc64/kernel/chmc.c    |    2 +-
 arch/sparc64/kernel/smp.c     |    4 ++++
 4 files changed, 7 insertions(+), 1 deletions(-)
