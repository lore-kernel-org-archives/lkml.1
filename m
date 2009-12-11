Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbZLKDnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbZLKDnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 22:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbZLKDnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 22:43:45 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:51769 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZLKDno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 22:43:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FdvHikNhtcI/wrRXWdtXnOumQ4bsplYX4KK/KKqBmbwX6dX18O2ZWOiuU3hmf0yhHQ
         IV2kqs6kqxZXr4LsBlX8fiM/kM9CPfuOcYDgmtQDXSHTJulXmEtFv812gjFNRrJYia8+
         t5XFou3fR+FvRVtByCubTW+ak76+juxP/Lb9E=
MIME-Version: 1.0
In-Reply-To: <4B21BA54.1090103@redhat.com>
References: <20091210185626.26f9828a@cuia.bos.redhat.com>
	 <28c262360912101803i7b43db78se8cf9ec61d92ee0f@mail.gmail.com>
	 <4B21BA54.1090103@redhat.com>
Date: Fri, 11 Dec 2009 12:43:50 +0900
Message-ID: <28c262360912101943l49580d9chb19a00af246f5adb@mail.gmail.com>
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: lwoodman@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 12:19 PM, Rik van Riel <riel@redhat.com> wrote:
> On 12/10/2009 09:03 PM, Minchan Kim wrote:
>
>>> +The default value is 8.
>>> +
>>> +=============================================================
>>
>> I like this. but why do you select default value as constant 8?
>> Do you have any reason?
>>
>> I think it would be better to select the number proportional to NR_CPU.
>> ex) NR_CPU * 2 or something.
>>
>> Otherwise looks good to me.
>
> Pessimistically, I assume that the pageout code spends maybe
> 10% of its time on locking (we have seen far, far worse than
> this with thousands of processes in the pageout code).  That
> means if we have more than 10 threads in the pageout code,
> we could end up spending more time on locking and less doing
> real work - slowing everybody down.

Thanks for giving precious information to me. :

We always have a question magic value with no comment.

Actually I don't want to add another magic value without comment.
so I would like to add the your good explanation in change log
or as comment on code.

>
> I rounded it down to the closest power of 2 to come up with
> an arbitrary number that looked safe :)
>
> However, this number is per zone - I imagine that really large
> systems will have multiple memory zones, so they can run with
> more than 8 processes in the pageout code simultaneously.
>
>> Reviewed-by: Minchan Kim<minchan.kim@gmail.com>
>
> Thank you.

Thanks for quick reply. :)

> --
> All rights reversed.
>



-- 
Kind regards,
Minchan Kim
