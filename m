Return-Path: <linux-kernel-owner+w=401wt.eu-S1758385AbYGGWGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385AbYGGWGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755626AbYGGWFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:05:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57767
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756818AbYGGWFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:05:49 -0400
Date: Mon, 07 Jul 2008 15:05:49 -0700 (PDT)
Message-Id: <20080707.150549.242704515.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: mchan@broadcom.com, dwmw2@infradead.org, bastian@waldi.eu.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2 - use request_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080707221950.3dfba435@the-village.bc.nu>
References: <1215456981.5532.20.camel@dell>
	<20080707.143803.99767036.davem@davemloft.net>
	<20080707221950.3dfba435@the-village.bc.nu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 7 Jul 2008 22:19:50 +0100

> Not leaving crap locked in kernel memory when it isn't needed
> Letting vendors issue firmware updates (which especially in enterprise
> space is a big issue and right now gets messy with compiled in firmware)

The firmware needs to be reloaded every time the chip resets.
You're not saving anything.

Or do you want a request_firmware() call failure to hose your
ethernet device when it gets a TX timeout?

<sarcasm>
Sounds like a real error resiliant system to me...
</sarcasm>

Distribution vendors can just as easily ship the driver itself
seperately to get the firmware update.  And by getting it together the
user knows they are receiving something the driver maintainer tested
as a unit.

> And their users and the distributors for whom it can cause enormous
> pain.

Distribution vendors just want the separation so that they don't have
to keep patching the fimrware out of the tg3.c driver source every
single release, as some do :-)

> If the two are closely tied then it makes a lot of sense to keep
> them tied, but that doesn't mean wasting a ton of kernel memory and
> bandwidth and disk space in the process. Loading the firmware and
> insisting on a specific version is quite civilised for a driver with
> such a tie.

See above, you aren't saving anything.  The firmware needs to stay
around so it can be reloaded into the card during exceptions.

That is, unless you want a more failure prone system.

> Driver authors aren't God.

They (actually, more specifically the maintainers) to a certain extent
are, because they are the ones who eat doo-doo when something explodes.

 There are other important considerations, but
> for tg3 if that means 'wrong MD5sum, no load' then fine.

So in your "firmware updated seperately" argument above how in the
world does this work?  How can you update the firmware seperately if
the MD5sum check is in the driver itself?
