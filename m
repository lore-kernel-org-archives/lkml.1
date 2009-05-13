Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbZEMAQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbZEMAQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbZEMAQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:16:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:34216 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756328AbZEMAQN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:16:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hikcPptPRcIYl6oQaJbQkRKHggghhYDcLerPvw3ssY8KKwJHu2pfzpF2e1Mtec7TFg
         7EyGHj7RxrefXmKI+WaEGDoJk7n7607d15crA1/sZbRyq0gkHffsQWczniR/Q4cx87aT
         wQloXC7i1tOslK1B22QRJqkTf5Sz/+3WNA3LQ=
MIME-Version: 1.0
In-Reply-To: <20090512160434.GD6255@nowhere>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
	 <20090512154456.GC6255@nowhere> <20090512160434.GD6255@nowhere>
Date: Wed, 13 May 2009 08:16:14 +0800
Message-ID: <d82e647a0905121716s1b4f8979p27249cfb8250d83c@mail.gmail.com>
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
From: Ming Lei <tom.leiming@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/13 Frederic Weisbecker <fweisbec@gmail.com>:
> On Tue, May 12, 2009 at 05:44:58PM +0200, Frederic Weisbecker wrote:

> Note that async_schedule_atomic is a confusing name.
> At a first glance, it could mean that the scheduled job
> will be run atomically.
>
> I would suggest async_schedule_inatomic() so that it follows the common
> naming pattern in use in the kernel, eg:
>
> - copy_from_user_inatomic()
> - futex_atomic_cmpxchg_inatomic()
>
> and so on.

Agree, I'll fix it in next version.

>
>
>
>> >   * Returns an async_cookie_t that may be used for checkpointing later.
>> > - * Note: This function may be called from atomic or non-atomic contexts.
>> > + * Note:This function may be called from non-atomic contexts,and not
>> > + *         called from atomic contexts with safety. Please use
>> > + *         async_schedule_atomic in atomic contexts.
>
>
> I suggest to add a comment which explains the reason for which it is unsafe
> to call it in atomic context: because the scheduled work might be synchronously
> executed.
>
> One could believe this is because async_schedule() internally uses
> a function which might sleep whereas the actual problem may come
> from the scheduled function.

Agree,add it in next version.

>
> BTW, now that we have an atomic safe version, may be we could
> also adapt the kmalloc GFP flags subsequently?

-- 
Lei Ming
