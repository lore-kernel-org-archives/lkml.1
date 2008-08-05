Return-Path: <linux-kernel-owner+w=401wt.eu-S1760344AbYHEPKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344AbYHEPKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbYHEPJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:09:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755745AbYHEPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:09:35 -0400
Message-ID: <48986AC6.5030406@linux-foundation.org>
Date: Tue, 05 Aug 2008 09:59:18 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
References: <2f11576a0808040947r69076eecv9ff92ecf583f7af2@mail.gmail.com> <489738CF.7090401@linux-foundation.org> <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:

>> Can you quantify the difference?
> 
> machine spec:
> CPU: IA64 x 8
> MEM: 8G (4G x2node)

16k or 64k page size?

 > procs -----------memory---------- ---swap-- -----io---- --system--
-----cpu------
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
>  2  0      0 3223168   6016  38336    0    0     0     0 3181 4314  0 15 85  0  0
> 2039  2      0 2022144   6016  38336    0    0     0     0 2364 13622  0 49 51  0  0
> 634  0      0 2629824   6080  38336    0    0     0    64 83582 2538927  5 95  0  0  0
> 596  0      0 2842624   6080  38336    0    0     0     0 6864 675841  6 94  0  0  0
> 590  0      0 2993472   6080  38336    0    0     0     0 9514 456085  6 94  0  0  0
> 503  0      0 3138560   6080  38336    0    0     0     0 8042 276024  4 96  0  0  0
> 
> about 3G remain.
> 
> <SLUB>
> procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
> 1066  0      0 323008   3584  18240    0    0     0     0 12037 47353  1 99  0  0  0
> 1101  0      0 324672   3584  18240    0    0     0     0 6029 25100  1 99  0  0  0
> 913  0      0 330240   3584  18240    0    0     0     0 9694 54951  2 98  0  0  0
> 
> about 300M remain.
> 
> 
> So, about 2.5G - 3G difference in 8G mem.

Well not sure if that tells us much. Please show us the output of
/proc/meminfo after each run. The slab counters indicate how much memory is
used by the slabs.

It would also be interesting to see the output of the slabinfo command after
the slub run?

