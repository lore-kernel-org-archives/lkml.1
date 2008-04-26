Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbYDZVRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbYDZVRo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 17:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYDZVRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 17:17:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34375 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbYDZVRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 17:17:35 -0400
Date: Sat, 26 Apr 2008 23:17:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai.lu@sun.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, jbarnes@virtuousgeek.org
Subject: Re: [git pull] "big box" x86 changes, boot protocol
Message-ID: <20080426211715.GA22797@elte.hu>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426195407.GA13729@elte.hu> <20080426133928.a6f40caa.akpm@linux-foundation.org> <20080426210632.GW2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804261410320.2813@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804261410320.2813@woody.linux-foundation.org>
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

> > We always use the gcc builtin for memcpy() here.
> 
> It's probably hard to write a reasonable x86 memcpy() that wouldn't 
> happen to do the right thing for this case, but I do agee - we should 
> still use memmove() for this, just to make it clear that it does 
> overlapping things.

agreed, i queued up the patch below.

	Ingo

------------->
Subject: bootprotocol: cleanup
From: Ingo Molnar <mingo@elte.hu>
Date: Sat Apr 26 23:14:36 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/e820_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-x86.q/arch/x86/kernel/e820_64.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/e820_64.c
+++ linux-x86.q/arch/x86/kernel/e820_64.c
@@ -100,7 +100,7 @@ void __init free_early(unsigned long sta
 	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
 		;
 
-	memcpy(&early_res[i], &early_res[i + 1],
+	memmove(&early_res[i], &early_res[i + 1],
 	       (j - 1 - i) * sizeof(struct early_res));
 
 	early_res[j - 1].end = 0;
