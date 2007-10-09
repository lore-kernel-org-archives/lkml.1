Return-Path: <linux-kernel-owner+w=401wt.eu-S1756393AbXJIUl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbXJIUl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 16:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbXJIUlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 16:41:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41026
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753865AbXJIUlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 16:41:16 -0400
Date: Tue, 09 Oct 2007 13:41:16 -0700 (PDT)
Message-Id: <20071009.134116.63997473.davem@davemloft.net>
To: david-b@pacbell.net
Cc: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071009163827.E7DB310B535@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
References: <20071009043643.773CC23715F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20071008.214408.98397070.davem@davemloft.net>
	<20071009163827.E7DB310B535@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Tue, 09 Oct 2007 09:38:27 -0700

> > > What values do you see for "portstat"?
> >
> > 0x111
> 
> That's unfortunately useless ... PPS, PRS, CCS (meaning powered,
> resetting, connected).  In short, there is *no* indication from
> the OHCI hardware that a disconnect happened.

But it's an excellent example of why my patch is mandatory.

When the device gets into a stuck state, this code does the wrong
thing.

Instead of trying to deal with bad situations, it hangs the system
instead.  That sucks for anyone trying to debug something like this.
This has caused weeks of debugging and grief for people, and it
could have all been eliminated if this looping code were more
robust to hardware failures.

If you can't see why this is bad programming practice in a hardware
driver, I will try to get my patch to someone who does.

Even though I'm severly overloaded, you asked me for a patch, I gave
you one.  And now you want to push it back at me because it isn't
clear to you yet that the code there right now is a huge problem.

And all of this is independant of making sure EHCI loads first,
we need to fix that too.
