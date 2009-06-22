Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZFVR7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZFVR7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 13:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbZFVR7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 13:59:38 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:34717 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbZFVR7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 13:59:37 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
X-IronPort-AV: E=Sophos;i="4.42,270,1243807200";   d="scan'208";a="16332133"
Message-id: <4A3FC68A.2030104@lfbs.rwth-aachen.de>
Date: Mon, 22 Jun 2009 19:59:38 +0200
From: Stefan Lankes <lankes@lfbs.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       "'Andi Kleen'" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-numa@vger.kernel.org, Boris Bierbaum <boris@lfbs.rwth-aachen.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH 0/4]: affinity-on-next-touch
References: <000c01c9d212$4c244720$e46cd560$@rwth-aachen.de>
 <87zldjn597.fsf@basil.nowhere.org>
 <000001c9eac4$cb8b6690$62a233b0$@rwth-aachen.de>
 <20090612103251.GJ25568@one.firstfloor.org>
 <004001c9eb53$71991300$54cb3900$@rwth-aachen.de>
 <1245119977.6724.40.camel@lts-notebook>
 <003001c9ee8a$97e5b100$c7b11300$@rwth-aachen.de>
 <1245164395.15138.40.camel@lts-notebook>
 <000501c9ef1f$930fa330$b92ee990$@rwth-aachen.de>
 <1245299856.6431.30.camel@lts-notebook> <4A3F7A49.6070805@inria.fr>
 <1245680649.7799.54.camel@lts-notebook> <4A3FA326.8030802@inria.fr>
 <1245689724.7799.124.camel@lts-notebook> <4A3FBA11.8030304@inria.fr>
In-reply-to: <4A3FBA11.8030304@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Brice Goglin wrote:
> Lee Schermerhorn wrote:
>> The primary difference should be at unmap time, right?  In the fault
>> path, I only update the pte of the faulting task.  That's why I require
>> the [anon] pages to be in the swap cache [or something similar].  I
>> don't want to be fixing up other tasks' page tables in the context of
>> the faulting task's fault handler.  If, later, another task touches the
>> page, it will take a minor fault and find the [possibly migrated] page
>> in the cache.  Hmmm, I guess all tasks WILL incur the minor fault if
>> they touch the page after the unmap.  That could be part of the
>> difference if you compare on the same kernel version.
>>   
> 
> Agreed.
> 
>> Try booting with cgroup_disable=memory on the command line, if you have
>> the memory resource controller configured in.  See what that does to
>> your measurements.
>>   
> 
> It doesn't seem to help. I'll try to bisect and find where the
> performance dropped.
> 

I am not able to reconstruct any performance drawbacks on my system. 
Could you send me your low-level benchmark?

Stefan
