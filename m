Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZEEX54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZEEX54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZEEX5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:57:47 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:11456 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZEEX5q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:57:46 -0400
MIME-Version: 1.0
In-Reply-To: <87eiv35eg6.fsf@deeprootsystems.com>
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	 <20090504235405.647772ed.akpm@linux-foundation.org>
	 <87ocu7a6ng.fsf@deeprootsystems.com>
	 <d6200be20905051358m34c2be02ped84ad4158cd9865@mail.gmail.com>
	 <87eiv35eg6.fsf@deeprootsystems.com>
Date: Tue, 5 May 2009 16:57:45 -0700
Message-ID: <d6200be20905051657p31349e5ara8ad1ad9eb755c6b@mail.gmail.com>
Subject: Re: [PATCH] PM: suspend_device_irqs(): don't disable wakeup IRQs
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/5 Kevin Hilman <khilman@deeprootsystems.com>:
> Arve Hjønnevåg <arve@android.com> writes:
>
>> On Tue, May 5, 2009 at 8:52 AM, Kevin Hilman
> [...]
>
>> By leaving the interrupt enabled you prevent check_wakeup_irqs from
>> aborting suspend.
>
> Yes, but it doesn't prevent platform-specific code from aborting
> suspend.  On OMAP, the platform-specific suspend enter hook does a
> last check for pending enabled interrupts very late in the sequence.
> It seems to me that the platform specific code is the best place to do
> this.

It will not be pending anymore if the interrupt triggered before all
interrupts were masked at the cpu.

> On a related note, what happens if your device triggers an interrupt
> between check_wakeup_irqs() and the actual suspend?  Since it is a
> wakeup IRQ, wouldn't you want it to abort the suspend too?
>

check_wakeup_irqs is called after masking interrupts, so your existing
platform specific check should catch it.

-- 
Arve Hjønnevåg
