Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbYLOOuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbYLOOuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYLOOuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:50:32 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:11107 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbYLOOub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:50:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=W5EeRkD53nESTcv+S7i/3DHta7QJ+rf+XIMoMm/csorX/iQmFJ0YaxLzxvXlDSluI8
         jc4vAOHr/Q9nTg1HdOVdaU5OGXkS3eDrV/axf8KpkQSzo9an2K7e720KZBRFN3g5LRtM
         ruO4KhMfqlFGIm/iOYl04qppNl7coiJw+q4iU=
Message-ID: <7c86c4470812150650t3b96d571nba14be2028fa9d0c@mail.gmail.com>
Date: Mon, 15 Dec 2008 15:50:29 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: [patch] Performance Counters for Linux, v3
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Vince Weaver" <vince@deater.net>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>, "Paul Mackerras" <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4942BF69.4030402@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
	 <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
	 <1229073834.12883.41.camel@twins>
	 <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>
	 <7c86c4470812121001i765d663bq6db3080b633a1eef@mail.gmail.com>
	 <4942BF69.4030402@nortel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 8:45 PM, Chris Friesen <cfriesen@nortel.com> wrote:
> stephane eranian wrote:
>
>> What happens in the following test case:
>>
>>   - 2-way system (cpu0, cpu1)
>>
>>   - on cpu0, two processes P1, P2, each self-monitoring and counting event
>> E1.
>>     Event E1 can only be measured on counter C1.
>>
>>   - on cpu1, there is a cpu-wide session, monitoring event E1, thus using
>> C1
>>
>>   - the scheduler decides to migrate P1 onto CPU1. You now have a
>> conflict on C1.
>>
>> How is this managed?
>
> Prevent the load balancer from moving P1 onto cpu1?
>
You don't want to do that.

There was a reason why the scheduler decided to move the task.
Now, because of monitoring you would change the behavior of the task
and scheduler.
Monitoring should be unintrusive. You want the task/scheduler to
behave as if no monitoring
was present otherwise what is it you are actually measuring?

Changing or forcing the affinity because of monitoring is also a bad
idea, for the same reason.
