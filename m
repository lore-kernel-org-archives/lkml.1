Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXDVHBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXDVHBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbXDVHBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:01:36 -0400
Received: from 1wt.eu ([62.212.114.60]:2153 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbXDVHBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:01:35 -0400
Date: Sun, 22 Apr 2007 09:00:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Al Boldi <a1426z@gawab.com>,
       Peter Williams <pwil3058@bigpond.net.au>, Nick Piggin <npiggin@suse.de>,
       Matt Mackall <mpm@selenic.com>, Bill Huey <billh@gnuppy.monkey.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [ANNOUNCE] Staircase Deadline cpu scheduler version 0.45
Message-ID: <20070422070037.GA15092@1wt.eu>
References: <200704221441.48897.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704221441.48897.kernel@kolivas.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 02:41:48PM +1000, Con Kolivas wrote:
> A significant bugfix for SMP balancing was just posted for the staircase 
> deadline cpu scheduler which improves behaviour dramatically on any SMP 
> machine.
> 
> Thanks to Willy Tarreau for noticing likely fault point.
> 
> Also requested was a version in the Makefile so this version of the patch 
> adds -sd045 to the kernel version.

Con, I'm sorry, but it is worse with this one :-(

The lag when typing in xterms is even more noticeable and vmstat output
oscillates between 8 and 65, with idle rates around 50%, as you can see
below :

   procs                      memory      swap          io     system      cpu
 r  b  w   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id
 9  0  0      0 922436   6392  57496    0    0     0     0    2   172 26 33 41
65  0  1      0 922436   6392  57496    0    0     0     0    0   132 23 37 40
66  0  0      0 922436   6392  57496    0    0     0     0    1   159 18 31 51
 9  0  0      0 922436   6392  57496    0    0     0     0    0   166 24 37 40
68  0  0      0 922436   6392  57496    0    0     0     0    5   121 23 32 44
62  0  0      0 922576   6392  57496    0    0     0     0    0   161 17 29 53
 8  0  0      0 922576   6392  57496    0    0     0     0    1   158 23 42 34
65  0  0      0 922576   6392  57496    0    0     0     0    1    92 17 33 50
52  0  2      0 922576   6392  57496    0    0     0     0    0   156 19 28 53
13  0  0      0 922576   6392  57496    0    0     0     0    8   171 25 44 30
65  0  0      0 922576   6392  57496    0    0     0     0   17   172 20 26 54
 8  0  0      0 922576   6392  57496    0    0     0     0    4   188 22 31 47
22  0  0      0 922576   6392  57496    0    0     0     0   10   182 26 38 36
65  0  1      0 922576   6392  57496    0    0     0     0    8   107 18 28 54
 8  0  0      0 922588   6424  57508    0    0    12    36   11   201 26 35 39
66  0  0      0 922588   6424  57508    0    0     0     0   11   115 22 36 43
61  0  0      0 922564   6424  57508    0    0     0     0   32   409 16 28 56
 8  0  0      0 922564   6424  57508    0    0     0     0   19   224 24 42 34
65  0  0      0 922564   6436  57496    0    0     0    12   34   439 19 29 52
 8  0  0      0 922564   6436  57496    0    0     0     0   28   320 18 26 56
20  0  0      0 922564   6436  57508    0    0     0     0    6   195 26 42 32

Renicing X or not does not change anything here.

I suspect that the bug you fixed was hiding another one :-/
If you want me to test another patch, feel free to ask.

Willy

