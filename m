Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbZERBza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbZERBza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 21:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZERBzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 21:55:14 -0400
Received: from mail-pz0-f115.google.com ([209.85.222.115]:34781 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZERBzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 21:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sSu3+KypzG87XZZmgmzNw8ZYp6f8Tq/26ylDIEobyoy9mTXYNDmKGThfr/Wp4Gvas6
         qZACQhNINvTl09Z6w2X0UA3VK3T8Ej/NDRQ1ZEs5FhEHDHZuHDFpyChQml0QWKD5LOX7
         KXObTP9xaw4yz+PrkAZvFihA6syOruKNYwtGo=
MIME-Version: 1.0
In-Reply-To: <20090517132613.688da272@infradead.org>
References: <1242141222-8454-1-git-send-email-tom.leiming@gmail.com>
	 <20090517132613.688da272@infradead.org>
Date: Mon, 18 May 2009 09:55:14 +0800
Message-ID: <d82e647a0905171855x79850a5bv7262f9e698d8b3f7@mail.gmail.com>
Subject: Re: [PATCH] kernel/async.c:introduce async_schedule*_atomic
From: Ming Lei <tom.leiming@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/18 Arjan van de Ven <arjan@infradead.org>:
> On Tue, 12 May 2009 23:13:42 +0800
> tom.leiming@gmail.com wrote:
>
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> The async_schedule* may not be called in atomic contexts if out of
>> memory or if there's too much work pending already, because the
>> async function to be called may sleep.
>>
>> This patch fixes the comment of async_schedule*, and introduces
>> async_schedules*_atomic to allow them called from atomic contexts
>> safely.
>
> (sorry for the late response; have been away from most of my email for
> a few days)
>
> I like the general idea; I was hoping to do it a little bit different
> though, API wise.
> I don't mind the parameter for "don't do blocking things" (we should
> use that to also use GFP_KERNEL/GFP_NOFS or whatever for the
> allocation), it makes sense.
>
> What I would like to see is the option to pass in memory that was
> externally kmalloc'd. So that you can do
>
> foo = kmalloc(..)
> spin_lock(bar)
> ...
> async_schedule_atomic(...);
>
> spin_unlock(bar);
> if (not_used_foo)
>    kfree(foo);
>
> in cases where you don't want to fail while in the atomic portion,
> but can fail better earlier.

If we do this way, the type of async_schedule*()  and async_schedule*_inatomic()
is different, and callers will be messed with them, especially for _inatomic().

BTW: I have submited new version of this patches, would you mind
giving a review?

Thanks.

-- 
Lei Ming
