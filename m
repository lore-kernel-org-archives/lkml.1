Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbXKSNG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbXKSNG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 08:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbXKSNGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 08:06:18 -0500
Received: from minus.inr.ac.ru ([194.67.69.97]:35652 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752525AbXKSNGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 08:06:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=S+dOzx5m+pbwDn3vOey+tipzQUbPa2ATKlSzx5xv0SeSoabl2bEWA9NWbgOMs0OW+jrPxCB1i2NZtURQ7xdNHIjB8XiAl4te7q57k69u4pqm7fMlxazrDsAdqEPo4ApZYa0RWzb2meqG97/dwExLHhvtMEcOGviJZFXl68tjrLg=;
Date: Mon, 19 Nov 2007 16:06:10 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Jonas Danielsson <the.sator@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, jmorris@namei.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] net/ipv4/arp.c: Fix arp reply when sender ip 0 (was: Strange behavior in arp probe reply, bug or feature?)
Message-ID: <20071119130610.GB6952@ms2.inr.ac.ru>
References: <cac0ab7d0711150340p58eda94ah92894072ba328205@mail.gmail.com> <20071115154032.GA30391@ms2.inr.ac.ru> <cac0ab7d0711151340l1cc91a2dw5ebf36e166d16d7a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cac0ab7d0711151340l1cc91a2dw5ebf36e166d16d7a@mail.gmail.com>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Is there a reason that the target hardware address isn't the target
> hardware address?

It is bound only to the fact that linux uses protocol address
of the machine, which responds. It would be highly confusing
(more than confusing :-)), if we used our protocol address and hardware
address of requestor.

But if you use zero protocol address as source, you really can use
any hw address.

> The dhcp clients I examined, and the implementation of the arpcheck
> that I use will compare the target hardware field of the arp-reply and
> match it against its own mac, to verify the reply. And this fails with
> the current implementation in the kernel.

1. Do not do this. Mainly, because you already know that this does not work
   with linux. :-) Logically, target hw address in arp reply is just
   a nonsensial redundancy, it should not be checked and even looked at.

2. What's about your suggestion, I thought about this and I am going to agree.

   Arguments, which convinced me are:

   - arping still works.
   - any piece of reasonable software should work.
   - if Windows understands DaD (is it really true? I cannot believe)
     and it is unhappy about our responce and does not block use
     of duplicate address only due to this, we _must_ accomodate ASAP.
   - if we do,we have to use 0 protocol address, no choice.

Alexey
