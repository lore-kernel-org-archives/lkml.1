Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbXKWKLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbXKWKLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756737AbXKWKJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:09:37 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:50221 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484AbXKWKJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:09:35 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: David Miller <davem@davemloft.net>
Cc: shemminger@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: network driver usage count
References: <87hcjf9yd4.fsf@tac.ki.iif.hu>
	<20071121130445.569d2176@freepuppy.rosehill>
	<87myt7nt0k.fsf@szonett.ki.iif.hu>
	<20071122.170458.260273849.davem@davemloft.net>
Date: Fri, 23 Nov 2007 11:09:27 +0100
In-Reply-To: <20071122.170458.260273849.davem@davemloft.net> (David Miller's
	message of "Thu, 22 Nov 2007 17:04:58 -0800 (PST)")
Message-ID: <87pry1ff3c.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Wagner Ferenc <wferi@niif.hu>
> Date: Wed, 21 Nov 2007 23:16:59 +0100
>
>> Hmm, that would warrant nuking all the reference counts on every
>> driver.
>
> That's not true.  When packets are in flight, references go
> to the device and the device cannot be unloaded until those
> references get dropped.

I'm trying to understand it.  Do you mean that the "usage count" in
the lsmod output does not express the user's view of a piece of *ware
being in use, but rather the number of internal kernel references to
it, which would become invalid should that piece disappear?  Where the
former "invalidily" means some undetectable and uncorrectable
inconsistency in the kernel data structures, which leads to a kernel
crash.

> This behavior makes sense because otherwise you have to figure
> out the myriad of references (each ipv4 address, each ipv6
> address, routes, ARP entries, etc.) just to perform such a
> simple operation.

Yes, that's the user's idea of a network device being in use.  It can
get hairy indeed.

> If you do not mean to unload the device, simply do not do it.

Now I know...
-- 
Thanks for taking the time,
Feri.
