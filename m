Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZKCVxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZKCVxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZKCVxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:53:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbZKCVxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:53:24 -0500
Date: Tue, 3 Nov 2009 22:52:41 +0100 (CET)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH cleanup] Re: + mips-vpe-remove-leftover-unlock_kernel.patch
 added to -mm tree
In-Reply-To: <20091103085613.373634ab.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0911032243530.6542@localhost.localdomain>
References: <200911030701.nA371cAP019835@imap1.linux-foundation.org> <20091103140953.GA23611@linux-mips.org> <20091103085613.373634ab.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Nov 2009, Andrew Morton wrote:

> On Tue, 3 Nov 2009 15:09:53 +0100 Ralf Baechle <ralf@linux-mips.org> wrote:
> 
> > On Mon, Nov 02, 2009 at 11:01:38PM -0800, akpm@linux-foundation.org wrote:
> > 
> > I already have an equivalent patch in the MIPS kernel - Linus only needs
> > to finally pull ...
> > 
> 
> I didn't see such a patch in yesterday's linux-next..
> 

Linus picked-up Ralf's version of the patch for 2.6.32-rc6
a22d621c80fb08f668ae3bfe62aeaae64b0b2b89

That has the important part that removes the stray unlock_kernel, but
unfortunately doesn't remove the smp_lock.h header.

So, the last patch is just a clean-up. (no urgency).

>From ae20d9169893112daaad1dc3af9f8559003a2bfb Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Tue, 3 Nov 2009 22:15:55 +0100
Subject: [PATCH] Remove BKL header.

Now that the bkl has been removed, also remove the smp_lock.h include

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/mips/kernel/vpe.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 6047752..2bd2151 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -38,7 +38,6 @@
 #include <linux/vmalloc.h>
 #include <linux/elf.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/moduleloader.h>
 #include <linux/interrupt.h>
-- 
1.6.0.6

