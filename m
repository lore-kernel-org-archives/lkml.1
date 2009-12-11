Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbZLKBMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbZLKBMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762081AbZLKBMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:12:53 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:51984 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760532AbZLKBMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:12:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=N2sRoHN4FDeYLmgOcD9IAPcdmcCwQKrblIyYWayrNaZLU9eaDpfZMEkcT1Z4Ec2Sqx
         WQbl/BlnWfLx0CIo6IY+x1ekriHHRK65/+6+h2SGm0yeOi1yBfEZhxD+v6sqqCQYsYrl
         HMeAL9uCIyaLpOwBNlhUl/D8FXCZntatnSwSU=
MIME-Version: 1.0
In-Reply-To: <20091210170137.8031e4cf.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	 <20091210170137.8031e4cf.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 11 Dec 2009 10:12:57 +0900
Message-ID: <28c262360912101712g1c78396die769fe6a5cc3df82@mail.gmail.com>
Subject: Re: [RFC mm][PATCH 5/5] counting lowmem rss per mm
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 5:01 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> Some case of OOM-Kill is caused by memory shortage in lowmem area. For example,
> NORMAL_ZONE is exhausted on x86-32/HIGHMEM kernel.
>
> Now, oom-killer doesn't have no lowmem usage information of processes and
> selects victim processes based on global memory usage information.
> In bad case, this can cause chains of kills of innocent processes without
> progress, oom-serial-killer.
>
> For making oom-killer lowmem aware, this patch adds counters for accounting
> lowmem usage per process. (patches for oom-killer is not included in this.)
>
> Adding counter is easy but one of concern is the cost for new counter.
>
> Following is the test result of micro-benchmark of parallel page faults.
> Bigger page fault number indicates better scalability.
> (measured under USE_SPLIT_PTLOCKS environemt)
> [Before lowmem counter]
>  Performance counter stats for './multi-fault 2' (5 runs):
>
>       46997471  page-faults                ( +-   0.720% )
>     1004100076  cache-references           ( +-   0.734% )
>      180959964  cache-misses               ( +-   0.374% )
>  29263437363580464  bus-cycles                 ( +-   0.002% )
>
>   60.003315683  seconds time elapsed   ( +-   0.004% )
>
> 3.85 miss/faults
> [After lowmem counter]
>  Performance counter stats for './multi-fault 2' (5 runs):
>
>       45976947  page-faults                ( +-   0.405% )
>      992296954  cache-references           ( +-   0.860% )
>      183961537  cache-misses               ( +-   0.473% )
>  29261902069414016  bus-cycles                 ( +-   0.002% )
>
>   60.001403261  seconds time elapsed   ( +-   0.000% )
>
> 4.0 miss/faults.
>
> Then, small cost is added. But I think this is within reasonable
> range.
>
> If you have good idea for improve this number, it's welcome.
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
