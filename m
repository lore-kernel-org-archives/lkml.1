Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZEEP5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZEEP5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbZEEP5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:57:03 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:19283 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZEEP5B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:57:01 -0400
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH] PM: suspend_device_irqs(): don't disable  wakeup IRQs
References: <1241483224-7113-1-git-send-email-khilman@deeprootsystems.com>
	<20090504235405.647772ed.akpm@linux-foundation.org>
	<acd2a5930905050711j57cbf81du2fe4dbb4e408e877@mail.gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 05 May 2009 08:56:56 -0700
In-Reply-To: <acd2a5930905050711j57cbf81du2fe4dbb4e408e877@mail.gmail.com> (Vitaly Wool's message of "Tue\, 5 May 2009 18\:11\:31 +0400")
Message-ID: <87bpq7a6gn.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaly Wool <vitalywool@gmail.com> writes:

> On Tue, May 5, 2009 at 10:54 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Mon,  4 May 2009 17:27:04 -0700 Kevin Hilman <khilman@deeprootsystems.com> wrote:
>>
>>> Interrupts that are flagged as wakeup sources via set_irq_wake()
>>> should not be disabled for suspend.
>>>
>>
>> Why not?
>
> Sounds like an interesting problem. If a wakeup depends on the
> interrupt line, then no they definitely should not be disabled, as no
> wakeup would happen otherwise. 

Agreed.

> OTOH, this is not necessarily the case; some SoCs configure wakeup
> sources as GPIOs (i.MXs do AFAIR) so it's not clear if we should
> change generic source code in this case.

In the case of GPIO IRQs, then the call to __disable_irq() in
suspend_device_irqs() will trickle down to the irq_chip disable hook
in the GPIO code.  If that code stops the GPIO from triggering
interrupts, which it should, then my guess is your GPIO will no longer
wake the system either.

Kevin
