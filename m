Return-Path: <linux-kernel-owner+w=401wt.eu-S1751489AbXB0Ec2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbXB0Ec2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 23:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXB0Ec1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 23:32:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbXB0Ec1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 23:32:27 -0500
Message-ID: <45E3B421.603@redhat.com>
Date: Mon, 26 Feb 2007 23:31:29 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Hiro Yoshioka <hyoshiok@miraclelinux.com>
CC: davej@redhat.com, harlan@artselect.com, nickpiggin@yahoo.com.au,
       l_allegrucci@yahoo.it, linux-kernel@vger.kernel.org, mingo@elte.hu,
       suparna@in.ibm.com, jens.axboe@oracle.com
Subject: Re: SMP performance degradation with sysbench
References: <20070226223645.GA24174@redhat.com>	<98df96d30702261632u7479c9b2sce93f80f68bbc8d0@mail.gmail.com>	<45E37EA3.3060101@redhat.com> <20070227.130305.424251739.hyoshiok@miraclelinux.com>
In-Reply-To: <20070227.130305.424251739.hyoshiok@miraclelinux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hiro Yoshioka wrote:
> Hi,
> 
> From: Rik van Riel <riel@redhat.com>
>> Hiro Yoshioka wrote:
>>> Howdy,
>>>
>>> MySQL 5.0.26 had some scalability issues and it solved since 5.0.32
>>> http://ossipedia.ipa.go.jp/capacity/EV0612260303/
>>> (written in Japanese but you may read the graph. We compared
>>> 5.0.24 vs 5.0.32)
> snip
>>> MySQL tries to get a mutex but it spends about 16.8% of CPU on 8 core
>>> machine.
>>>
>>> I think there are a lot of room to be inproved in MySQL implementation.
>> That's one aspect.
>>
>> The other aspect of the problem is that when the number of
>> threads exceeds the number of CPU cores, Linux no longer
>> manages to keep the CPUs busy and we get a lot of idle time.
>>
>> On the other hand, with the number of threads being equal to
>> the number of CPU cores, we are 100% CPU bound...
> 
> I have a question. If so, what is the difference of kernel's
> view between SMP and CPU cores?

None.  Each schedulable entity (whether a fully fledged
CPU core or an SMT/HT thread) is treated the same.

> Another question. When the number of threads exceeds the number of
> CPU cores, we may get a lot of idle time. Then a workaround of
> MySQL is that do not creat threads which exceeds the number
> of CPU cores. Is it right?

Not really, that would make it impossible for MySQL to
handle more simultaneous database queries than the system
has CPUs.

Besides, it looks like this is not a problem in MySQL
per se (it works on FreeBSD) but some bug in Linux.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
