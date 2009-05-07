Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbZEGS5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbZEGS5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761109AbZEGS52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:57:28 -0400
Received: from gw.goop.org ([64.81.55.164]:40211 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbZEGS51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:57:27 -0400
Message-ID: <4A032ED7.1030800@goop.org>
Date: Thu, 07 May 2009 11:56:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.com>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] xen: fixes for 2.6.30-rc4
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This series of patches are bugfixes for Xen for 2.6.30.  They are:

xen/x86-64: fix breakpoints and hardware watchpoints
xen/x86-64: clean up warnings about IST-using traps
xen: deal with NMI's use of IST too

  Fix breakpoints and watchpoints on x86-64.  When running native,
  breakpoints and watchpoints use the IST mechanism to run on a
  separate interrupt stack.  Xen doesn't support this, and just delivers
  the interrupts normally.  These patches special-case the IST-using
  interrupts we care about under Xen to use a separate trap gate which
  expects a standard stack layout.  The second patch prints warnings if
  any other IST-using traps arise in the future.

xen/i386: reserve Xen pagetables
xen: reserve Xen start_info rather than e820 reserving

  Reserve the Xen-provided pagetables on i386.  Previously this was
  done implicitly because they happened to be in the memory range
  reserved by something else, but that was cleaned up so we need to
  do it explicitly.  Also, use reserve_early() rather than an e820
  reserved region, so there's some documentation in the kernel boot
  log.

diff stat:
 arch/x86/include/asm/traps.h |    2 ++
 arch/x86/kernel/entry_64.S   |    4 ++++
 arch/x86/xen/enlighten.c     |   36 +++++++++++++++++++++++++++++++++++-
 arch/x86/xen/mmu.c           |    5 +++++
 arch/x86/xen/setup.c         |    6 +++---
 5 files changed, 49 insertions(+), 4 deletions(-)

Thanks,
	J

