Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbZEGB2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbZEGB2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 21:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZEGB2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 21:28:19 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:7485 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbZEGB2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 21:28:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=taWY7j5ad1AwsYASSCWVhFCGLCaLKmnDoGr2/6BMpvx5A5OGQ/gwrv3D4kTDnSxUIw
         EW+RlxUCvz/VDApgA14MhKgB8B0vsFyBpOme3gMMN6PU9L4zKyS6eBuEEzCrapqLiLqr
         d7vjirrTaVNo6AC+GjRL19+9GA+/MYC4UPJ4Q=
MIME-Version: 1.0
In-Reply-To: <d6200be20905061818h58145d5fie5c55ceaf900a196@mail.gmail.com>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	 <87y6tb3x6r.fsf@deeprootsystems.com>
	 <871vr22upr.fsf@deeprootsystems.com> <200905062318.23572.rjw@sisk.pl>
	 <87zldpu5rt.fsf@deeprootsystems.com>
	 <d6200be20905061818h58145d5fie5c55ceaf900a196@mail.gmail.com>
Date: Thu, 7 May 2009 10:28:16 +0900
Message-ID: <4d34a0a70905061828l3e35a954k76967b30c1a241ab@mail.gmail.com>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
From: Kim Kyuwon <chammoru@gmail.com>
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/7 Arve Hjønnevåg <arve@android.com>:
> On Wed, May 6, 2009 at 5:16 PM, Kevin Hilman
> <khilman@deeprootsystems.com> wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>
>>> On Wednesday 06 May 2009, Kevin Hilman wrote:
>>>> Kevin Hilman <khilman@deeprootsystems.com> writes:
>
>> There is at least one problem with that which is why Kyuwon Kim added
>> the ->disable hook to OMAP's irq_chip.  The problem is with drivers
>> that call disable_irq() in their suspend hook, usually done to prevent
>> the device from waking the system since on OMAP, any IRQ can be
>> configured to wake the system.
>>
>
> This does not sound correct. disable_irq_wake should be used for this.
> A driver may need to mask its interrupt before suspending but this
> should not also disable it as a wakeup source.

I wish I could use disable_irq_wake(), but it doesn't work in OMAP.

>> If a driver's suspend hook calls disable_irq() and the system is
>> suspended before the lazy disable happens in the next handler, then
>> the system will be suspended with that device's IRQ still enabled.
>> Without an irq_chip->disable hook, that will result in that device IRQ
>> waking up the system if it fires.
>
> The platform suspend code needs to write the wakeup mask into
> interrupt controller the before entering suspend.
>

ditto

> --
> Arve Hjønnevåg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kyuwon (규원)
