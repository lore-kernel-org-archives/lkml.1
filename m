Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYIGUJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYIGUJ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 16:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbYIGUJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 16:09:49 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:5367 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbYIGUJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 16:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=hxU5LeH6UJRY8lYfWsiAfV0/vzM/SohKPkUjK0u4ouk+ChvBxor2uHWdl0NTk7GSOQ
         IszYmlaUe9C2KVAiMSKSXtgQP3WAHgGpbRlnMCFrNtgq+jKP+s+KoStLffvaPpVYyjiQ
         wVhTxcazozu1Db8elhXR9Sbbv6PaeYeDBilsk=
Date: Sun, 7 Sep 2008 22:09:43 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kmemcheck updates for tip/kmemcheck
Message-ID: <20080907200943.GA2665@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Here follows a small update to the REP instruction handling and removal
of some obsolete code (if you worry that this is useful code, git will
save it for us and it can be revived if needed. I believe that the code
is simply a burden as it is today).

I couldn't figure out how to merge v2.6.27-rc5 without littering the
pull request with all the commits that were made in Linus's repository
since v2.6.27-rc3, but feel free to do it yourself. There should be no
conflicts.

You may also delete the tip/kmemcheck-dma branch as this has now been
integrated since the last pull you did.


The following changes since commit db4b0f1e8ae7c9ffde8bef2eb3dcd4fad5988ac1:
  Vegard Nossum (1):
        kmemcheck: implement REP MOVS/STOS emulation

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip

Vegard Nossum (3):
      kmemcheck: hide/show pages in each iteration of a REP instruction
      kmemcheck: rip out the optimized memset()
      kmemcheck: rip out SMP code

 arch/x86/Kconfig.debug            |   22 --------
 arch/x86/mm/kmemcheck/Makefile    |    4 +-
 arch/x86/mm/kmemcheck/kmemcheck.c |   27 ++--------
 arch/x86/mm/kmemcheck/shadow.c    |    2 +-
 arch/x86/mm/kmemcheck/smp.c       |   80 ------------------------------
 arch/x86/mm/kmemcheck/smp.h       |   23 ---------
 arch/x86/mm/kmemcheck/string.c    |   99 -------------------------------------
 include/asm-x86/string_32.h       |    8 ---
 include/asm-x86/string_64.h       |    1 -
 9 files changed, 7 insertions(+), 259 deletions(-)
 delete mode 100644 arch/x86/mm/kmemcheck/smp.c
 delete mode 100644 arch/x86/mm/kmemcheck/smp.h
 delete mode 100644 arch/x86/mm/kmemcheck/string.c

Thanks,


Vegard
