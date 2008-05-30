Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbYE3HA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbYE3HA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 03:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYE3HAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 03:00:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49069
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbYE3HAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 03:00:13 -0400
Date: Fri, 30 May 2008 00:00:09 -0700 (PDT)
Message-Id: <20080530.000009.02995266.davem@davemloft.net>
To: Matheos.Worku@Sun.COM
Cc: jesper@krogh.cc, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
From: David Miller <davem@davemloft.net>
In-Reply-To: <483F46E5.9030707@sun.com>
References: <483CB301.40007@sun.com>
	<20080528.223415.193732490.davem@davemloft.net>
	<483F46E5.9030707@sun.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matheos Worku <Matheos.Worku@Sun.COM>
Date: Thu, 29 May 2008 17:14:29 -0700

> Actually what I am suggesting was a workaround for the lack of "TX Ring 
> Empty" interrupt by not relying on the TX interrupt at all.

Ahh I see.

Some of the things I talked about in my presentation here in
Berlin at LinuxTAG yesterday can help mitigate the effects.
Most of it revolves around batching, and allowing the driver
to manage the backlog of packets directly when the TX queue
fills up.

In such a case we could batch the TX queue refill, know how many more
TX packets we will queue up to the chip right now, and therefore know
that we can safely set periodic MARK bits and only need to force set
the MARK bit at the very end.

> As for the TX hang, I will try to reproduce the problem and look at
> the registers for the clue.

Thanks a lot.
