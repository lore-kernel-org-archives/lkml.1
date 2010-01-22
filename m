Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554Ab0AVPll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0AVPll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341Ab0AVPlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:41:40 -0500
Received: from mail-pz0-f179.google.com ([209.85.222.179]:44870 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab0AVPlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:41:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N7Ey7YX/6gNGl58mfSooZshfUAezSN/npLkgHEUIuqQqaaD+gABg0vhJun4psBEkh6
         oEPeaePg4doX+ybObgHLixIddQaa534GLEjED/oQKgxma8h3lITzFbyHbzKL+zcoRMfR
         1B7EHmqn/KvATBa4n1aJbtMX0MUo43pdMNy78=
MIME-Version: 1.0
In-Reply-To: <ea36dc1ede8240f85a69215be964c61a.squirrel@webmail-b.css.fujitsu.com>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	 <1264168844.2789.4.camel@barrios-desktop>
	 <ea36dc1ede8240f85a69215be964c61a.squirrel@webmail-b.css.fujitsu.com>
Date: Sat, 23 Jan 2010 00:41:39 +0900
Message-ID: <28c262361001220741n426c52a3t371aeabe89c154c7@mail.gmail.com>
Subject: Re: [PATCH v2] oom-kill: add lowmem usage aware oom kill handling
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       rientjes@google.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/23 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
>> <snip>
>>> @@ -475,7 +511,7 @@ void mem_cgroup_out_of_memory(struct mem
>>>
>>>      read_lock(&tasklist_lock);
>>>  retry:
>>> -    p = select_bad_process(&points, mem);
>>> +    p = select_bad_process(&points, mem, CONSTRAINT_NONE);
>>
>> Why do you fix this with only CONSTRAINT_NONE?
>> I think we can know CONSTRAINT_LOWMEM with gfp_mask in here.
>>
> memcg is just for accounting anon/file pages. Then, it's never
> cause lowmem oom problem (any memory is ok for memcg).

Okay. Thanks for the explanation.
-- 
Kind regards,
Minchan Kim
