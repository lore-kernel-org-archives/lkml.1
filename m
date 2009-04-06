Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZDFLAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZDFLAv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 07:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZDFLAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 07:00:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35829 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbZDFLAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 07:00:40 -0400
Message-ID: <49D9E054.8090502@redhat.com>
Date: Mon, 06 Apr 2009 13:58:28 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com,
       mtosatti@redhat.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
References: <1238855722-32606-1-git-send-email-ieidus@redhat.com> <1238855722-32606-2-git-send-email-ieidus@redhat.com> <1238855722-32606-3-git-send-email-ieidus@redhat.com> <1238855722-32606-4-git-send-email-ieidus@redhat.com> <1238855722-32606-5-git-send-email-ieidus@redhat.com> <20090406091348.GA18464@ports.donpac.ru>
In-Reply-To: <20090406091348.GA18464@ports.donpac.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Panin wrote:
> On 094, 04 04, 2009 at 05:35:22PM +0300, Izik Eidus wrote:
>
> <SNIP>
>
>   
>> +static inline u32 calc_checksum(struct page *page)
>> +{
>> +	u32 checksum;
>> +	void *addr = kmap_atomic(page, KM_USER0);
>> +	checksum = jhash(addr, PAGE_SIZE, 17);
>>     
>
> Why jhash2() is not used here ? It's faster and leads to smaller code size.
>   

Beacuse i didnt know, i will check that and change.

Thanks.

(We should really use in cpu crc for Intel Nehalem, and dirty bit for 
the rest of the architactures...)

>   
>> +	kunmap_atomic(addr, KM_USER0);
>> +	return checksum;
>> +}
>>     
>
>   

