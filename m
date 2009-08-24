Return-Path: <linux-kernel-owner+w=401wt.eu-S1751261AbZHXCAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbZHXCAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 22:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbZHXCAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 22:00:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbZHXCAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 22:00:35 -0400
Message-ID: <4A91F4A0.2040009@redhat.com>
Date: Mon, 24 Aug 2009 10:02:08 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, bernhard.walle@gmx.de,
       Fenghua Yu <fenghua.yu@intel.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 1/8] kexec: allow to shrink reserved memory
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>	<20090821065650.4855.53279.sendpatchset@localhost.localdomain> <m18whcr5i8.fsf@fess.ebiederm.org>
In-Reply-To: <m18whcr5i8.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Amerigo Wang <amwang@redhat.com> writes:
>
>   
>> +
>> +	start = roundup(start, PAGE_SIZE);
>> +	end = roundup(start + new_size, PAGE_SIZE);
>> +
>> +	for (addr = end; addr < crashk_res.end; addr += PAGE_SIZE) {
>> +		ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
>> +		init_page_count(pfn_to_page(addr >> PAGE_SHIFT));
>> +		free_page((unsigned long)__va(addr));
>> +		totalram_pages++;
>>     
>
> Any chance we can move this inline snippet into a helper function in
> -mm.  To expose what is happening here to the mm developers.
>
>   

Yes, I believe so. In fact I also wanted to do this, but I forgot before 
I sent these patches... Will do it in the next version.

Thanks.


