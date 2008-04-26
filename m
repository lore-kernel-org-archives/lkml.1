Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYDZJ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYDZJ6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 05:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYDZJ6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 05:58:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47417 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYDZJ6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 05:58:11 -0400
Date: Sat, 26 Apr 2008 11:57:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 PAT changes
Message-ID: <20080426095757.GA15474@elte.hu>
References: <20080424225625.GB8717@elte.hu> <alpine.LFD.1.10.0804251351511.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804251351511.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Also, it causes this message for me on one of my machines:
> 
> 	EXT3-fs: mounted filesystem with ordered data mode.
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0400000
> 	mtrr: no more MTRRs available
> 	Overlap at 0xd0000000-0xe0000000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0380000
> 	EXT3 FS on dm-0, internal journal
> 	...
> 	eth0: no IPv6 routers present
> 	Overlap at 0xd0000000-0xe0000000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0380000
> 	Overlap at 0xd0000000-0xe0000000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0380000
> 	Overlap at 0xd0000000-0xe0000000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0380000
> 	Overlap at 0xd0000000-0xe0000000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0380000
> 	Overlap at 0xd0000000-0xe0000000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0380000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xd0000000-0xd0020000
> 	mtrr: no more MTRRs available
> 	Overlap at 0xd0000000-0xe0000000
> 	Overlap at 0xe0300000-0xe0400000
> 	Overlap at 0xe0300000-0xe0380000
> 
> which is a bit annoying. Forgotten debug printk, perhaps?

yeah - i already toned it down to KERN_INFO once in commit 28eb559b5 - 
but it should be pr_debug() instead. The idea in pat.c is to only print 
out if it's a material condition that the user should know about. I've 
queued up the patch below.

	Ingo

-------->
Subject: x86 PAT: tone down debugging messages
From: Ingo Molnar <mingo@elte.hu>
Date: Sat Apr 26 11:40:31 CEST 2008

Linus reported these excessive debug printouts:

>       Overlap at 0xe0300000-0xe0400000
>       Overlap at 0xe0300000-0xe0380000
>       Overlap at 0xe0300000-0xe0400000
>       Overlap at 0xe0300000-0xe0400000
>       Overlap at 0xe0300000-0xe0400000
>       Overlap at 0xe0300000-0xe0400000
>       Overlap at 0xe0300000-0xe0400000

turn that into a pr_debug().

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/mm/pat.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/pat.c
+++ linux-x86.q/arch/x86/mm/pat.c
@@ -334,7 +334,7 @@ int reserve_memtype(u64 start, u64 end, 
 				break;
 			}
 
-			printk("Overlap at 0x%Lx-0x%Lx\n",
+			pr_debug("Overlap at 0x%Lx-0x%Lx\n",
 			       saved_ptr->start, saved_ptr->end);
 			/* No conflict. Go ahead and add this new entry */
 			list_add(&new_entry->nd, saved_ptr->nd.prev);
