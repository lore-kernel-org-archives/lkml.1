Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbZJVLne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbZJVLne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 07:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbZJVLne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 07:43:34 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:51849 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbZJVLnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 07:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qV2pi6seBSuVnzPpTaLgQQbzhT9XXSCshMfJZ/RVK8FHpsW5QWiIeACObjFeww5Wkc
         Kuo5v6r5JNjKHPvwuEethtLSSWx3ver0Ny6DTKRfJqAHjCs5GW8vlK/4slCxrAy55i2t
         OKe5bnrDPbbANzbLpRi3NOjI2DdhRm0PNtjsM=
MIME-Version: 1.0
In-Reply-To: <20091022112746.GA4928@nowhere>
References: <f22d86810910220410r33002b5ei403ddf6632254472@mail.gmail.com>
	 <20091022112746.GA4928@nowhere>
Date: Thu, 22 Oct 2009 04:43:38 -0700
Message-ID: <f22d86810910220443u49cdfabg83ef836406cfb36d@mail.gmail.com>
Subject: Re: Can current macro be accessed from interrupt context?
From: "Leonidas ." <leonidas137@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 4:27 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, Oct 22, 2009 at 04:10:49AM -0700, Leonidas . wrote:
>> Hello,
>>
>> Going through UTLK, it says that current macro makes sense only in
>> case of process context,
>> in case of interrupt context it is invalid.
>
>
> Indeed, usually it makes only sense in process context.
>
>
>> But current would still be pointing to interrupted process right? The
>> pointer would still be valid?
>
>
>
> Yeah, unless you irq handler executes in a threaded interrupt, in
> which case current will be pointing to the given irq thread.

Threaded interrupt handlers? I am sorry, I am new to kernel development
and not fully aware of the intricacies. Do you mean bottom half handlers here?

> There are few tiny cases where it is unsafe to deref "current",
> such as the very beginning of a cpu's awakening, when the per cpu
> datas are not yet ready for this cpu.
>

Okay, I guess, in my case this would not be a problem then since this is about
early init.

>> Can I safely assume that whether or not interrupt handlers are
>> executing on separate stacks or
>> interrupted threads stack, current macro can be accessed from interrupt context?
>
>
> Yep.
> For example we do that in the function graph tracer. Because we store return
> addresses of functions in the "current" task structure. Even if the task
> is interrupted, it still makes sense to use current because we want
> to know the flow of execution as a linear thing per cpu, the interrupt
> is part of that flow
>
> I hope that helps.
>

Can you give pointers to the source code of this project?

> Frederic.
>
>


-Leo.
