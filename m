Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbYH2VTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbYH2VTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbYH2VTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:19:17 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:32918 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbYH2VTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:19:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=qhYuwLg8tYHSYqnSIIRfJ0AZC4RsG7n9ebOaU1EAZFOBkJveopk8k/UB+mUnvVDSMl
         fyGKFZ/UtxDR9UW0JA3KviwbV+FE49RCP+IgHCLFdhYpUepraHh+uU2G7dIHx46WFCRW
         rW2TKoKEUnebFI4cIYTOtb8SdO7KO5hzam4wY=
Date: Fri, 29 Aug 2008 23:19:21 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kmemcheck updates for tip/kmemcheck
Message-ID: <20080829211921.GA1135@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

A rather large update, most of it is implementing the correct REP MOVS/STOS
handling on P4s. I've tested it on both 32-bit and 64-bit and everything
seems good! Also included is the DMA API hooks which prevents false-positive
reports from reads in DMA-able memory.

--

The following changes since commit d99de804af81f223445368b8cb40d44ff12ec89a:
  Ingo Molnar (1):
        Merge commit 'v2.6.27-rc3' into kmemcheck

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip2

Vegard Nossum (7):
      kmemcheck: add DMA hooks
      kmemcheck: work with sizes in terms of bytes instead of bits
      kmemcheck: allow memory accesses that cross page boundaries
      kmemcheck: add some more documentation
      kmemcheck: add some comments
      kmemcheck: save memory contents on use of uninitialized memory
      kmemcheck: implement REP MOVS/STOS emulation

 arch/x86/Kconfig.debug            |    2 +-
 arch/x86/kernel/traps_32.c        |    8 +-
 arch/x86/kernel/traps_64.c        |    8 +-
 arch/x86/mm/kmemcheck/error.c     |   25 +++-
 arch/x86/mm/kmemcheck/kmemcheck.c |  322 +++++++++++++++++++++++++++----------
 arch/x86/mm/kmemcheck/opcode.c    |   38 ++++--
 arch/x86/mm/kmemcheck/opcode.h    |    3 +-
 arch/x86/mm/kmemcheck/shadow.c    |   76 ++--------
 arch/x86/mm/kmemcheck/string.c    |    4 +
 include/asm-x86/dma-mapping.h     |    2 +
 include/asm-x86/kmemcheck.h       |    6 +
 include/linux/kmemcheck.h         |   16 ++
 mm/kmemcheck.c                    |    6 +
 13 files changed, 339 insertions(+), 177 deletions(-)

Thanks,


Vegard
