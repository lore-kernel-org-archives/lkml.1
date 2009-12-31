Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbZLaOaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbZLaOaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 09:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZLaOaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 09:30:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52828 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbZLaOaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 09:30:23 -0500
Date: Thu, 31 Dec 2009 15:30:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <petkovbb@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, v2] x86 fixes
Message-ID: <20091231143004.GA22024@elte.hu>
References: <20091231120322.GA23326@elte.hu>
 <20091231125624.GA14666@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091231125624.GA14666@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <petkovbb@googlemail.com> wrote:

> On Thu, Dec 31, 2009 at 01:03:22PM +0100, Ingo Molnar wrote:
> > Shaun Ruffell (1):
> > 
> >       dma-debug: Do not add notifier when dma debugging is disabled.
> 
> Looks like that last one breaks powerpc allyesconfig builds: 
> 
> http://marc.info/?l=linux-next&m=126221673819746&w=2

It's a build warning, not a broken build. Updated (v2) pull request below, 
with the fix for this. [diffstat manually constructed - i hope i got that 
right.]

Thanks and a happy new year,

	Ingo

Linus,

Please pull the latest x86-fixes-for-linus-2 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus-2

 Thanks,

	Ingo

------------------>
 arch/x86/boot/compressed/Makefile |    1 +
 arch/x86/include/asm/uv/uv_hub.h  |   74 ++++++++++++++++--------------------
 arch/x86/kernel/amd_iommu_init.c  |   10 +++++
 arch/x86/kernel/process.c         |    4 +-
 arch/x86/kernel/process_32.c      |   14 +++---
 arch/x86/kernel/process_64.c      |   24 ++++++------
 arch/x86/mm/kmemcheck/error.c     |   19 ++++-----
 arch/x86/tools/chkobjdump.awk     |   16 ++++++-
 drivers/char/agp/amd64-agp.c      |    9 ++--
 lib/dma-debug.c                   |    8 +++-
 10 files changed, 98 insertions(+), 81 deletions(-)

FUJITA Tomonori (1):
      x86/agp: Fix agp_amd64_init() initialization with CONFIG_GART_IOMMU enabled

H. Peter Anvin (1):
      x86, compress: Force i386 instructions for the decompressor

Ingo Molnar (1):
      dma-debug: Fix bug causing build warning

Joerg Roedel (1):
      x86/amd-iommu: Fix initialization failure panic

Masami Hiramatsu (1):
      x86: Fix objdump version check in chkobjdump.awk for different formats.

Mike Travis (1):
      x86: SGI UV: Fix writes to led registers on remote uv hubs

Pekka Enberg (2):
      x86: Use KERN_DEFAULT log-level in __show_regs()
      x86, kmemcheck: Use KERN_WARNING for error reporting

Shaun Ruffell (1):
      dma-debug: Do not add notifier when dma debugging is disabled.

