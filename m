Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZIKAbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZIKAbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbZIKAba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:31:30 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:17045 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZIKAb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:31:28 -0400
Message-ID: <4AA99A57.70804@caviumnetworks.com>
Date: Thu, 10 Sep 2009 17:31:19 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Fwd: [PATCH 00/10] Add support for GCC's __builtin_unreachable()
 and use it in BUG.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2009 00:31:19.0496 (UTC) FILETIME=[2E6E5480:01CA3277]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drat, I forgot to CC linux-kernel with this message.  Well in case you 
missed it, here it is again.

-------- Original Message --------
Subject: [PATCH 00/10] Add support for GCC's __builtin_unreachable() and 
use it in BUG.
Date: Thu, 10 Sep 2009 16:54:41 -0700
From: David Daney <ddaney@caviumnetworks.com>

Starting with version 4.5, GCC has a new built-in function called
__builtin_unreachable().  The function tells the compiler that control
flow will never reach that point.  Currently we trick the compiler by
putting in for(;;); but this has the disadvantage that extra code is
emitted for an endless loop.  For an i386 kernel using
__builtin_unreachable() results in an allyesconfig that is nearly 4000
bytes smaller.

This patch set adds support to compiler.h creating a
new macro usable in the kernel called unreachable().  If the compiler
lacks __builtin_unreachable(), it just expands to for(;;).

The x86 and MIPS patches I actually tested with a GCC-4.5 snapshot.
Lacking the ability to test the rest of the architectures, I just did
what seemed right without even trying to compile the kernel.

01/10 adds the compiler.h support, the rest of the patches retrofit
the various architecture BUG macros to use it instead of for(;;) or
while(1) loops.

I will reply with the 10 patches.

The architecture specific patches I will send to a smaller set of
people.

David Daney (10):
   Add support for GCC-4.5's __builtin_unreachable() to compiler.h
   x86: Convert BUG() to use unreachable()
   MIPS: Convert BUG() to use unreachable()
   s390: Convert BUG() to use unreachable()
   mn10300: Convert BUG() to use unreachable()
   parisc: Convert BUG() to use unreachable()
   powerpc: Convert BUG() to use unreachable()
   alpha: Convert BUG() to use unreachable()
   avr32: Convert BUG() to use unreachable()
   blackfin: Convert BUG() to use unreachable()

  arch/alpha/include/asm/bug.h    |    2 +-
  arch/avr32/include/asm/bug.h    |    2 +-
  arch/blackfin/include/asm/bug.h |    2 +-
  arch/mips/include/asm/bug.h     |    4 +---
  arch/mn10300/include/asm/bug.h  |    3 ++-
  arch/parisc/include/asm/bug.h   |    4 ++--
  arch/powerpc/include/asm/bug.h  |    2 +-
  arch/s390/include/asm/bug.h     |    2 +-
  arch/x86/include/asm/bug.h      |    4 ++--
  include/linux/compiler-gcc4.h   |   14 ++++++++++++++
  include/linux/compiler.h        |    5 +++++
  11 files changed, 31 insertions(+), 13 deletions(-)


