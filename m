Return-Path: <linux-kernel-owner+w=401wt.eu-S1751525AbZH0DQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbZH0DQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZH0DQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:16:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbZH0DQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:16:22 -0400
Date: Wed, 26 Aug 2009 23:15:33 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       kamezawa.hiroyu@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Amerigo Wang <amwang@redhat.com>, "M. Mohan Kumar" <mohan@in.ibm.com>,
       akpm@linux-foundation.org, bernhard.walle@gmx.de,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090827031800.4534.94868.sendpatchset@localhost.localdomain>
Subject: [Patch 0/8] V5 Implement crashkernel=auto
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V4 -> V5:
 - Rename the global functions, as suggested by Andrew.
 - Save some macros, as suggested by Andrew.
 - Change the high threshold, from 32G to 4G.
 - Change the low threshold on ppc, suggested by ppc developers.
 - Make the mm part as a seperate function, suggest by Eric.
 - Make the IA64 code more readable.
 - Reorder the patchset again, since review from mm people is done.

V3 -> V4:
 - Reorder the patches.
 - Really free the reserved memory, instead of remapping it.
   (Thanks to KAMEZAWA Hiroyuki!)
 - Release the reserved memory resource when the size is 0.
 - Use strict_strtoul() instead of simple_strtoul().

V2 -> V3:
 - Use more clever way to calculate reserved memory size, especially for IA64.
 - Add that patch that implements shrinking reserved memory

V1 -> V2:
 - Use include/asm-generic/kexec.h, suggested by Neil.
 - Rename a local variable, suggested by Fenghua.
 - Fix some style problems found by checkpatch.pl.
 - Unify the Kconfig docs.

This series of patch implements automatically reserved memory for crashkernel,
by introducing a new boot option "crashkernel=auto". This idea is from Neil.

In case of breaking user-space applications, it modifies this boot option after
it decides how much memory should be reserved.

On different arch, the threshold and reserved memory size is different. Please
refer patch 7/8 which contains an update for the documentation.

Patch 8/8 implements shrinking reserved memory at run-time, which is useful
when more than enough memory is reserved automatically.

This patchset _is_ already tested on x86_64, IA64 and ppc64.

Cc: Neil Horman <nhorman@redhat.com>
Cc: M. Mohan Kumar <mohan@in.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Bernhard Walle <bernhard.walle@gmx.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
 Documentation/kdump/kdump.txt    |   29 +++++++++
 arch/ia64/Kconfig                |   14 ++++
 arch/ia64/include/asm/kexec.h    |   44 +++++++++++++
 arch/powerpc/Kconfig             |   11 +++
 arch/powerpc/include/asm/kexec.h |   39 ++++++++++++
 arch/x86/Kconfig                 |   13 ++++
 arch/x86/include/asm/kexec.h     |    1 
 include/asm-generic/kexec.h      |   16 +++++
 include/linux/kexec.h            |    2 
 kernel/kexec.c                   |  124 +++++++++++++++++++++++++++++++++++++++
 kernel/ksysfs.c                  |   21 ++++++
 11 files changed, 314 insertions(+)

