Return-Path: <linux-kernel-owner+w=401wt.eu-S1751135Ab0ABFVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135Ab0ABFVi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 00:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878Ab0ABFVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 00:21:37 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:32890 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0ABFVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 00:21:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=wWIE71OzG7qaXAE6kTXl8qx9diLDbFEM5G6Lu/p/S27GC50zAUj5H0Eng6PC/+gDyZ
         88lVuOagsKefMQq2WFiX3bpVGo4fxjbuxOMvPV54z7Hvmvwj7dfyIwkRocXTMSPjkD7C
         TpYuZiEztvFhFGarFjYi7eB/G6jFiV09XGTy0=
MIME-Version: 1.0
In-Reply-To: <1262387986.16572.234.camel@laptop>
References: <1262339141-4682-1-git-send-email-kosaki.motohiro@jp.fujitsu.com>
	 <1262387986.16572.234.camel@laptop>
Date: Sat, 2 Jan 2010 14:21:36 +0900
X-Google-Sender-Auth: 7a88f2f72946f9a9
Message-ID: <2f11576a1001012121o4f09d30n6dba925e74099da1@mail.gmail.com>
Subject: Re: [PATCH] mm, lockdep: annotate reclaim context to zone reclaim too
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/2 Peter Zijlstra <peterz@infradead.org>:
> On Fri, 2010-01-01 at 18:45 +0900, KOSAKI Motohiro wrote:
>> Commit cf40bd16fd (lockdep: annotate reclaim context) introduced reclaim
>> context annotation. But it didn't annotate zone reclaim. This patch do it.
>
> And yet you didn't CC anyone involved in that patch, nor explain why you
> think it necessary, massive FAIL.
>
> The lockdep annotations cover all of kswapd() and direct reclaim through
> __alloc_pages_direct_reclaim(). So why would you need an explicit
> annotation in __zone_reclaim()?

Thanks CCing. The point is zone-reclaim doesn't use
__alloc_pages_direct_reclaim.
current call graph is

__alloc_pages_nodemask
    get_page_from_freelist
        zone_reclaim()
    __alloc_pages_slowpath
        __alloc_pages_direct_reclaim
            try_to_free_pages

Actually, if zone_reclaim_mode=1, VM never call
__alloc_pages_direct_reclaim in usual VM pressure.
Thus I think zone-reclaim should be annotated explicitly too.
I know almost user don't use zone reclaim mode. but explicit
annotation doesn't have any demerit, I think.

Am I missing anything?
