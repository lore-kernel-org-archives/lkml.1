Return-Path: <linux-kernel-owner+w=401wt.eu-S1763578AbXJOWB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578AbXJOWB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbXJOWBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:01:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58897
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756456AbXJOWBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:01:19 -0400
Date: Mon, 15 Oct 2007 15:01:24 -0700 (PDT)
Message-Id: <20071015.150124.78710191.davem@davemloft.net>
To: david-b@pacbell.net
Cc: stern@rowland.harvard.edu, greg@kroah.com, linux-kernel@vger.kernel.org,
       linux-usb-users@lists.sourceforge.net
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071009.213507.78708496.davem@davemloft.net>
References: <200710091443.54998.david-b@pacbell.net>
	<20071009.150040.55724885.davem@davemloft.net>
	<20071009.213507.78708496.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 09 Oct 2007 21:35:07 -0700 (PDT)

> From: David Miller <davem@davemloft.net>
> Date: Tue, 09 Oct 2007 15:00:40 -0700 (PDT)
> 
> > From: David Brownell <david-b@pacbell.net>
> > Date: Tue, 9 Oct 2007 14:43:54 -0700
> > 
> > > Does it resolve the problem you observed?
> > 
> > I will definitely give the patch a try and report back.
> 
> My tests look really good with Alan Stern's patch.
> 
> With a kernel is hacked to load OHCI before EHCI, and
> that always hangs, the patch makes the hang go away
> reliably.

Bad news, even with the rwsem after a lot more testing I can still
trigger the hang in ohci_hub_control() :-(

I think we need to go back to considering the total serialization
approach to this problem.
