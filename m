Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbXLGDUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbXLGDUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 22:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXLGDUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 22:20:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35210
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbXLGDUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 22:20:31 -0500
Date: Thu, 06 Dec 2007 19:20:30 -0800 (PST)
Message-Id: <20071206.192030.170597084.davem@davemloft.net>
To: stefan@loplof.de
Cc: herbert@gondor.apana.org.au, simon@fire.lp0.eu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sockets affected by IPsec always block (2.6.23)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200712061531.54107.stefan@loplof.de>
References: <200712061330.20586.stefan@loplof.de>
	<20071206.055515.180308628.davem@davemloft.net>
	<200712061531.54107.stefan@loplof.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Rompf <stefan@loplof.de>
Date: Thu, 6 Dec 2007 15:31:53 +0100

> as far as I've understood Herbert's patch, at least TCP connect can be fixed 
> so that non blocking connect() will neither fail nor block, but just use the 
> first or second retransmission of the SYN packet to complete the handshake 
> after IPSEC is up.

If IPSEC takes a long time to resolve, and we don't block, the
connect() can hard fail (we will just keep dropping the outgoing SYN
packet send attempts, eventually hitting the retry limit) in cases
where if we did block it would not fail (because we wouldn't send
the first SYN until IPSEC resolved).
