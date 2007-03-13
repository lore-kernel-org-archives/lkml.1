Return-Path: <linux-kernel-owner+w=401wt.eu-S965667AbXCMJgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965667AbXCMJgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965661AbXCMJgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:36:05 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:6902 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965667AbXCMJgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:36:04 -0400
Message-ID: <45F673AD.5050406@sw.ru>
Date: Tue, 13 Mar 2007 12:49:33 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: devel@openvz.org
CC: Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Devel] Re: [RFC][PATCH 1/7] Resource counters
References: <45ED7DEC.7010403@sw.ru> <45ED7F69.60108@sw.ru>	<45EE39A5.7010804@in.ibm.com> <45EE6769.9060701@sw.ru>	<20070309163711.GA3647@MAIL.13thfloor.at>	<m1fy8bwqps.fsf@ebiederm.dsl.xmission.com>	<20070312011612.GD21861@MAIL.13thfloor.at> <m1bqixtsr1.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1bqixtsr1.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> - doesn't store the accounted value but
>>   limit - accounted (i.e. the free resource)
>> - uses atomic_add_return() 
>> - when negative, an error is returned and
>>   the resource amount is added back
>>
>>changes to the limit have to adjust the 'current'
>>value too, but that is again simple and atomic
>>
>>best,
>>Herbert
>>
>>PS: atomic_add_unless() didn't exist back then
>>(at least I think so) but that might be an option
>>too ...
> 
> 
> I think as far as having this discussion if you can remove that race
> people will be more willing to talk about what vserver does.
> 
> That said anything that uses locks or atomic operations (finer grained locks)
> because of the cache line ping pong is going to have scaling issues on large
> boxes.

> So in that sense anything short of per cpu variables sucks at scale.  That said
> I would much rather get a simple correct version without the complexity of
> per cpu counters, before we optimize the counters that much.
fully agree with it. We need to get a working version first.

FYI, in OVZ we recently added such optimizations: reserves like in TCP/IP,
e.g. for kmemsize, numfile these reserves are done on task-basis for
fast charges/uncharges w/o involving lock operations.
On task exit reserves are returned back to the beancounter.

As it demonstrated atomic counters can be replaced with
task-reserves on the next step.

Thanks,
Kirill
