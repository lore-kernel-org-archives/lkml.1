Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYFZEhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYFZEhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 00:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYFZEhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 00:37:31 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:43175 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYFZEha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 00:37:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nVHzRjhxEC1JXBrOFyz3FHiK8CO/xQ4PkmfOo6rhdrjxE+2kmUIPjhNSojHa9aOMXB
         g2zNEmqctbrkAf7/7kKGd+/9vU+sHxLmwvlwyb7wh1jlrD7d3XbohrWCulWH4IPI8O4g
         z37E4vyUE5YILp9xTQclsaQpdZLr0p22nHfuQ=
Message-ID: <28c262360806252137j78a90480n6c3973cd489c1ef2@mail.gmail.com>
Date: Thu, 26 Jun 2008 13:37:29 +0900
From: "MinChan Kim" <minchan.kim@gmail.com>
To: "Takenori Nagano" <t-nagano@ah.jp.nec.com>
Subject: Re: [RFC][PATCH] prevent incorrect oom under split_lru
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Rik van Riel" <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, akpm@linux-foundation.org
In-Reply-To: <4862F5BB.9030200@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080624092824.4f0440ca@bree.surriel.com>
	 <28c262360806242259k3ac308c4n7cee29b72456e95b@mail.gmail.com>
	 <20080625150141.D845.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <28c262360806242356n3f7e02abwfee1f6acf0fd2c61@mail.gmail.com>
	 <1214395885.15232.17.camel@twins>
	 <28c262360806250605le31ba48ma8bb16f996783142@mail.gmail.com>
	 <4862F5BB.9030200@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 10:49 AM, Takenori Nagano
<t-nagano@ah.jp.nec.com> wrote:
> MinChan Kim wrote:
>> Hi peter,
>>
>> I agree with you.  but if application's virtual address space is big,
>> we have a hard problem with mlockall since memory pressure might be a
>> big.
>> Of course, It will be a RT application design problem.
>>
>>> The much more important case is desktop usage - that is where we run non
>>> real-time code, but do expect 'low' latency due to user-interaction.
>>>
>>> >From hitting swap on my 512M laptop (rather frequent occurance) I know
>>> we can do better here,..
>>>
>>
>> Absolutely. It is another example. So, I suggest following patch.
>> It's based on idea of Takenori Nagano's memory reclaim more efficiently.
>
> Hi Kim-san,
>
> Thank you for agreeing with me.
>
> I have one question.
> My patch don't mind priority. Why do you need "priority == 0"?

Hi, Takenori-san.

Now, Kosaiki-san's patch didn't consider application latency.
That patch scan all lru[x] pages when memory pressure is very high.
(ie, priority == 0)
It will cause application latency to high as peter and me notice that.
We need a idea which prevent big scanning overhead
I modified your idea to prevent big scanning overhead only when memory
pressure is very big.


> Thanks,
>  Takenori
>



-- 
Kinds regards,
MinChan Kim
