Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbZBDLBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbZBDLBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 06:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZBDLBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 06:01:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:27282 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZBDLBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 06:01:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CLLrHK6LpY2g/zyzf9WW8zgYTaR1LebUwUhOZKeRrq8ZZRv5C6iebNkFBy9GZVQOAP
         loIz+zJnYwockjwdw3gpUcRidRJCNtqtjlv37sKQbrPSKaB+jvS4r6CiNlWlMA/GCZB6
         auIxhEoxaBLXd3B7E+ev7rhwxaN0u9G9JiQ+k=
MIME-Version: 1.0
In-Reply-To: <20090204083524.GJ4456@balbir.in.ibm.com>
References: <20090204170944.c93772d2.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090204083524.GJ4456@balbir.in.ibm.com>
Date: Wed, 4 Feb 2009 13:01:22 +0200
X-Google-Sender-Auth: 816f6348c2dd56aa
Message-ID: <84144f020902040301p138411fam2295c37843515f90@mail.gmail.com>
Subject: Re: [PATCH] use __GFP_NOWARN in page cgroup allocation
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: balbir@linux.vnet.ibm.com
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, heiko.carstens@de.ibm.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 4, 2009 at 10:35 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-04 17:09:44]:
>
>> This was recommended in
>> "kmalloc-return-null-instead-of-link-failure.patch added to -mm tree" thread
>> in the last month.
>> Thanks,
>> -Kame
>> =
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>> page_cgroup's page allocation at init/memory hotplug uses kmalloc() and
>> vmalloc(). If kmalloc() failes, vmalloc() is used.
>>
>> This is because vmalloc() is very limited resource on 32bit systems.
>> We want to use kmalloc() first.
>>
>> But in this kind of call, __GFP_NOWARN should be specified.
>>
>> Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> ---
>> Index: mmotm-2.6.29-Feb03/mm/page_cgroup.c
>> ===================================================================
>> --- mmotm-2.6.29-Feb03.orig/mm/page_cgroup.c
>> +++ mmotm-2.6.29-Feb03/mm/page_cgroup.c
>> @@ -114,7 +114,8 @@ static int __init_refok init_section_pag
>>               nid = page_to_nid(pfn_to_page(pfn));
>>               table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
>>               if (slab_is_available()) {
>> -                     base = kmalloc_node(table_size, GFP_KERNEL, nid);
>> +                     base = kmalloc_node(table_size,
>> +                                     GFP_KERNEL | __GFP_NOWARN, nid);
>
> Thanks for getting to this.
>
>>                       if (!base)
>>                               base = vmalloc_node(table_size, nid);
>>               } else {
>
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Looks good to me as well.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
