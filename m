Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbYGZJwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbYGZJwt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYGZJwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:52:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41722 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbYGZJwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:52:40 -0400
Date: Sat, 26 Jul 2008 11:52:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, Jason Yeh <jason.yeh@amd.com>
Subject: Re: [PATCH 0/24] oprofile: Add IBS support for AMD CPUs
Message-ID: <20080726095221.GB25890@elte.hu>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Patches #1-3 are not directly related to IBS.
> Patch #4 adds generic support of model specific initialization.
> Patches #10, #11 add the core implementation of IBS.
> Patches #12-24 contain code improvements and small fixes.

cool stuff! I've created the tip/oprofile topic branch for the patches 
from you, Barry and Jason and have applied all the current patches (and 
followup fixes) to it. Below are the access coordinates and the log 
summary.

It's not yet integrated into tip/master - will do some testing first. 
I'll send review feedback separately as well, on a per patch basis.

Thanks,

	Ingo

------------->
You can pull the latest tip/oprofile git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git oprofile

------------------>
Barry Kasindorf (3):
      oprofile: Add support for AMD Family 11h
      x86/oprofile: add IBS support for AMD CPUs, IBS buffer handling routines
      x86/oprofile: add IBS support for AMD CPUs, model specific code

Jason Yeh (1):
      Oprofile Multiplexing Patch

Robert Richter (23):
      x86: add PCI IDs for AMD Barcelona PCI devices
      x86: apic_*.c: add description to AMD's extended LVT functions
      x86/oprofile: introduce model specific init/exit functions
      x86/oprofile: Minor changes in op_model_athlon.c
      x86/oprofile: renaming athlon_*() into op_amd_*()
      drivers/oprofile: coding style fixes in buffer_sync.c
      OProfile: moving increment_tail() in buffer_sync.c
      OProfile: add IBS code macros
      x86/oprofile: separating the IBS handler
      OProfile: change IBS interrupt initialization
      OProfile: Fix build error in op_model_athlon.c
      OProfile: on_each_cpu(): kill unused retry parameter
      OProfile: fix setup_ibs_files() function interface
      OProfile: enable IBS for AMD CPUs
      OProfile: fix IBS build error for UP
      x86/oprofile: macro definition cleanup in op_model_athlon.c
      x86/oprofile: op_model_athlon.c: fix counter reset when reenabling IBS OP
      x86: apic: export symbols for extended interrupt LVT functions
      x86: apic: changing export symbols to *_GPL
      x86/oprofile: add CONFIG_OPROFILE_IBS option
      oprofile: fix printk in cpu_buffer.c
      x86/oprofile: reanaming op_model_athlon.c to op_model_amd.c
      x86/oprofile: fix on_each_cpu build error


 arch/Kconfig                        |   14 +
 arch/x86/kernel/apic_32.c           |    4 +
 arch/x86/kernel/apic_64.c           |    4 +
 arch/x86/oprofile/Makefile          |    2 +-
 arch/x86/oprofile/nmi_int.c         |  127 +++++++-
 arch/x86/oprofile/op_counter.h      |    3 +-
 arch/x86/oprofile/op_model_amd.c    |  559 +++++++++++++++++++++++++++++++++++
 arch/x86/oprofile/op_model_athlon.c |  190 ------------
 arch/x86/oprofile/op_model_p4.c     |    4 +
 arch/x86/oprofile/op_model_ppro.c   |    2 +
 arch/x86/oprofile/op_x86_model.h    |    7 +-
 drivers/oprofile/buffer_sync.c      |  209 +++++++++----
 drivers/oprofile/cpu_buffer.c       |   74 +++++-
 drivers/oprofile/cpu_buffer.h       |    2 +
 drivers/oprofile/oprof.c            |   58 ++++-
 drivers/oprofile/oprof.h            |    4 +-
 drivers/oprofile/oprofile_files.c   |   39 +++-
 include/linux/oprofile.h            |    5 +
 include/linux/pci_ids.h             |    5 +
 19 files changed, 1031 insertions(+), 281 deletions(-)
 create mode 100644 arch/x86/oprofile/op_model_amd.c
 delete mode 100644 arch/x86/oprofile/op_model_athlon.c

