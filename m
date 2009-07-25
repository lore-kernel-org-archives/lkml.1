Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbZGYNVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbZGYNVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 09:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZGYNVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 09:21:31 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:34240 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbZGYNVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 09:21:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GQt9yyMKZ6gYgr8aiEUpxIazGhaCagxIVgfYsuosngzQp7KX4GSMAq0HQC7f3IC74V
         Mm6EkA/ALFQZk9HClJlsAJUxlXUxTX3VWPWtKoB1LbhG37A4+RYTNDN7RpSHqJLOeRZy
         EIrtSwPwm8rc/ALLQ5+CTXIUtu1wR2K1J8Ff0=
MIME-Version: 1.0
In-Reply-To: <9443f91bd4648e6214b32acff4512b97.squirrel@webmail-b.css.fujitsu.com>
References: <20090715182320.39B5.A69D9226@jp.fujitsu.com>
	 <1247679064.4089.26.camel@useless.americas.hpqcorp.net>
	 <alpine.DEB.2.00.0907161257190.31844@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0907241551070.8573@chino.kir.corp.google.com>
	 <20090724160936.a3b8ad29.akpm@linux-foundation.org>
	 <337c5d83954b38b14a17f0adf4d357d8.squirrel@webmail-b.css.fujitsu.com>
	 <5bb65c0e4c6828b1331d33745f34d9ee.squirrel@webmail-b.css.fujitsu.com>
	 <9443f91bd4648e6214b32acff4512b97.squirrel@webmail-b.css.fujitsu.com>
Date: Sat, 25 Jul 2009 22:21:29 +0900
X-Google-Sender-Auth: 7b6f14309a9db27d
Message-ID: <2f11576a0907250621w3696fdc0pe61638c8c935c981@mail.gmail.com>
Subject: Re: [BUG] set_mempolicy(MPOL_INTERLEAV) cause kernel panic
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, lee.schermerhorn@hp.com,
       miaox@cn.fujitsu.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       cl@linux-foundation.org, menage@google.com, nickpiggin@yahoo.com.au,
       y-goto@jp.fujitsu.com, penberg@cs.helsinki.fi, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/07/25 12:15 に KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> さんは書きました:
> KAMEZAWA Hiroyuki wrote:
>> KAMEZAWA Hiroyuki wrote:
>> Then, here is a much easier fix. for trusting cpuset more.
>>
> just a memo about memory hotplug
>
> _Direct_ use of task->mems_allowed is only in cpuset and mempolicy.
> If no policy is used, it's not checked.
> (See alloc_pages_current())
>
> memory hotplug's notifier just updates top_cpuset's mems_allowed.
> But it doesn't update each task's ones.
> Then, task's bahavior is
>
>  - tasks which don't use mempolicy will use all nodes, N_HIGH_MEMORY.
>  - tasks under cpuset will be controlled under their own cpuset.
>  - tasks under mempolicy will use their own policy.
>   but no new policy is re-calculated and, then, no new mask.
>
> Now, even if all memory on nodes a removed, pgdat just remains.
> Then, cpuset/mempolicy will never access NODE_DATA(nid) which is NULL.

Umm..
I don't think this is optimal behavior. but if hotplug guys agree
this, I agree this too.

Thanks.
