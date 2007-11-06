Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbXKFXOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbXKFXOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 18:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbXKFXOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 18:14:45 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:14735 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbXKFXOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 18:14:44 -0500
Date: Tue, 06 Nov 2007 17:13:50 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: VM/networking crash cause #1: page allocation failure (order:1,
 GFP_ATOMIC)
In-reply-to: <fa.lT2PJ6g8pT/00cmv4KeoEpWD3rU@ifi.uio.no>
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4730F52E.2070807@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.lT2PJ6g8pT/00cmv4KeoEpWD3rU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frank van Maarseveen wrote:
> For quite some time I'm seeing occasional lockups spread over 50 different
> machines I'm maintaining. Symptom: a page allocation failure with order:1,
> GFP_ATOMIC, while there is plenty of memory, as it seems (lots of free
> pages, almost no swap used) followed by a lockup (everything dead). I've
> collected all (12) crash cases which occurred the last 10 weeks on 50
> machines total (i.e. 1 crash every 41 weeks on average). The kernel
> messages are summarized to show the interesting part (IMO) they have
> in common. Over the years this has become the crash cause #1 for stable
> kernels for me (fglrx doesn't count ;).
> 
> One note: I suspect that reporting a GFP_ATOMIC allocation failure in an
> network driver via that same driver (netconsole) may not be the smartest
> thing to do and this could be responsible for the lockup itself. However,
> the initial page allocation failure remains and I'm not sure how to
> address that problem.
> 
> I still think the issue is memory fragmentation but if so, it looks
> a bit extreme to me: One system with 2GB of ram crashed after a day,
> merely running a couple of TCP server programs. All systems have either
> 1 or 2GB ram and at least 1G of (merely unused) swap.

These are all order-1 allocations for received network packets that need 
to be allocated out of low memory (assuming you're using a 32-bit 
kernel), so it's quite possible for them to fail on occasion. (Are you 
using jumbo frames?)

That should not be causing a lockup though.. the received packet should 
just get dropped.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

