Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab0CCSxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:53:21 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:58390 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab0CCSxU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:53:20 -0500
MIME-Version: 1.0
In-Reply-To: <20100303.084811.228955847.davem@davemloft.net>
References: <fa686aa41003030751x6fbf4cc2t119f225e31bd45c8@mail.gmail.com> 
	<20100303.080449.172546594.davem@davemloft.net> <fa686aa41003030840u45021b53y639464a7e831a63d@mail.gmail.com> 
	<20100303.084811.228955847.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 3 Mar 2010 11:52:59 -0700
X-Google-Sender-Auth: 59f50f93a7936fe2
Message-ID: <fa686aa41003031052p59fdd7d9vee6c56b20a90930f@mail.gmail.com>
Subject: Re: [PATCH] uartlite: Fix build on sparc.
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 9:48 AM, David Miller <davem@davemloft.net> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> Date: Wed, 3 Mar 2010 09:40:14 -0700
>
>> On Wed, Mar 3, 2010 at 9:04 AM, David Miller <davem@davemloft.net> wrote:
>>> From: Grant Likely <grant.likely@secretlab.ca>
>>> Date: Wed, 3 Mar 2010 08:51:27 -0700
>>>
>>>> Or if you prefer, I could expedite my patch that moves
>>>> of_address_to_resource() into common code (it's currently in my test
>>>> branch).  I wasn't planning to merge it until 2.6.35, but it is pretty
>>>> low risk so I'd be comfortable merging it now.
>>>
>>> I prefer if you deal with it this way.
>>
>> Hmmm... on second look my patch depends on a bunch of other stuff that
>> doesn't work with sparc yet.  grumble.  Sorry, this isn't going to
>> work yet.  I'll have to block out the uartlite driver instead.  In the
>> mean time I'll change the Kconfig to omit uartlite on sparc.
>
> BTW, while looking at this I can provide something similar to the
> of_address_to_resource() interface on sparc but it would need
> to provide the of_device pointer not the device_node one.
>
> I precompute all of the IRQs and I/O addresses of OF nodes and stick
> them into of_device->resource[] and of_device->irq[].
>
> So if I have the of_device pointer I can just:
>
>        memset(res, op->resource[n], sizeof(*res));
>
> as my implementation.

Cool.

I'm actually hoping to do much the same with the other OF
architectures, so hopefully of_address_to_resource() will become only
used in arch code when talking to hardware before the devices are
registered.

I also need to look at merging the bus address translation code.  It
looks like sparc and ppc are using variations on the same codebase,
but they seem to have diverged quite a lot.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
