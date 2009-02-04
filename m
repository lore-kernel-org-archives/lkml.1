Return-Path: <linux-kernel-owner+w=401wt.eu-S1751804AbZBDH2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbZBDH2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 02:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751849AbZBDH1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 02:27:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46644
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbZBDH1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 02:27:34 -0500
Date: Tue, 03 Feb 2009 23:27:31 -0800 (PST)
Message-Id: <20090203.232731.09107598.davem@davemloft.net>
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


Some build fixups from Stephen Rothwell, and some debugging
helpers to assist with some of the crashes and hangs we've
been seeing on sparc64 lately.

In particular sparc64 has an NMI watchdog now.

Please pull, thanks a lot!

The following changes since commit dcf6a79dda5cc2a2bec183e50d829030c0972aaa:
  Artem Bityutskiy (1):
        write-back: fix nr_to_write counter

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (6):
      sparc64: Move generic PCR support code to seperate file.
      sparc: Probe PMU type and record in sparc_pmu_type.
      sparc64: Implement NMI watchdog on capable cpus.
      sparc64: On non-Niagara, need to touch NMI watchdog in NOHZ mode.
      sparc64: Validate kernel generated fault addresses on sparc64.
      sparc64: Kill bogus TPC/address truncation during 32-bit faults.

Stephen Rothwell (1):
      sparc: fixup for sparseirq changes

 arch/sparc/include/asm/cpudata_64.h |    2 +-
 arch/sparc/include/asm/irq_64.h     |    4 +-
 arch/sparc/include/asm/kdebug_64.h  |    2 +
 arch/sparc/include/asm/nmi.h        |   10 ++
 arch/sparc/include/asm/pcr.h        |   46 +++++++
 arch/sparc/include/asm/pil.h        |    1 +
 arch/sparc/kernel/Makefile          |    2 +
 arch/sparc/kernel/cpu.c             |   33 ++++--
 arch/sparc/kernel/irq_64.c          |   68 +----------
 arch/sparc/kernel/kernel.h          |    1 +
 arch/sparc/kernel/nmi.c             |  224 +++++++++++++++++++++++++++++++++
 arch/sparc/kernel/pcr.c             |  153 +++++++++++++++++++++++
 arch/sparc/kernel/process_64.c      |    5 +-
 arch/sparc/kernel/setup_64.c        |    2 +
 arch/sparc/kernel/ttable.S          |    3 +-
 arch/sparc/mm/fault_64.c            |   44 ++++++-
 arch/sparc/oprofile/init.c          |  232 +++++-----------------------------
 17 files changed, 548 insertions(+), 284 deletions(-)
 create mode 100644 arch/sparc/include/asm/nmi.h
 create mode 100644 arch/sparc/include/asm/pcr.h
 create mode 100644 arch/sparc/kernel/nmi.c
 create mode 100644 arch/sparc/kernel/pcr.c
