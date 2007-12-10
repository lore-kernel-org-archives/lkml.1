Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbXLJS7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbXLJS7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 13:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbXLJS7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 13:59:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbXLJS7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 13:59:24 -0500
Message-ID: <475D8C88.5080706@zytor.com>
Date: Mon, 10 Dec 2007 10:59:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org> <20071204032949.c677c021.akpm@linux-foundation.org>
In-Reply-To: <20071204032949.c677c021.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> My ia64 allmodconfig build has taken
> 
> akpm     15700 89.6  0.0   8256   700 pts/4    RN+  03:09  10:41 bc -q kernel/timeconst.bc
> 
> 11 minutes so far.  fc6/x86_64.
> 

I just tried this on my system, using your cross-compiler chain.  I got 
a different error:

/opt/crosstool/gcc-3.4.5-glibc-2.3.6/ia64-unknown-linux-gnu/lib/gcc/ia64-unknown-linux-gnu/3.4.5/../../../../ia64-unknown-linux-gnu/bin/ld: 
section .data.patch [a000000000000500 -> a000000000000507] overlaps 
section .dynamic [a0000000000003c8 -> a000000000000507]
collect2: ld returned 1 exit status
make[2]: *** [arch/ia64/kernel/gate.so] Error 1

... but the timeconst stuff worked fine.  I tried it both from the 
command line and using your xb script.

This is on a fc7/x86-64 box.  I also ran through all the values from 48 
to 1024 on both an fc5 and an fc7 box (no fc6 box readily available, 
although bc has been at 1.06 since 2000...)

In short, this is highly weird.  Could you possibly do me a favour and 
just run, at the command line:

echo 250 | bc -q kernel/timeconst.bc

... and see if it reproduces the lockup (I'm assuming HZ == 250 in your 
config, since that's what I get when I do "make allmodconfig" on IA64.)

(No need to wait 11 minutes.  It should run in a small fraction of a 
second.)

	-hpa
