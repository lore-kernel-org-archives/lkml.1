Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbZLZNnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbZLZNnq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 08:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZLZNnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 08:43:45 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:48973 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbZLZNnp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 08:43:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IHm1pXrBicFtJXGAVRRrGg4gv2xPpB+91vKZMT4vuDrfx+6yaJTtQkYnBke/KJDIA6
         fjbrG+7y53A3oN2JOgJYq6okjC2S4R2zRVJ4ovZcje41380Zlgcq8t37oE5X+THuDDwb
         4cWV6QTLFLbjeytfuU0gNFI9XHR0rk7YG65A4=
MIME-Version: 1.0
In-Reply-To: <1261041885.27920.110.camel@laptop>
References: <1260934105-4472-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1260934105-4472-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1261041885.27920.110.camel@laptop>
Date: Sat, 26 Dec 2009 22:43:44 +0900
X-Google-Sender-Auth: 4d4e57d458254d7a
Message-ID: <a6b9f31a0912260543g62785a58w6432f546c2fa6488@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf lock: Fix output of tracing lock events
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for my slow response...

>> diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
>> index a870ba1..2f94e25 100644
>> --- a/include/trace/events/lock.h
>> +++ b/include/trace/events/lock.h
>> @@ -18,16 +18,19 @@ TRACE_EVENT(lock_acquire,
>>       TP_ARGS(lock, subclass, trylock, read, check, next_lock, ip),
>>
>>       TP_STRUCT__entry(
>> +             __field(struct lockdep_map *, lockdep_addr)
>>               __field(unsigned int, flags)
>>               __string(name, lock->name)
>>       ),
>
> I feel a bit awkward explicitly leaking kernel pointers like that. All
> this is accessible by root only (for now) so its not too harmfull, but
> sitll.
>
> Also, I don't think we want to expose the struct lockdep_map thing, a
> regular void * would be better.

Yeah, I agree with it. void * is enough.

>
> As to removing the waittime, I'm not sure, in this case, yes, but if you
> want some other processing that hooks straight into the tracepoints
> instead of using a logging structure, it might be useful.
>
> Removing that do_div() from there and exposing waittime as u64 in nsec,
> for sure, that do_div() is just silly.
>
>
>

I was too egoist. perf lock is not an only one user of lock events.

And I have a suggestion. Adding name of source files and lines of
lock instances may be good thing for human's readability.
How do you think?

I have some pending works for these (not made into patches).
If you agree, I'll send these later.
