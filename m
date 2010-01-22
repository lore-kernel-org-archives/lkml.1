Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305Ab0AVPQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab0AVPQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882Ab0AVPQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:16:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44471 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0AVPQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:16:44 -0500
Message-ID: <ea36dc1ede8240f85a69215be964c61a.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <1264168844.2789.4.camel@barrios-desktop>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
    <20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
    <1264168844.2789.4.camel@barrios-desktop>
Date: Sat, 23 Jan 2010 00:16:40 +0900 (JST)
Subject: Re: [PATCH v2] oom-kill: add lowmem usage aware oom kill handling
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Minchan Kim" <minchan.kim@gmail.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       rientjes@google.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim wrote:
> On Fri, 2010-01-22 at 15:23 +0900, KAMEZAWA Hiroyuki wrote:
>> updated. thank you for review.

>>  	CONSTRAINT_MEMORY_POLICY,
>>  };
>
> <snip>
>> @@ -475,7 +511,7 @@ void mem_cgroup_out_of_memory(struct mem
>>
>>  	read_lock(&tasklist_lock);
>>  retry:
>> -	p = select_bad_process(&points, mem);
>> +	p = select_bad_process(&points, mem, CONSTRAINT_NONE);
>
> Why do you fix this with only CONSTRAINT_NONE?
> I think we can know CONSTRAINT_LOWMEM with gfp_mask in here.
>
memcg is just for accounting anon/file pages. Then, it's never
cause lowmem oom problem (any memory is ok for memcg).



> Any problem?
>
> Otherwise, Looks good to me. :)
>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>
Thank you.

-Kame

> --
> Kind regards,
> Minchan Kim
>
>


