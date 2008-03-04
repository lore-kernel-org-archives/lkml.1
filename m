Return-Path: <linux-kernel-owner+w=401wt.eu-S935226AbYCDXWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935226AbYCDXWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934849AbYCDXP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:15:56 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:37105 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934041AbYCDXPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:15:53 -0500
Date: Wed, 5 Mar 2008 00:15:31 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: David Brownell <david-b@pacbell.net>
cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, 0x0007@gmail.com,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: WARNING: at drivers/usb/host/ehci-hcd.c:287
In-Reply-To: <200803041401.41880.david-b@pacbell.net>
Message-ID: <alpine.DEB.1.00.0803050012090.5974@sheep.housecafe.de>
References: <Pine.LNX.4.44L0.0803041553320.15986-100000@iolanthe.rowland.org> <200803041401.41880.david-b@pacbell.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008, David Brownell wrote:
>>> Or bettter yet, just removing it entirely.  ISTR doing that in some
>>> patches I've not yet sent for merging, and expect that's what my
>>> preferred fix will be ...
>>
>> But removing the WARN_ON won't fix the problem.
>
> It fully resolves the $SUBJECT problem.  :)

...and if it's a safe thing to do, I'm happy with it. I really have no 
clue why shutting up a WARN_ON has no (future) implications but if you 
say so I trust you :)

So now we're down to just:

--- linux-2.6/drivers/usb/host/ehci-hcd.c	2008-03-05 00:08:33.000000000 +0100
+++ linux-2.6/drivers/usb/host/ehci-hcd.c.edited	2008-03-05 00:09:45.000000000 +0100
@@ -284,7 +284,6 @@ static void ehci_iaa_watchdog(unsigned l
  	u32			status, cmd;

  	spin_lock_irqsave (&ehci->lock, flags);
-	WARN_ON(!ehci->reclaim);

  	status = ehci_readl(ehci, &ehci->regs->status);
  	cmd = ehci_readl(ehci, &ehci->regs->command);

Right?

Thank you both for looking into this issue,
Christian.
-- 
BOFH excuse #285:

Telecommunications is upgrading.
