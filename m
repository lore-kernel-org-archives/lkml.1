Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbZLIHye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbZLIHye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbZLIHyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:54:17 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:44278 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270AbZLIHyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:54:09 -0500
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?= 
	<mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org
Message-ID: <1-1000-25639-1260344705-9533@rere.qmqm.pl>
Date: Wed, 9 Dec 2009 08:34:12 +0100
Subject: [PATCH 0/7] mtrr: cleanups and CONFIG_EMBEDDED usage
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit of code-cutting in MTRR handling for users of CONFIG_EMBEDDED.
Patches generated on top of current linux-2.6.git (commit 2b876f9...),
tested on 2.6.32 (Pentium4 machine only, all patches at once).

size arch/x86/kernel/cpu/mtrr/built-in.o (stats based on 2.6.32)
   text    data     bss     dec     hex
  13934    5340    8476   27750    6c66 before
  13931    5216    8436   27583    6bbf after (PROCESSOR_SELECT=n)
  11788    5188    8356   25332    62f4 after (CPU_SUP_INTEL=y only)

Best Regards,
Michał Mirosław


Michał Mirosław (7):
  x86/mtrr: Remove mtrr_ops[]
  mtrr: constify struct mtrr_ops
  mtrr: Remove use_intel()
  x86/Kconfig.cpu: add CPU_SUP_AMD_32 and CPU_SUP_CENTAUR_32
  mtrr: use CONFIG_CPU_SUP_* to select MTRR implementations
  mtrr: introduce HAVE_MTRR_VENDOR_SPECIFIC
  mtrr: mark mtrr_if as __read_mostly

 arch/x86/Kconfig                   |    3 ++
 arch/x86/Kconfig.cpu               |    9 ++++++
 arch/x86/kernel/cpu/mtrr/Makefile  |    4 ++-
 arch/x86/kernel/cpu/mtrr/amd.c     |    7 +----
 arch/x86/kernel/cpu/mtrr/centaur.c |    7 +----
 arch/x86/kernel/cpu/mtrr/cyrix.c   |    7 +----
 arch/x86/kernel/cpu/mtrr/generic.c |    3 +-
 arch/x86/kernel/cpu/mtrr/main.c    |   54 ++++++++++++-----------------------
 arch/x86/kernel/cpu/mtrr/mtrr.h    |   23 +++++++++++----
 arch/x86/kernel/cpu/mtrr/state.c   |   10 +++---
 10 files changed, 60 insertions(+), 67 deletions(-)

