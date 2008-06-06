Return-Path: <linux-kernel-owner+w=401wt.eu-S1764774AbYFFHy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764774AbYFFHy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 03:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763607AbYFFHyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 03:54:03 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34157 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763044AbYFFHyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 03:54:00 -0400
Date: Fri, 6 Jun 2008 17:53:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606175358.a439d1bb.sfr@canb.auug.org.au>
In-Reply-To: <20080606004743.a78180c3.akpm@linux-foundation.org>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
	<20080606072536.GA19334@elte.hu>
	<20080606003327.9ac0e91b.akpm@linux-foundation.org>
	<20080606074137.GA28962@elte.hu>
	<20080606004743.a78180c3.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Fri, 6 Jun 2008 00:47:43 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>
> My third bisect iteration has hit this:
> 
> arch/x86/mm/kmmio.c: In function 'get_kmmio_probe':
> arch/x86/mm/kmmio.c:85: error: implicit declaration of function 'list_for_each_entry_rcu'

You need the following patch from linux-next.  Which should be the commit
immediately after the merge of the ftrace tree.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

>From ee19aa543ada9ce11a0b3b8480f3a268ff86cb02 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 27 May 2008 12:53:04 +1000
Subject: [PATCH] ftrace: fix rculist split fallout

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/mm/kmmio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index b65871e..7bfdad7 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -23,6 +23,7 @@
 #include <linux/errno.h>
 #include <asm/debugreg.h>
 #include <linux/mmiotrace.h>
+#include <linux/rculist.h>
 
 #define KMMIO_PAGE_HASH_BITS 4
 #define KMMIO_PAGE_TABLE_SIZE (1 << KMMIO_PAGE_HASH_BITS)
-- 
1.5.5.1

