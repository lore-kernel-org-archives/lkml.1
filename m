Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYKUSUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYKUSUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbYKUST5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:19:57 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:34269 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYKUST4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:19:56 -0500
Message-ID: <4926FBBB.3050002@cosmosbay.com>
Date: Fri, 21 Nov 2008 19:19:39 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera> <20081117090648.GG28786@elte.hu> <Pine.LNX.4.64.0811191341570.23502@quilx.com> <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu> <Pine.LNX.4.64.0811210936580.25354@quilx.com> <Pine.LNX.4.64.0811211119550.27777@quilx.com> <4926FB13.3080808@cosmosbay.com>
In-Reply-To: <4926FB13.3080808@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 21 Nov 2008 19:19:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Christoph Lameter a écrit :
>> AIM9 results:
>>         TCP        UDP
>> 2.6.22        104868.00    489970.03
>> 2.6.28-rc5    110007.00    518640.00
>> net-next    108207.00    514790.00
>>
>> net-next looses here for some reason against 2.6.28-rc5. But the numbers
>> are better than 2.6.22 in any case.
>>
> 
> I found that on current net-next, running oprofile in background can 
> give better bench
> results. Thats really curious... no ?
> 
> 
> So the single loop on close(socket()), on all my 8 cpus is almost 10% 
> faster if oprofile
> is running... (20 secs instead of 23 secs)
> 

Oh well, thats normal, since when a cpu is interrupted by a NMI, and
distracted by oprofile code, it doesnt fight with other cpus on dcache_lock
and other contended cache lines...


