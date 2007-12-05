Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbXLEHeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbXLEHeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 02:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbXLEHee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 02:34:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47877
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751662AbXLEHed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 02:34:33 -0500
Date: Tue, 04 Dec 2007 23:34:32 -0800 (PST)
Message-Id: <20071204.233432.136250076.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: simon@fire.lp0.eu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sockets affected by IPsec always block (2.6.23)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071205071607.GA11852@gondor.apana.org.au>
References: <20071205065132.GA11476@gondor.apana.org.au>
	<20071204.231200.117152338.davem@davemloft.net>
	<20071205071607.GA11852@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 5 Dec 2007 18:16:07 +1100

> Right.  This is definitely bad for protocols without a retransmission
> mechanism.
> 
> However, is the 0 setting ever useful for TCP and in particular, TCP's
> connect(2) call? Perhaps we can just make that one always drop.

TCP has some built-in assumptions about characteristics of
interent links and what constitutes a timeout which is "too long"
and should thus result in a full connection failure.

IPSEC changes this because of IPSEC route resolution via
ISAKMP.

With this in mind I can definitely see people preferring
the "block until IPSEC resolves" behavior, especially for
something like, say, periodic remote backups and stuff like
that where you really want the thing to just sit and wait
for the connect() to succeed instead of failing.
