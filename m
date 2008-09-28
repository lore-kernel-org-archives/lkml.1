Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYI1RDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYI1RDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 13:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYI1RDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 13:03:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:56441 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbYI1RDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 13:03:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=pJxcNP2dYPf+RtxzMeRg2fDNl5/FxFC2bQ9M5miJwJ3XX1W7lmKcK9SPih1B70M+iP
         eoh2RDOkCiUrrsXbJONFPTkTkM5fwqQjJp6vgxSxnfrhgKHcOUigcn9RBnh5Y2AkQbhC
         J7LJTznjxeBjVPbcd5N+KVshFkaKaxb/l3kEI=
Date: Sun, 28 Sep 2008 19:03:16 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] kmemcheck updates (for -tip)
Message-ID: <20080928170316.GA6893@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here comes next batch of kmemcheck patches. Temporary work-around for
x86_64 is to not track >4k pages. It would be nice to have this sorted
out properly, but there is not enough time for me to look into it at
the moment.

The following changes since commit 4b7f562ea9736b8b111ffeb60a7311075ce76849:
  Ingo Molnar (1):
        kmemcheck: build fix

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip

Vegard Nossum (4):
      kmemcheck: hide/show pages in each iteration of a REP instruction #2
      kmemcheck: lazy checking for MOVS instructions
      Revert "kmemcheck: use set_memory_4k() instead of disabling PSE"
      x86: use REP MOVS instruction for memcpy if kmemcheck is enabled

 arch/x86/Makefile                 |    5 ++
 arch/x86/kernel/cpu/common.c      |    7 ++
 arch/x86/kernel/head_32.S         |    2 +-
 arch/x86/mm/init_32.c             |    2 +-
 arch/x86/mm/kmemcheck/kmemcheck.c |  127 +++++++++++++++++++++++++++++++++++--
 include/asm-x86/string_32.h       |    8 +++
 include/asm-x86/string_64.h       |    8 +++
 mm/kmemcheck.c                    |    8 +++
 8 files changed, 159 insertions(+), 8 deletions(-)

Thanks,


Vegard
