Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZFEEBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZFEEBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZFEEAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:00:50 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51450 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZFEEAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:00:49 -0400
Message-Id: <200906050400.n5540Sx0052981@www262.sakura.ne.jp>
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       andreas.herrmann3@amd.com, mingo@elte.hu
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Jun 2009 13:00:28 +0900
References: <200906050038.n550c4Ja010907@www262.sakura.ne.jp> <20090605023835.GA7933@cr0.nay.redhat.com> <20090604201733.746928c6.akpm@linux-foundation.org> <200906050339.n553d684048041@www262.sakura.ne.jp> <20090604205103.bbfe9af2.akpm@linux-foundation.org>
In-Reply-To: <20090604205103.bbfe9af2.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 05062009 #2086045, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Well, that tells us the .c file, but not the location within it. 
> Please check the .loc info as I suggested.

        .loc 1 51 0
        movl    -52(%ebp), %ebx #  start_phys_aligned
        sbbl    %edi, %ebx
        .loc 1 42 0
        movl    %edx, -16(%ebp) #  pattern
        .loc 1 51 0
        subl    %ecx, %eax      #  size
        pushl   $0
        .loc 1 42 0
        movl    20(%ebp), %edx  #  size
        .loc 1 51 0
        sbbl    %ebx, %edx
        pushl   $8
.LCFI12:
        call    __udivdi3
        popl    %ebx
        .loc 1 53 0
        movl    $0, -36(%ebp)   #  start_bad
        .loc 1 52 0
        movl    -56(%ebp), %ebx #  start_phys_aligned
        subl    $1073741824, %ebx
        .loc 1 56 0
        cmpl    %edx, -36(%ebp) #  start_bad
        .loc 1 51 0
        popl    %esi
        movl    %edx, %edi
        movl    %eax, %esi      #  count
        .loc 1 52 0

> Perhaps it's this:
> 
> static void __init memtest(u64 pattern, u64 start_phys, u64 size)
> {
> 	u64 i, count;
> 	u64 *start;
> 	u64 start_bad, last_bad;
> 	u64 start_phys_aligned;
> 	size_t incr;
> 
> 	incr = sizeof(pattern);
> 	start_phys_aligned = ALIGN(start_phys, incr);
> 	count = (size - (start_phys_aligned - start_phys))/incr;
Bingo!

