Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbYHEMJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbYHEMJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbYHEMIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:08:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36355 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbYHEMIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:08:39 -0400
Date: Tue, 05 Aug 2008 21:06:25 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Cc: kosaki.motohiro@jp.fujitsu.com, KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
In-Reply-To: <489738CF.7090401@linux-foundation.org>
References: <2f11576a0808040947r69076eecv9ff92ecf583f7af2@mail.gmail.com> <489738CF.7090401@linux-foundation.org>
Message-Id: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> 
> > When hackbench running, SLUB consume memory very largely than SLAB.
> > then, SLAB often outperform SLUB in memory stavation state.
> > 
> > I don't know why memory comsumption different.
> > Anyone know it?
> 
> Can you quantify the difference?

machine spec:
CPU: IA64 x 8
MEM: 8G (4G x2node)

test method

1. echo 3 >/proc/sys/vm/drop_caches
2. % ./hackbench 90 process 1000       <- for fill pagetable cache
3. % ./hackbench 90 process 1000


vmstat result

<SLAB (without CONFIG_DEBUG_SLAB)>

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 2  0      0 3223168   6016  38336    0    0     0     0 3181 4314  0 15 85  0  0
2039  2      0 2022144   6016  38336    0    0     0     0 2364 13622  0 49 51  0  0
634  0      0 2629824   6080  38336    0    0     0    64 83582 2538927  5 95  0  0  0
596  0      0 2842624   6080  38336    0    0     0     0 6864 675841  6 94  0  0  0
590  0      0 2993472   6080  38336    0    0     0     0 9514 456085  6 94  0  0  0
503  0      0 3138560   6080  38336    0    0     0     0 8042 276024  4 96  0  0  0

about 3G remain.

<SLUB>
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
1066  0      0 323008   3584  18240    0    0     0     0 12037 47353  1 99  0  0  0
1101  0      0 324672   3584  18240    0    0     0     0 6029 25100  1 99  0  0  0
913  0      0 330240   3584  18240    0    0     0     0 9694 54951  2 98  0  0  0

about 300M remain.


So, about 2.5G - 3G difference in 8G mem.




