Return-Path: <linux-kernel-owner+w=401wt.eu-S1761106AbZEGBSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761106AbZEGBSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 21:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZEGBSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 21:18:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:10167 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbZEGBSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 21:18:23 -0400
MIME-Version: 1.0
In-Reply-To: <87zldpu5rt.fsf@deeprootsystems.com>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	 <87y6tb3x6r.fsf@deeprootsystems.com>
	 <871vr22upr.fsf@deeprootsystems.com> <200905062318.23572.rjw@sisk.pl>
	 <87zldpu5rt.fsf@deeprootsystems.com>
Date: Wed, 6 May 2009 18:18:23 -0700
Message-ID: <d6200be20905061818h58145d5fie5c55ceaf900a196@mail.gmail.com>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 6, 2009 at 5:16 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>
>> On Wednesday 06 May 2009, Kevin Hilman wrote:
>>> Kevin Hilman <khilman@deeprootsystems.com> writes:

> There is at least one problem with that which is why Kyuwon Kim added
> the ->disable hook to OMAP's irq_chip.  The problem is with drivers
> that call disable_irq() in their suspend hook, usually done to prevent
> the device from waking the system since on OMAP, any IRQ can be
> configured to wake the system.
>

This does not sound correct. disable_irq_wake should be used for this.
A driver may need to mask its interrupt before suspending but this
should not also disable it as a wakeup source.

> If a driver's suspend hook calls disable_irq() and the system is
> suspended before the lazy disable happens in the next handler, then
> the system will be suspended with that device's IRQ still enabled.
> Without an irq_chip->disable hook, that will result in that device IRQ
> waking up the system if it fires.

The platform suspend code needs to write the wakeup mask into
interrupt controller the before entering suspend.


-- 
Arve Hjønnevåg
