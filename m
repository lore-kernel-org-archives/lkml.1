Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbXKOX20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbXKOX20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 18:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756389AbXKOX2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 18:28:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56513
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755180AbXKOX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 18:28:14 -0500
Date: Thu, 15 Nov 2007 15:28:13 -0800 (PST)
Message-Id: <20071115.152813.89410917.davem@davemloft.net>
To: the.sator@gmail.com
Cc: kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org, jmorris@namei.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] net/ipv4/arp.c: Fix arp reply when sender ip 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <cac0ab7d0711151340l1cc91a2dw5ebf36e166d16d7a@mail.gmail.com>
References: <cac0ab7d0711150340p58eda94ah92894072ba328205@mail.gmail.com>
	<20071115154032.GA30391@ms2.inr.ac.ru>
	<cac0ab7d0711151340l1cc91a2dw5ebf36e166d16d7a@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jonas Danielsson" <the.sator@gmail.com>
Date: Thu, 15 Nov 2007 22:40:13 +0100

> Is there a reason that the target hardware address isn't the target
> hardware address?

Linux subscribes to the host based addressing model rather
than an interface based addressing model.  Both approaches
are valid by RFCs.

Because of this, in cases where a choice can be made Linux will
advertise what is most likely to result in successful communication.

This is likely why we are changing that target address to the one of
the interface actually sending back the reply rather than the zero
value you used.

In fact I think this information can be useful to the sender of
the DAD request.
