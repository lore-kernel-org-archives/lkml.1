Return-Path: <linux-kernel-owner+w=401wt.eu-S1761264AbYFMOBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264AbYFMOBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbYFMOBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:01:08 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:29447 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbYFMOBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=Sa6usUyiA1gX06EA7hAbVvkIwAKApTjtEK8stBdzTl38LbdINhTeTF0FqXypGOiVXv
         VMA3uxh7lHMBb+gV+4tb6W8GuvZMCQPmywOXJ83e7DR5IZlERR/b2CIasxaGEdWNktvL
         MbCQJqVX5gcYtLMU74qvIvAGMlAoV8lj/Tez8=
Date: Fri, 13 Jun 2008 16:00:57 +0200
To: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] kmemcheck: divide and conquer
Message-ID: <20080613140057.GA25833@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've split the main x86/mm/kmemcheck.c file and made a subdirectory of many
files instead.

I have included the diffstat below, but I think the patch itself is too big
for the mailing list. It can instead be viewed at:

http://www.kernel.org/pub/linux/kernel/people/vegard/patches/0001-kmemcheck-divide-and-conquer.patch

The RFC part: Is this a good thing to do? I personally hate the 4000-line
files that are so commonly found in the kernel, and therefore prefer this
split-up. On the other hand, C lacks namespaces, which sometimes leads to
some really long and ugly names just to prevent clashes in the future. But
it's your call, I'll just do whatever it takes to get in... ;-)


Vegard


Author: Vegard Nossum <vegard.nossum@gmail.com>
Date:   Wed Jun 11 12:37:13 2008 +0200

    kmemcheck: divide and conquer

    This patch splits the kmemcheck.c into a subdirectory of many files. This
    makes it easier to get around the different functions because they're now
    grouped together by file.

    Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>

 arch/x86/mm/Makefile              |    2 +-
 arch/x86/mm/kmemcheck.c           | 1100 -------------------------------------
 arch/x86/mm/kmemcheck/Makefile    |    3 +
 arch/x86/mm/kmemcheck/error.c     |  215 ++++++++
 arch/x86/mm/kmemcheck/error.h     |   15 +
 arch/x86/mm/kmemcheck/kmemcheck.c |  477 ++++++++++++++++
 arch/x86/mm/kmemcheck/opcode.c    |   70 +++
 arch/x86/mm/kmemcheck/opcode.h    |    9 +
 arch/x86/mm/kmemcheck/pte.c       |   22 +
 arch/x86/mm/kmemcheck/pte.h       |   10 +
 arch/x86/mm/kmemcheck/shadow.c    |  174 ++++++
 arch/x86/mm/kmemcheck/shadow.h    |   16 +
 arch/x86/mm/kmemcheck/smp.c       |   79 +++
 arch/x86/mm/kmemcheck/smp.h       |   23 +
 arch/x86/mm/kmemcheck/string.c    |   91 +++
 include/linux/kmemcheck.h         |    3 +
 16 files changed, 1208 insertions(+), 1101 deletions(-)
