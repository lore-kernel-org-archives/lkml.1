Return-Path: <linux-kernel-owner+w=401wt.eu-S1752054AbZHRGb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbZHRGb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 02:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbZHRGbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 02:31:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56406 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbZHRGbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 02:31:24 -0400
Message-ID: <4A8A4ABB.70003@redhat.com>
Date: Tue, 18 Aug 2009 14:31:23 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org, linux-mm@kvack.org,
       Neil Horman <nhorman@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, bernhard.walle@gmx.de,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 8/8] kexec: allow to shrink reserved memory
References: <20090812081731.5757.25254.sendpatchset@localhost.localdomain>	<20090812081906.5757.39417.sendpatchset@localhost.localdomain>	<m1bpmk8l1g.fsf@fess.ebiederm.org>	<4A83893D.50707@redhat.com>	<m1eirg5j9i.fsf@fess.ebiederm.org>	<4A83CD84.8040609@redhat.com>	<m1tz0avy4h.fsf@fess.ebiederm.org>	<4A8927DD.6060209@redhat.com> <20090818092939.2efbe158.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090818092939.2efbe158.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 17 Aug 2009 17:50:21 +0800
> Amerigo Wang <amwang@redhat.com> wrote:
>
>   
>> Eric W. Biederman wrote:
>>     
>>> Amerigo Wang <amwang@redhat.com> writes:
>>>
>>>   
>>>       
>>>> Not that simple, marking it as "__init" means it uses some "__init" data which
>>>> will be dropped after initialization.
>>>>     
>>>>         
>>> If we start with the assumption that we will be reserving to much and
>>> will free the memory once we know how much we really need I see a very
>>> simple way to go about this. We ensure that the reservation of crash
>>> kernel memory is done through a normal allocation so that we have
>>> struct page entries for every page.  On 32bit x86 that is an extra 1MB
>>> for a 128MB allocation.
>>>
>>> Then when it comes time to release that memory we clear whatever magic
>>> flags we have on the page (like PG_reserve) and call free_page.
>>>   
>>>       
>> Hmm, my MM knowledge is not good enough to judge if this works...
>> I need to check more MM source code.
>>
>> Can any MM people help?
>>
>>     
> Hm, memory-hotplug guy is here.
>   

Hi, thank you!
> Can I have a question ?
>
>   - How crash kernel's memory is preserved at boot ?
>   

Use bootmem, I think.

>     It's hidden from the system before mem_init() ?
>   

Not sure, but probably yes. It is reserved in setup_arch() which is 
before mm_init() which calls mem_init().

Do you have any advice to free that reserved memory after boot? :)

Thanks.



