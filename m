Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbXLQOgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbXLQOgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754972AbXLQOgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:36:24 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:19697 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbXLQOgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:36:23 -0500
X-Trace: 642848110/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.91
X-SBRS: None
X-RemoteIP: 81.1.89.91
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAKcXZkdRAVlb/2dsb2JhbACBV6gg
Message-ID: <48462.85.118.17.158.1197902160.squirrel@newgolddream.dyndns.info>
In-Reply-To: <20071217140621.GA17168@kernel.dk>
References: <8b67d60712151621j2101c411p19d75125c6d1c2f9@mail.gmail.com>
    <20071217140621.GA17168@kernel.dk>
Date: Mon, 17 Dec 2007 14:36:00 -0000 (UTC)
Subject: Re: [PATCH 2/3] Add GD-Rom support to the SEGA Dreamcast
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Jens Axboe" <jens.axboe@oracle.com>
Cc: "Adrian McMenamin" <lkmladrian@gmail.com>,
       "Paul Mundt" <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-sh@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, December 17, 2007 2:06 pm, Jens Axboe wrote:
> On Sun, Dec 16 2007, Adrian McMenamin wrote:
>
> Few notes:


Thanks for these, very helpful.

>
> - Compare rq_data_dir() with WRITE, don't just assume that any non-zero
>   will be a write.
>
> - You need to offload this request handling to a workqueue of some sort,
>   your current request handling is very broken for two reasons: One is
>   that interrupts are still disabled when you drop your queue lock, so
>   you cannot use sleeping functions like GFP_KERNEL allocations or
>   wait_event(). The other is that it's illegal to sleep from your
>   request_fn context in the first place, since you could be stalling
>   others.



Ah. OK. Funnily enough an earlier version did offload to a workqueue but i
thought that was too convoluted. I didn't realise interrupts were disabled
inside the request_fn context.

>
> - You also seem to be busy waiting for other transactions to finish. Any
>   idea how long those might take? Perhaps put an upper bound on this
>   waiting, and/or do blocking waits?
>
Well, when the register bit clears they are over, seems to be about 200 -
400 microseconds or there abouts (ie that length of time between the
interrupt signalling that the transfer is over and the bit clearing to
allow a new transfer) - so I could time that out at say HZ/2 and be very
safe.


> - I'm assuming this hardware can't do sg transfers?
>

Afraid not.

