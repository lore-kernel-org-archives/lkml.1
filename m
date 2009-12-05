Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbZLECHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbZLECHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 21:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZLECHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 21:07:24 -0500
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:1364 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZLECHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 21:07:18 -0500
Message-ID: <4B19BAD3.1000808@caviumnetworks.com>
Date: Fri, 04 Dec 2009 17:43:47 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] Add support for GCC's __builtin_unreachable() and use
 it in BUG (v2.1).
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Dec 2009 01:43:49.0692 (UTC) FILETIME=[64764FC0:01CA754C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Linus et al.,

 From the announcement of the first version:

     Starting with version 4.5, GCC has a new built-in function called
     __builtin_unreachable().  The function tells the compiler that
     control flow will never reach that point.  Currently we trick the
     compiler by putting in for(;;); but this has the disadvantage that
     extra code is emitted for an endless loop.  For an i386 kernel
     using __builtin_unreachable() results in an defaultconfig that is
     nearly 4000 bytes smaller.

     This patch set adds support to compiler.h creating a new macro
     usable in the kernel called unreachable().  If the compiler lacks
     __builtin_unreachable(), it just expands to for(;;).


For version 2:

     I fixed a couple of checkpatch issues, and simplified the
     unreachable() macro for the pre-GCC-4.5 case (as suggested by
     Richard Henderson).  Also several Acked-by: were added.

For this version 2.1:

     I removed patches from the set for which there were no Acked-by,
     and rebased and tested against 2.6.32.

I will reply with the 5 patches.

David Daney (5):
   Add support for GCC-4.5's __builtin_unreachable() to compiler.h (v2)
   x86: Convert BUG() to use unreachable()
   MIPS: Convert BUG() to use unreachable()
   s390: Convert BUG() to use unreachable()
   avr32: Convert BUG() to use unreachable()

  arch/avr32/include/asm/bug.h  |    2 +-
  arch/mips/include/asm/bug.h   |    4 +---
  arch/s390/include/asm/bug.h   |    2 +-
  arch/x86/include/asm/bug.h    |    4 ++--
  include/linux/compiler-gcc4.h |   14 ++++++++++++++
  include/linux/compiler.h      |    5 +++++
  6 files changed, 24 insertions(+), 7 deletions(-)

