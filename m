Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbZFEM6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbZFEM6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZFEM6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:58:17 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:62294 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbZFEM6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:58:14 -0400
To: andreas.herrmann3@amd.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       xiyou.wangcong@gmail.com, mingo@elte.hu
Subject: Re: [2.6.30-rc8] gcc 3.3 : __udivdi3 undefined.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200906050400.n5540Sx0052981@www262.sakura.ne.jp>
	<20090604212018.b9e9f354.akpm@linux-foundation.org>
	<200906050651.n556p7Vo094549@www262.sakura.ne.jp>
	<20090605000310.a5b8fa56.akpm@linux-foundation.org>
	<20090605093725.GC23657@alberich.amd.com>
In-Reply-To: <20090605093725.GC23657@alberich.amd.com>
Message-Id: <200906052158.GGB12454.OFtMLOFFVQHSJO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 5 Jun 2009 21:58:11 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> Overlooked the 64-bit division.
> Did test this with 4.[23].x compilers on 32-bit which didn't complain ...

gcc version 4.1.2 20080704 (Red Hat 4.1.2-44) generated below code.

        .loc 1 51 0
        movl    -48(%ebp), %eax # start.1059,
        movl    -44(%ebp), %edx # start.1059,
        addl    -24(%ebp), %eax # size,
        adcl    -20(%ebp), %edx # size,
        movl    %eax, -56(%ebp) #, count
        movl    %edx, -52(%ebp) #, count
        subl    %ebx, -56(%ebp) # last_bad.1061, count
.LVL28:
        sbbl    %esi, -52(%ebp) # last_bad.1061, count
        movl    -56(%ebp), %edx # count,
        movl    -52(%ebp), %ecx # count,
        shrdl   $3, %ecx, %edx  #,,
        shrl    $3, %ecx        #,
        movl    %edx, -56(%ebp) #, count
        movl    %ecx, -52(%ebp) #, count

It seems that only gcc 3.x genarates "call __udivdi3" ...
