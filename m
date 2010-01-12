Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825Ab0ALOql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab0ALOql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 09:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477Ab0ALOql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 09:46:41 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:55735 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab0ALOqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 09:46:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Z+QYp3FRLQYhLj3NHYUoFMOvUByLMPUD8OjlPhtFQ35kOV2Qd/ubkS6Nz9E/tjGC83
         RyI0H8xR18ssVWgmy2OEhpdEEXQlk3UK/Nhn2Ro6hcGQrisux4bKVMwBMzPSvL2EKZvU
         2ua9xq4Ut3uPmgShN/0P3x4Tgi/dXG0y0h6MA=
MIME-Version: 1.0
In-Reply-To: <20100112141330.B3A6.A69D9226@jp.fujitsu.com>
References: <20100112141330.B3A6.A69D9226@jp.fujitsu.com>
Date: Tue, 12 Jan 2010 23:46:38 +0900
Message-ID: <28c262361001120646y6f3603b8q236d0a7c02250ffa@mail.gmail.com>
Subject: Re: [resend][PATCH] mm, lockdep: annotate reclaim context to zone 
	reclaim too
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 2:16 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> Commit cf40bd16fd (lockdep: annotate reclaim context) introduced reclaim
> context annotation. But it didn't annotate zone reclaim. This patch do it.
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

I think your good explanation in previous thread is good for
changelog. so I readd in here.
If you mind this, feel free to discard.
I don't care about it. :)

---

<kosaki.motohiro@jp.fujitsu.com> wrote:
The point is zone-reclaim doesn't use
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

-- 
Kind regards,
Minchan Kim
