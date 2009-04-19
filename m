Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbZDSLjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbZDSLjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 07:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZDSLjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 07:39:21 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:49408 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939AbZDSLjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 07:39:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Gsh819PrihUU9UWe/GjVIaGWEkZENgccwMpd5byjMB8PQFO+YwRrvcCBplg8GQ3ExV
         q8u473gljulxt7tGoTSBmT2DdSkBex1Cnvv+G7Vc6x+YUjBez5gr8o+0DTKdFTjikrX4
         uaz7ZjDaFX3ipYd1nzXGe7sq1Gqg3EcuiOAIc=
MIME-Version: 1.0
In-Reply-To: <2f11576a0904190159t2898edfal858ba12d3460c4e5@mail.gmail.com>
References: <20090418152100.125A.A69D9226@jp.fujitsu.com>
	 <20090418184337.GA5556@cmpxchg.org>
	 <2f11576a0904190159t2898edfal858ba12d3460c4e5@mail.gmail.com>
Date: Sun, 19 Apr 2009 20:34:08 +0900
X-Google-Sender-Auth: 7f6e3562a3afa70c
Message-ID: <2f11576a0904190434y1f897a57qeb22e478dd4d43bd@mail.gmail.com>
Subject: Re: [PATCH for mmotm 0414] vmscan,memcg: reintroduce sc->may_swap
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/19 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
> Hi
>
> Hi
>
>>> @@ -1724,6 +1728,7 @@ unsigned long try_to_free_mem_cgroup_pag
>>>       struct scan_control sc = {
>>>               .may_writepage = !laptop_mode,
>>>               .may_unmap = 1,
>>> +             .may_swap = 1,
>>>               .swap_cluster_max = SWAP_CLUSTER_MAX,
>>>               .swappiness = swappiness,
>>>               .order = 0,
>>> @@ -1734,7 +1739,7 @@ unsigned long try_to_free_mem_cgroup_pag
>>>       struct zonelist *zonelist;
>>>
>>>       if (noswap)
>>> -             sc.may_unmap = 0;
>>> +             sc.may_swap = 0;
>>
>> Can this be directly initialized?
>>
>> struct scan_control sc = {
>>        ...
>>        .may_swap = !noswap,
>>        ...
>> };
>
> your proposal is better coding style. but I also prefer condig style
> consistency.
> I think we should change may_unmap and may_swap at the same time.
> Thus, I'd like to does it by another patch.

Grr, I've misunderstood your comment.
Will fix as your suggestion.
