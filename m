Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbYFYG5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbYFYG5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 02:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbYFYG44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 02:56:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:53308 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYFYG4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 02:56:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZdUWXcX+V191Ppthm95HL61aFtsxav4fsGjsnjkweuhatJmCvdp5dhjkSHXnvC2+hD
         iNXel/M5M37BrQEnclfC5GsIeAgGsWjRK+zyd1HBytV0XtmpkZU+WXG1WFGuYCrY8l8A
         TzLn3cVh1zhT9NkXNg+ddOWS8ChYHgA9/1gXc=
Message-ID: <28c262360806242356n3f7e02abwfee1f6acf0fd2c61@mail.gmail.com>
Date: Wed, 25 Jun 2008 15:56:54 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] prevent incorrect oom under split_lru
Cc: "Rik van Riel" <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, akpm@linux-foundation.org,
       "Takenori Nagano" <t-nagano@ah.jp.nec.com>
In-Reply-To: <20080625150141.D845.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080624092824.4f0440ca@bree.surriel.com>
	 <28c262360806242259k3ac308c4n7cee29b72456e95b@mail.gmail.com>
	 <20080625150141.D845.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 3:08 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi Kim-san,
>
>> >> So, if priority==0, We should try to reclaim all page for prevent OOM.
>> >
>> > You are absolutely right.  Good catch.
>>
>> I have a concern about application latency.
>> If lru list have many pages, it take a very long time to scan pages.
>> More system have many ram, More many time to scan pages.
>
> No problem.
>
> priority==0 indicate emergency.
> it doesn't happend on typical workload.
>

I see :)

But if such emergency happen in embedded system, application can't be
executed for some time.
I am not sure how long time it take.
But In some application, schedule period is very important than memory
reclaim latency.

Now, In your patch, when such emergency happen, it continue to reclaim
page until it will scan entire page of lru list.
It

>> Of course I know this is trade-off between memory efficiency VS latency.
>> But In embedded, some application think latency is more important
>> thing than memory efficiency.
>> We need some mechanism to cut off scanning time.
>>
>> I think Takenori Nagano's "memory reclaim more efficiently patch" is
>> proper to reduce application latency in this case If we modify some
>> code.
>
> I think this is off-topic.
>
> but Yes.
> both my page reclaim throttle and nagano-san's patch provide
> reclaim cut off mechanism.
>
>
> and more off-topic,
> nagano-san's patch improve only priority==12.
> So, typical embedded doesn't improve so big because
> embedded system does't have so large memory.
>
>
>
>



-- 
Kinds regards,
MinChan Kim
