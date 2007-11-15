Return-Path: <linux-kernel-owner+w=401wt.eu-S1762921AbXKOPk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762921AbXKOPk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 10:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756488AbXKOPks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 10:40:48 -0500
Received: from minus.inr.ac.ru ([194.67.69.97]:51400 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755924AbXKOPkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 10:40:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=pVgtaLH0RGVZsigfq9BeyniNvtNT9CSSQcFPS9ANjaVpPLHnyLbRRnVfFbuxpZfGeE447v7rO8wEnE1ULQKX3sgop8NxNujRJhRPab3MaQybYIzfa6vOcAmnRFQpIACA/RYcZqyjqvQ2Mc+S6ZxbLmFniTai7xxL9fNltBeRhiw=;
Date: Thu, 15 Nov 2007 18:40:32 +0300
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Jonas Danielsson <the.sator@gmail.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, jmorris@namei.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] net/ipv4/arp.c: Fix arp reply when sender ip 0 (was: Strange behavior in arp probe reply, bug or feature?)
Message-ID: <20071115154032.GA30391@ms2.inr.ac.ru>
References: <cac0ab7d0711150340p58eda94ah92894072ba328205@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cac0ab7d0711150340p58eda94ah92894072ba328205@mail.gmail.com>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> Send a correct arp reply instead of one with sender ip and sender
> hardware adress in target fields.

I do not see anything more legal in setting target address to 0.


Actually, semantics of target address in ARP reply is ambiguous.
If it is a reply to some real request, it is set to address of requestor
and protocol requires recipient of this arp reply to test that the address
matches its own address before creating new entry triggered by unsolicited
arp reply. That's all.

In the case of duplicate address detection, requestor does not have
any address, so that it is absolutely not essential what we use as target
address. The only place, which could depend on this is the tool, which
tests for duplicate address. At least, arping written by me, should
work with any variant.

So, please, could you explain what did force you to think that use of 0
is better?

Alexey
