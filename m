Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab0AORXS (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 12:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818Ab0AORXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 12:23:17 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:40853 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab0AORXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 12:23:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Z/lP+YqfxfTQnlvcoSPaSpk48XStvLzWCnxEKFr8e7HCrPmOjPOJPiZXrqDKKNa0rP
         7uMWjpsDRqhEzn0P2WKJT9o2KO+yyE20nCTX7B8Fp/ZeeAZv1/1IPjBd608rqAiDONt5
         nHJIclJXMvVETRdhx3mNiXEpB174iVFc83zMg=
MIME-Version: 1.0
In-Reply-To: <20100114141735.672B.A69D9226@jp.fujitsu.com>
References: <20100114084659.D713.A69D9226@jp.fujitsu.com>
	 <28c262361001132112i7f50fd66qcd24dc2ddb4d78d8@mail.gmail.com>
	 <20100114141735.672B.A69D9226@jp.fujitsu.com>
Date: Sat, 16 Jan 2010 02:23:16 +0900
Message-ID: <28c262361001150923l138f6805t22546887bf81b283@mail.gmail.com>
Subject: Re: [PATCH 2/3][v2] vmstat: add anon_scan_ratio field to zoneinfo
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, KOSAKI.

On Thu, Jan 14, 2010 at 2:18 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > Well. zone->lock and zone->lru_lock should be not taked at the same time.
>>
>> I looked over the code since I am out of office.
>> I can't find any locking problem zone->lock and zone->lru_lock.
>> Do you know any locking order problem?
>> Could you explain it with call graph if you don't mind?
>>
>> I am out of office by tomorrow so I can't reply quickly.
>> Sorry for late reponse.
>
> This is not lock order issue. both zone->lock and zone->lru_lock are
> hotpath lock. then, same tame grabbing might cause performance impact.

Sorry for late response.

Your patch makes get_anon_scan_ratio of zoneinfo stale.
What you said about performance impact is effective when VM pressure high.
I think stale data is all right normally.
But when VM pressure is high and we want to see the information in zoneinfo(
this case is what you said), stale data is not a good, I think.

If it's not a strong argue, I want to use old get_scan_ratio
in get_anon_scan_ratio.

-- 
Kind regards,
Minchan Kim
