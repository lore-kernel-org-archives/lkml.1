Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYHaSWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYHaSWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 14:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbYHaSWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 14:22:17 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:8202 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbYHaSWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 14:22:16 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: [BUG] x86 kenel won't boot under Virtual PC
Date: Sun, 31 Aug 2008 14:22:11 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808311422.12525.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently discovered that x86 kernels won't boot under Virtual PC.  In this 
case paravirt was not built into the kernel.  The kernel just "hangs" on 
attempted boot with no error messages.  Git-bisect pinpointed the following 
commit as the problem:

commit 32c464f5d9701db45bc1673288594e664065388e
Author: Jan Beulich <jbeulich@novell.com>
Date:   Wed Oct 17 18:04:41 2007 +0200

    x86: multi-byte single instruction NOPs

    Add support for and use the multi-byte NOPs recently documented to be
    available on all PentiumPro and later processors.

    This patch only applies cleanly on top of the "x86: misc.
    constifications" patch sent earlier.

    [ tglx: arch/x86 adaptation ]

    Signed-off-by: Jan Beulich <jbeulich@novell.com>
    Signed-off-by: Andi Kleen <ak@suse.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

     arch/x86/kernel/alternative.c  |   23 ++++++++++++++++++++++-
     include/asm-x86/processor_32.h |   22 ++++++++++++++++++++++
     include/asm-x86/processor_64.h |   22 ++++++++++++++++++++++
     3 files changed, 66 insertions(+), 1 deletion(-)

:040000 040000 9226efb160ea180e8c419134b82e0a6938868c1a 
12daabe81d9cda0d574815c0957a24c1028c8fb0 M      arch
:040000 040000 7ab3918741abcb203bd25289d2c6e789bed64fc1 
eb662fea6ed7904074c87dd004b9f6d23964c844 M      include

Any suggestion on where to go from here would be appreciated.
