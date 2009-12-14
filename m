Return-Path: <linux-kernel-owner+w=401wt.eu-S1750791AbZLNFBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750791AbZLNFBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbZLNFBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:01:00 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:56385 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZLNFA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:00:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pPTE2aEA4aaI01Eiu7BEb53mWn0maPf8OOH0cD7YF+UD5bPQyvq2J5dfwPSlkY35Uq
         /RrqQGEvQTd/aKU/y8gKkGq4LG1hM2zim3njtDKt4rI1ZS3gGohO8X6LZoHYuIv+4RSy
         VeJSl1/E0+48Vgg6tvK9LmWeV/8bZTqrTKYgk=
MIME-Version: 1.0
In-Reply-To: <4B25BF39.5020401@redhat.com>
References: <20091211164651.036f5340@annuminas.surriel.com>
	 <28c262360912131614h62d8e0f7qf6ea9ab882f446d4@mail.gmail.com>
	 <4B25BA6E.5010002@redhat.com>
	 <28c262360912132019u7c0b8efpf89b11a6cbe512b3@mail.gmail.com>
	 <4B25BF39.5020401@redhat.com>
Date: Mon, 14 Dec 2009 14:00:57 +0900
Message-ID: <28c262360912132100u689118fob4b72c40a1393846@mail.gmail.com>
Subject: Re: [PATCH v2] vmscan: limit concurrent reclaimers in shrink_zone
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: lwoodman@redhat.com, akpm@linux-foundation.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 1:29 PM, Rik van Riel <riel@redhat.com> wrote:
> On 12/13/2009 11:19 PM, Minchan Kim wrote:
>>
>> On Mon, Dec 14, 2009 at 1:09 PM, Rik van Riel<riel@redhat.com>  wrote:
>
>>> A simpler solution may be to use sleep_on_interruptible, and
>>> simply have the process continue into shrink_zone() if it
>>> gets a signal.
>>
>> I thought it but I was not sure.
>> Okay. If it is possible, It' more simple.
>> Could you repost patch with that?
>
> Sure, not a problem.
>
>>         +The default value is 8.
>>         +
>>         +=============================================================
>>
>>
>>     I like this. but why do you select default value as constant 8?
>>     Do you have any reason?
>>
>>     I think it would be better to select the number proportional to
>> NR_CPU.
>>     ex) NR_CPU * 2 or something.
>>
>>     Otherwise looks good to me.
>>
>>
>> Pessimistically, I assume that the pageout code spends maybe
>> 10% of its time on locking (we have seen far, far worse than
>> this with thousands of processes in the pageout code).  That
>> means if we have more than 10 threads in the pageout code,
>> we could end up spending more time on locking and less doing
>> real work - slowing everybody down.
>>
>> I rounded it down to the closest power of 2 to come up with
>> an arbitrary number that looked safe :)
>> ===
>>
>> We discussed above.
>> I want to add your desciption into changelog.
>
> The thing is, I don't know if 8 is the best value for
> the default, which is a reason I made it tunable in
> the first place.
>
> There are a lot of assumptions in my reasoning, and
> they may be wrong.  I suspect that documenting something
> wrong is probably worse than letting people wonder out
> the default (and maybe finding a better one).

Indeed. But whenever I see magic values in kernel, I have a question
about that.
Actually I used to doubt the value because I guess
"that value was determined by server or desktop experiments.
so probably it don't proper small system."
At least if we put the logical why which might be wrong,
later people can think that value is not proper any more now or his
system(ex, small or super computer and so on) by based on our
description.
so they can improve it.

I think it isn't important your reasoning is right or wrong.
Most important thing is which logical reason determines that value.

I want to not bother you if you mind my suggestion.
Pz, think it was just nitpick. :)


> --
> All rights reversed.
>



-- 
Kind regards,
Minchan Kim
