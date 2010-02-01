Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0BAHrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 02:47:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32805
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751042Ab0BAHrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 02:47:13 -0500
Date: Sun, 31 Jan 2010 23:47:26 -0800 (PST)
Message-Id: <20100131.234726.124893364.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: jeff@garzik.org, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/68] ide2libata
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100129232540.41f6c4f6@lxorguk.ukuu.org.uk>
References: <20100129160308.21495.14120.sendpatchset@localhost>
	<4B6355DF.9050001@garzik.org>
	<20100129232540.41f6c4f6@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 29 Jan 2010 23:25:40 +0000

> The old IDE "maintenance mode" seems to be drifting - the rate of change
> is rather high for that claim.

I think there's another angle to this.

By making the IDE layer build from the same code as the ATA
driver, the legacy IDE layer gets an indirect tester base.

I like that.

However what I don't like is how this is implemented.  We shouldn't
pretend the data structures are the same by using macros in some
header file, we should truly abstract out the data types properly such
that these drivers in fact use the same datastructures.

For the price of a few series of data structure morphs, we eliminate
the tester-base issue of legacy IDE.  There's one driver for both
ATA and legacy IDE, the stuff in front is just a presentation and
probing layer, nothing more.

The cost and risk is testing the morphing changes, but I think the
scales tip towards making this truly worth it.

Bart, thanks for working on this and publishing what you came up
with.
