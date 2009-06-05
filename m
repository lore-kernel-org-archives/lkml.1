Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZFEDjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZFEDjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbZFEDjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:39:13 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56369 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZFEDjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:39:12 -0400
Message-Id: <200906050339.n553d684048041@www262.sakura.ne.jp>
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Jun 2009 12:39:06 +0900
References: <200906050038.n550c4Ja010907@www262.sakura.ne.jp> <20090605023835.GA7933@cr0.nay.redhat.com> <20090604201733.746928c6.akpm@linux-foundation.org>
In-Reply-To: <20090604201733.746928c6.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 05062009 #2086045, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Do
> 
> 	make arch/x86/mm/pageattr.s
> 
> then have a look in pageattr.s to find the __udivdi3 callsite.
> 
> It might not even be in arch/x86/mm/pageattr.o at all.  If not, keep
> building .s files in that directory until you find it.
> 
> Building with CONFIG_DEBUG_INFO=1 will allow you to find the exact C
> file-n-line where the __udivdi3() call is being emmitted (look at the
> .loc lines).

$ make -k CONFIG_DEBUG_INFO=1 `echo arch/x86/mm/*.c | sed -e 's/\.c/.s/g'`
(...snipped...)
$ grep __udivdi3 arch/x86/mm/*.s
arch/x86/mm/memtest.s:.globl __udivdi3
arch/x86/mm/memtest.s:  call    __udivdi3



Tetsuo Handa wrote:
> "make allnoconfig" compiles fine. Maybe config dependent?
It was because "make allnoconfig" skips arch/x86/mm/memtest.c .
