Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbZC3MY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbZC3MY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZC3MYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:24:48 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:45739
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbZC3MYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:24:47 -0400
Date: Mon, 30 Mar 2009 14:24:37 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       catalin.marinas@arm.com
Subject: Re: linux-next: Tree for March 30: [BUG] kmemleak page fault
Message-ID: <20090330122437.GA4784@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, catalin.marinas@arm.com
References: <20090330200145.8d0da09b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330200145.8d0da09b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-next 20090330 causes the following page fault on an edb9302
(ARM) like board:

# Unable to handle kernel paging request at virtual address 00535447
pgd = c56b0000
[00535447] *pgd=00000000
Internal error: Oops: 3 [#1] PREEMPT
Modules linked in:
CPU: 0    Not tainted  (2.6.29-next-20090330 #6)
PC is at kmemleak_scan+0x158/0x3ac
LR is at find_and_get_object+0xe0/0x104
pc : [<c00aa5cc>]    lr : [<c00a99d8>]    psr: 00000013
sp : c55bff78  ip : c55bff28  fp : c55bffa4
r10: c0322718  r9 : c035fa6c  r8 : c035f048
r7 : c035f044  r6 : 00005800  r5 : 00004981  r4 : 00093020
r3 : 00535443  r2 : 414f4c5f  r1 : 00000001  r0 : c0400020
Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0000717f  Table: 0567c000  DAC: 00000017
Process kmemleak (pid: 343, stack limit = 0xc55be268)
Stack: (0xc55bff78 to 0xc55c0000)
ff60:                                                       c55bff94
00000000
ff80: 00000000 c55be000 0000ea60 c035fa78 c035fa6c c0322718 c55bffd4
c55bffa8
ffa0: c00aac10 c00aa484 c55bffd4 c55be000 00000000 c00aabbc 00000000
00000000
ffc0: 00000000 00000000 c55bfff4 c55bffd8 c005b80c c00aabcc 00000000
00000000
ffe0: 00000000 00000000 00000000 c55bfff8 c0048240 c005b7b0 ffffffff
ffffffff
[<c00aa5cc>] (kmemleak_scan+0x158/0x3ac) from [<c00aac10>]
(kmemleak_scan_thread+0x54/0x1bc)
[<c00aac10>] (kmemleak_scan_thread+0x54/0x1bc) from [<c005b80c>]
(kthread+0x6c/0xa0)
[<c005b80c>] (kthread+0x6c/0xa0) from [<c0048240>] (do_exit+0x0/0x764)
Code: e0830004 e3120801 1590300c 01a03000 (e5933004)
---[ end trace 356a238970dcd5a8 ]---

the fault is reproducible and happens some seconds after having
finished the boot process. please tell me if you need more information
(like the .config, ...) in order to track this down

best regards

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

       The yellow ships hung in the air just like bricks dont do
                 (The Hitch-Hiker's Guide to the Galaxy)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
