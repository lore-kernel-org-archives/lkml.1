Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbZJNJfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbZJNJfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 05:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbZJNJfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 05:35:10 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:40251 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085AbZJNJfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 05:35:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=N2t4kYlwuPg4QTM475GDp8bnFbitfEi8me+S54cXl+4zr7xwC36rLcdnNuzqc568+g
         AAP3gWq8UA2lAmGNtjdC8Dv2O6RW/+3qU74h3EQ2AFbi8d+aDYaHUZO4dli8lZXpPNI9
         xGmUFg9vnXQ4zPfZAdjjeoSonAvv0tUj8QXhU=
MIME-Version: 1.0
In-Reply-To: <f22d86810910140221q7e03e693kad122a37461cea1d@mail.gmail.com>
References: <f22d86810910132336r1d6f6363qa983b355676dc413@mail.gmail.com>
	 <f22d86810910140221q7e03e693kad122a37461cea1d@mail.gmail.com>
Date: Wed, 14 Oct 2009 02:34:33 -0700
Message-ID: <f22d86810910140234h26e40257ufc29ffa4f00291de@mail.gmail.com>
Subject: Re: How to check whether executing in atomic context?
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 14, 2009 at 2:21 AM, Leonidas . <leonidas137@gmail.com> wrote:
> On Tue, Oct 13, 2009 at 11:36 PM, Leonidas . <leonidas137@gmail.com> wrote:
>> Hi List,
>>
>> I am working on a profiler kind of module, the exported apis of my
>> module can be
>> called from process context and interrupt context as well. Depending on the
>> context I am called in, I need to call sleepable/nonsleepable variants
>> of my internal
>> bookkeeping functions.
>>
>> I am aware of in_interrupt() call which can be used to check current
>> context and take action
>> accordingly.
>>
>> Is there any api which can help figure out whether we are executing
>> while hold a spinlock? I.e
>> an api which can help figure out sleepable/nonsleepable context? If it
>> is not there, what can
>> be done for writing the same? Any pointers will be helpful.
>>
>> -Leo.
>>
>
>  While searching through the sources, I found this,
>
>  97/*
>  98 * Are we running in atomic context?  WARNING: this macro cannot
>  99 * always detect atomic context; in particular, it cannot know about
>  100 * held spinlocks in non-preemptible kernels.  Thus it should not be
>  101 * used in the general case to determine whether sleeping is possible.
>  102 * Do not use in_atomic() in driver code.
>  103 */
>  104#define in_atomic()     ((preempt_count() & ~PREEMPT_ACTIVE) !=
> PREEMPT_INATOMIC_BASE)
>  105
>
> this just complicates the matter, right? This does not work in general
> case but I think this
> will always work if the kernel is preemptible.
>
> Is there no way to write a generic macro?
>
>
> -Leo.
>

Just saw this:

http://thread.gmane.org/gmane.linux.kernel.wireless.general/12716

Looks like, there is no way to figure out that.


-Leo.
