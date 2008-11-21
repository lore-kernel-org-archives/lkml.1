Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYKUP33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYKUP33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYKUP3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:29:18 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:53607 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbYKUP3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:29:16 -0500
Message-ID: <4926D39D.9050603@cosmosbay.com>
Date: Fri, 21 Nov 2008 16:28:29 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, cl@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       efault@gmx.de, a.p.zijlstra@chello.nl,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] fs: pipe/sockets/anon dentries should not have a parent
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121152148.GA20388@elte.hu>
In-Reply-To: <20081121152148.GA20388@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 21 Nov 2008 16:28:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> Before patch, time to run 8 millions of close(socket()) calls on 8 
>> CPUS was :
>>
>> real    0m27.496s
>> user    0m0.657s
>> sys     3m39.092s
>>
>> After patch :
>>
>> real    0m23.997s
>> user    0m0.682s
>> sys     3m11.193s
> 
> cool :-)
> 
> What would it take to get it down to:
> 
>>> Cost if run one one cpu :
>>>
>>> real    0m1.561s
>>> user    0m0.092s
>>> sys     0m1.469s
> 
> i guess asking for a wall-clock cost of 1.561/8 would be too much? :)
> 

It might be possible, depending on the level of hackery I am allowed to inject
in fs/dcache.c and fs/inode.c :)

wall cost of 1.56 (each cpu runs one loop of one million iterations)


