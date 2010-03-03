Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab0CCQr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:47:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48613
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755021Ab0CCQrw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:47:52 -0500
Date: Wed, 03 Mar 2010 08:48:11 -0800 (PST)
Message-Id: <20100303.084811.228955847.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uartlite: Fix build on sparc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <fa686aa41003030840u45021b53y639464a7e831a63d@mail.gmail.com>
References: <fa686aa41003030751x6fbf4cc2t119f225e31bd45c8@mail.gmail.com>
	<20100303.080449.172546594.davem@davemloft.net>
	<fa686aa41003030840u45021b53y639464a7e831a63d@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 3 Mar 2010 09:40:14 -0700

> On Wed, Mar 3, 2010 at 9:04 AM, David Miller <davem@davemloft.net> wrote:
>> From: Grant Likely <grant.likely@secretlab.ca>
>> Date: Wed, 3 Mar 2010 08:51:27 -0700
>>
>>> Or if you prefer, I could expedite my patch that moves
>>> of_address_to_resource() into common code (it's currently in my test
>>> branch).  I wasn't planning to merge it until 2.6.35, but it is pretty
>>> low risk so I'd be comfortable merging it now.
>>
>> I prefer if you deal with it this way.
> 
> Hmmm... on second look my patch depends on a bunch of other stuff that
> doesn't work with sparc yet.  grumble.  Sorry, this isn't going to
> work yet.  I'll have to block out the uartlite driver instead.  In the
> mean time I'll change the Kconfig to omit uartlite on sparc.

BTW, while looking at this I can provide something similar to the
of_address_to_resource() interface on sparc but it would need
to provide the of_device pointer not the device_node one.

I precompute all of the IRQs and I/O addresses of OF nodes and stick
them into of_device->resource[] and of_device->irq[].

So if I have the of_device pointer I can just:

	memset(res, op->resource[n], sizeof(*res));

as my implementation.
