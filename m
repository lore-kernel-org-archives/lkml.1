Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZCECPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZCECPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 21:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZCECPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 21:15:17 -0500
Received: from gw.goop.org ([64.81.55.164]:39661 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbZCECPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 21:15:16 -0500
Message-ID: <49AF35B0.2000302@goop.org>
Date: Wed, 04 Mar 2009 18:15:12 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] x86: clean up use of system_state in virt_addr_valid and
 co
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two changes remove the tests based on system_state in the virt_addr_valid/phys_addr functions.
It replaces the i386 test with an explicit flag to indicate whether the vmalloc range has been determined,
and on x86-64, it pre-initializes the x86_phys_bits to a reasonable number so that there's no dependency
on init order.

	J

The following changes since commit 4d02f9f7dac27f801fed69be8ebb0b95b798b12c:
  Ingo Molnar (1):
        Merge branch 'x86/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git x86/virt

Jeremy Fitzhardinge (2):
      x86-32: use specific __vmalloc_start_set flag in __virt_addr_valid
      x86-64: pre-initialize boot_cpu_data.x86_phys_bits to avoid system_state tests

 arch/x86/include/asm/pgtable_32_types.h |    5 +++++
 arch/x86/kernel/setup.c                 |    4 +++-
 arch/x86/mm/init_32.c                   |    3 +++
 arch/x86/mm/ioremap.c                   |   14 +++++---------
 4 files changed, 16 insertions(+), 10 deletions(-)


