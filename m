Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbZEMOfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbZEMOfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZEMOfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:35:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:15397 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZEMOfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:35:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=unkTBC0NE1qlO1QzulXprK6kNdVw52TFoN4Y/1DhslsmmvRqBT7/zURvqSOpBhp3TJ
         lsiOnpRgt54fLZDtdRaNLXsojqABykQPpAPQJnO5T/3rgSTpOeiJWYIPJZUYzsVWHmLN
         oSEEuvNMT94ucm1g8szIhyfLmVWUKj/dJhiaU=
MIME-Version: 1.0
In-Reply-To: <20090513153101.3bceb04c@gondolin>
References: <1242174829-4694-1-git-send-email-tom.leiming@gmail.com>
	 <20090513130233.082eeee5@gondolin>
	 <d82e647a0905130556y50620617i8c5ac597b6207406@mail.gmail.com>
	 <20090513153101.3bceb04c@gondolin>
Date: Wed, 13 May 2009 22:27:07 +0800
Message-ID: <d82e647a0905130727o1cdd9d5bg76101d10d579d7d4@mail.gmail.com>
Subject: Re: [PATCH] kernel:async function call:introduce async_run
From: Ming Lei <tom.leiming@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/13 Cornelia Huck <cornelia.huck@de.ibm.com>:
> On Wed, 13 May 2009 20:56:40 +0800,
> Ming Lei <tom.leiming@gmail.com> wrote:
>
>> 2009/5/13 Cornelia Huck <cornelia.huck@de.ibm.com>:
>> > On Wed, 13 May 2009 08:33:49 +0800,
>> > tom.leiming@gmail.com wrote:
>
>> >>  /**
>> >> + * async_run - schedule a function for asynchronous execution
>> >> + * @ptr: function to execute asynchronously
>> >> + * @data: data pointer to pass to the function
>> >> + *
>> >> + * Note:we do not allocate a cookie for this kind of aysnchronous
>> >> + * function to decrease the wait time of async_synchronize_full().
>> >
>> > But async_synchronize_full() still waits for list_empty(&async_running)
>> > - so what does this buy us?
>>
>> I mean it can decrease the wait time for other async function.
>> async_schedule() still can be used to do such thing, but may lead to a
>> slower boot.  It is the main
>> purpose of the patch.
>
> I see how this can affect places calling async_synchronize_cookie(),
> but the function will still end up on async_running. If you don't want
> async_synchronize_full() waiting for these functions, couldn't you use
> your own running list?
>
> (Oh, and I just thought about it a bit further:
> - somebody calls async_run() -> function with cookie = MAX_COOKIE will be
>  lowest_in_progress at some point in time
> - somebody else calls async_schedule() -> cookie = n
> - we wait with async_synchronize_cookie(n) - which returns since
>  MAX_COOKIE >= n, which is probably not what we want)
>
yes , you are right, I'll think about it.



-- 
Lei Ming
