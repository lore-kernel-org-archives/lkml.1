Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbYKHFA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbYKHFA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 00:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750699AbYKHFAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 00:00:47 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:43530 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYKHFAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 00:00:47 -0500
Message-ID: <49151CFF.8060503@us.ibm.com>
Date: Fri, 07 Nov 2008 21:00:47 -0800
From: Badari Pulavarty <pbadari@us.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Balbir Singh <balbir@in.ibm.com>, linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc3 mem_cgroup panic
References: <1226096940.8805.4.camel@badari-desktop> <31630.10.75.179.62.1226111079.squirrel@webmail-b.css.fujitsu.com> <38971.10.75.179.62.1226112376.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <38971.10.75.179.62.1226112376.squirrel@webmail-b.css.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> KAMEZAWA Hiroyuki said:
>   
>> Badari Pulavarty said:
>>     
>>> Hi Balbir,
>>>
>>> I was running memory remove/add tests in a continuous loop.
>>> I get following panic in mem_cgroup migration code.
>>>
>>> Is this a known issue ?
>>>
>>>       
>> No, this is new one. We don't see panic in cpuset based migration..so..
>> Maybe related to page_cgroup allocation/free code in memory hotplug
>> notifier.
>>
>> Thank you for report. I'll try this.
>>
>>     
> Hmm...at quick look...
>
> online/offline page_cgroup's calculation for "start" is buggy..
>
> -start = start_pfn & (PAGES_PER_SECTION - 1);
> +start = start_pfn & ~(PAGES_PER_SECTION - 1);
>
> I'm sorry I can't write patch today.
>
> Regards,
> -Kame
>
>   

Thanks for the fix. Tests are running fine now.

Thanks,
Badari


