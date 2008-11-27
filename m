Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbYK0KHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbYK0KHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYK0KG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:06:57 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40400 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYK0KG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:06:56 -0500
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, travis <travis@sgi.com>
Subject: Re: [PATCH 4/6] fs: Introduce a per_cpu nr_inodes
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com>
	<20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com>
	<20081121.010508.40225532.davem@davemloft.net>
	<4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com>
	<20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com>
	<20081121153453.GA23713@elte.hu> <492DDC91.3020503@cosmosbay.com>
	<1227778377.4454.1299.camel@twins>
Date: Thu, 27 Nov 2008 11:07:01 +0100
In-Reply-To: <1227778377.4454.1299.camel@twins> (Peter Zijlstra's message of "Thu, 27 Nov 2008 10:32:57 +0100")
Message-ID: <87zljl32ka.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
>>  
>> +int get_nr_inodes(void)
>> +{
>> +	int cpu;
>> +	int counter = 0;
>> +
>> +	for_each_possible_cpu(cpu)
>> +	    counter += per_cpu(nr_inodes, cpu);
>> +	if (counter < 0)
>> +		counter = 0;
>> +	return counter;
>> +}
>
> It would be good to get a cpu hotplug handler here and move to
> for_each_online_cpu(). People are wanting distro's to be build with
> NR_CPUS=4096.

Doesn't matter, possible cpus is always only set to what the
machine supports.

-Andi
-- 
ak@linux.intel.com
