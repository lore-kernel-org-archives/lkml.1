Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0CCK3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:29:21 -0500
Received: from smtp-out.google.com ([216.239.44.51]:35029 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0CCK3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:29:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=sjGiZ3OCNq5QZucYqJwbc9XcwzxE/Hj7pfN5J/mSJUy45CbHHamrYdV8KrqAtnzZ9
	y4uz2pxS4uXTYJcweJiCw==
MIME-Version: 1.0
In-Reply-To: <20100303103405.127020d8@hyperion.delvare>
References: <4B8C1867.7040201@cam.ac.uk>
	 <404ea8001003022213v78be2c81r40504661835fff7e@mail.gmail.com>
	 <20100303103405.127020d8@hyperion.delvare>
Date: Wed, 3 Mar 2010 02:29:09 -0800
Message-ID: <404ea8001003030229j7b22329bgd24ac39255e78bde@mail.gmail.com>
Subject: Re: [GIT PULL] Ambient Light Sensors subsystem
From: Dima Zavin <dmitriyz@google.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, torvalds@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean,

Thanks for the prompt reply.

>> I definitely see the need for what you guys are trying to accomplish.
>> For example, currently, we use an input device for reporting events,
>> and a separate misc device node for control
>> (enable/disable/configure). It's definitely suboptimal, but there
>> currently isn't anything there would let us do things cleanly.
>>
>> What I would love to see is a more generic sensors framework that
>> handles different kinds of sensor devices, and different data
>> acquisition schemes (sampled vs. change notifications).
>>
>> I would love to work with you to design something more generic.
>
> This can happen later, I see no reason to block the creation of the ALS
> subsystem. Having a common framework for all ambient light sensor
> drivers will already be a step forward compared to the current

Following the logic of putting the ALS subsystem under drivers/als, we
would then put the proximity subsystem under drivers/proximity, and
then an accelerometer subsystem under drivers/accelerometer, etc. Each
with their own implementation of very similar set of interfaces. Is
that what you envision? I just figured that instead of creating
one-off interfaces for some subset of environmental sensors such as
als, we can add a sensors subsystem of which als is just an instance.

> situation. If improvements are needed on top of this, this can happen
> later.

I'm just concerned that instead of solving the actual problem, you are
adding what is essentially a temporary solution. This will only make
it harder to solve the real issue by introducing new interfaces which
will need to be obsoleted unless they are designed with care. What you
are proposing already needs improvements since there are plenty of
drivers floating out there from many OEMs/vendors that are not ALSs,
but essentially need a similar interface (e.g. proximity sensor).

Furthermore, are there more patches coming for this subsystem? Based
on the above tree, it just seems to be a class device (without any
standard attributes) and a register/unregister function. It doesn't
seem to actually be doing anything. Registering with the als subsystem
at the moment buys the driver nothing. So, in its current state, I'm
not sure I see what this new common framework actually provides us,
and thus I'm not sure that it's actually a step forward. The drivers
are still responsible to provide all their own non-standard,
incompatible sysfs interfaces for exporting the sensor values. If
there are other patches for the als subsys that are then used by the
two drivers that got moved into drivers/als, I'd love to take a look
at them.

Thanks again.

--Dima
