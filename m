Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYJ2Ixh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYJ2Ixh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 04:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYJ2Ix2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 04:53:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9047 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYJ2Ix1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 04:53:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=pEIgEWp4csK+/wWmx4wwe9tb9JShdJLZEXtW3VktDEYTs4kxrpdweeK3XiiVNxdRi
	5xEdmGagHi5jPcYE58tfA==
Message-ID: <2846be6b0810290153rf4bf181ta07df64940f7aaca@mail.gmail.com>
Date: Wed, 29 Oct 2008 01:53:20 -0700
From: "Naveen Gupta" <ngupta@google.com>
To: "Aaron Carroll" <aaronc@gelato.unsw.edu.au>
Subject: Re: [PATCH] Priorities in Anticipatory I/O scheduler
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org, s-uchida@ap.jp.nec.com, david@fromorbit.com
In-Reply-To: <4907C4D8.2090307@gelato.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081027190131.070061000@elf.corp.google.com>
	 <20081028002024.GM4985@disturbed>
	 <2846be6b0810281014q495cef22mae344423ed59c71a@mail.gmail.com>
	 <20081028214443.GX4985@disturbed>
	 <2846be6b0810281548oc81fbe4td2e1a5e2fba18745@mail.gmail.com>
	 <20081028233101.GD17077@disturbed>
	 <2846be6b0810281704r5092c415n3fea9c849c6086ca@mail.gmail.com>
	 <4907AEE7.5030508@gelato.unsw.edu.au>
	 <2846be6b0810281817x70ea8d4ev378f4893aaf1f61e@mail.gmail.com>
	 <4907C4D8.2090307@gelato.unsw.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/28 Aaron Carroll <aaronc@gelato.unsw.edu.au>:
> Naveen Gupta wrote:
>> 2008/10/28 Aaron Carroll <aaronc@gelato.unsw.edu.au>:
>>> Naveen Gupta wrote:
>>>> As I said earlier the organization of the AS levels is flat, so we
>>>> could use any class (RT, BE, LATENCY) and fold the remaining ones. The
>>>> other way which you would probably like is to increase number of
>>>> levels and map different classes so that they are not folded.
>>> As I said in my reply to the initial posting of this, I think there are
>>> only two sensible ways of handling this:
>>>
>>>  1) Maintain the full number of I/O priorities (1 IDLE, 8 BE, 8 RT);
>>
>> But then we are assuming that we are providing different quality of
>> service according to classes.
>
> Right.  The ideal solution is a scheduler-independent definition of
> RT (Jens?) which you can apply here.  However, it seems to me that you
> want to basically ignore RT and IDLE. If you're going to do that, at
> least implement sane alternate behaviour.
>
> This solution applies the the principle of least surprise; RT requests
> always have higher priority than BE requests, and within the class,
> higher level means higher priority.  In your implementation, BE 0 == RT x
> and IDLE == BE 7.  This is surprising behaviour.

Aaron, I took care of these in reply to Dave's email.

>
>>>  2) Collapse the levels and only deal with the classes;
>>
>> I am not sure if this is meaningful. When all we have is different
>> levels of BE, it wouldn't make sense to call them different classes.
>
> It's not meaningful as it stands.  This difference here is that you
> at least maintain the ordering of the classes with respect to priority.

I am not sure that giving one level to each class would be an
acceptable solution.

>
>
>           -- Aaron
>
>
>
