Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbZEGCEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbZEGCEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbZEGCE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:04:27 -0400
Received: from mail-qy0-f125.google.com ([209.85.221.125]:58637 "EHLO
	mail-qy0-f125.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZEGCE0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lyh4IiTw6zimeBXlEcRucKO/23eyCvFKVLHoklTvosbE5aiq+KsOVa+v3toVcSuwk3
         Ag19KrlD+XmVH15ozETvfqgtlsqWpIwH6dyUJzXnLcrRSRtPudvb4fqUjofaJ9tMEMUC
         EWfTu/Jz8hJQCtR95iiBBmpiZP7sjlAnrdpY0=
MIME-Version: 1.0
In-Reply-To: <d6200be20905061844q8a4945y83daa86b336dc49a@mail.gmail.com>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com> 
	<87y6tb3x6r.fsf@deeprootsystems.com> <871vr22upr.fsf@deeprootsystems.com> 
	<200905062318.23572.rjw@sisk.pl> <87zldpu5rt.fsf@deeprootsystems.com> 
	<d6200be20905061818h58145d5fie5c55ceaf900a196@mail.gmail.com> 
	<4d34a0a70905061828l3e35a954k76967b30c1a241ab@mail.gmail.com> 
	<d6200be20905061844q8a4945y83daa86b336dc49a@mail.gmail.com>
From: Kim Kyuwon <chammoru@gmail.com>
Date: Thu, 7 May 2009 11:04:06 +0900
Message-ID: <4d34a0a70905061904w338457efna8a3cbb80537e0c9@mail.gmail.com>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, OMAP <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/7 Arve Hjønnevåg <arve@android.com>:
> 2009/5/6 Kim Kyuwon <chammoru@gmail.com>:
>> 2009/5/7 Arve Hjønnevåg <arve@android.com>:
>>> On Wed, May 6, 2009 at 5:16 PM, Kevin Hilman
>>> <khilman@deeprootsystems.com> wrote:
>>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>>>
>>>>> On Wednesday 06 May 2009, Kevin Hilman wrote:
>>>>>> Kevin Hilman <khilman@deeprootsystems.com> writes:
>>>
>>>> There is at least one problem with that which is why Kyuwon Kim added
>>>> the ->disable hook to OMAP's irq_chip.  The problem is with drivers
>>>> that call disable_irq() in their suspend hook, usually done to prevent
>>>> the device from waking the system since on OMAP, any IRQ can be
>>>> configured to wake the system.
>>>>
>>>
>>> This does not sound correct. disable_irq_wake should be used for this.
>>> A driver may need to mask its interrupt before suspending but this
>>> should not also disable it as a wakeup source.
>>
>> I wish I could use disable_irq_wake(), but it doesn't work in OMAP.
>
> This does not sound like a hardware problem.

We may need advices of TI engineers.
However, as far as I know, It is impossible to disable 'interrupt
wake-up' with interrupt enabled. Because an interrupt itself generate
a system wake-up event in OMAP3430 (Hardware level).
-- 
Kyuwon

> --
> Arve Hjønnevåg
