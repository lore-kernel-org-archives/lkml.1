Return-Path: <linux-kernel-owner+w=401wt.eu-S1751420AbZIHOlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420AbZIHOlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbZIHOlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:41:05 -0400
Received: from mail-px0-f184.google.com ([209.85.216.184]:59374 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZIHOlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:41:04 -0400
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
Mime-Version: 1.0 (Apple Message framework v1075.2)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Anirban Sinha <ani@anirban.org>
In-Reply-To: <1252399347.7746.19.camel@twins>
Date: Tue, 8 Sep 2009 07:41:01 -0700
Cc: Anirban Sinha <ASinha@zeugmasystems.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dario Faggioli <raistlin@linux.it>
Content-Transfer-Encoding: 7bit
Message-Id: <729B1E67-339D-405E-A07D-80C8275B55FF@anirban.org>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it> <dhcf5-263-13@gated-at.bofh.it> <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com> <1252218779.6126.17.camel@marge.simson.net> <1252310374.7564.6.camel@twins> <DDFD17CC94A9BD49A82147DDF7D545C54DC487@exchange.ZeugmaSystems.local> <9039A647-41AF-43C0-9376-F21E664F61E5@anirban.org> <1252399347.7746.19.camel@twins>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Mailer: Apple Mail (2.1075.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2009-09-08, at 1:42 AM, Peter Zijlstra wrote:

> On Tue, 2009-09-08 at 00:08 -0700, Anirban Sinha wrote:
>
>>> Actually there is, use cpusets to carve the system into partitions.
>>
>> hmm. ok. I looked at the code a little bit. It seems to me that the
>> 'borrowing' of RT runtimes occurs only from rt runqueues belonging to
>> the same root domain. And partition_sched_domains() is the only
>> external interface that can be used to create root domain out of a  
>> CPU
>> set. But then I think it needs to have CGROUPS/USER groups enabled?
>> Right?
>
> No you need cpusets, you create a partition by disabling load- 
> balancing
> on the top set, thereby only allowing load-balancing withing the
> children.
>

Ah I see. Thanks for the clarification.


> The runtime sharing is a form of load-balancing.

sure.


>
> CONFIG_CPUSETS=y


Hmm. Ok. I guess what I meant but did not articulate properly (because  
I was thinking in terms of code) was CPUSETS needed CGROUPS support:

config CPUSETS
	bool "Cpuset support"
	depends on CGROUPS


Anyway, that's fine. I'll dig around the code a little bit more.


>
> Documentation/cgroups/cpusets.txt

Thanks for the pointer. My bad, I did not care to see the docs. I tend  
to ignore docs and read code instead. :D


>

