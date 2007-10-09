Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbXJIV11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbXJIV11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 17:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbXJIV1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 17:27:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41050
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754022AbXJIV1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 17:27:19 -0400
Date: Tue, 09 Oct 2007 14:27:19 -0700 (PDT)
Message-Id: <20071009.142719.68041626.davem@davemloft.net>
To: stern@rowland.harvard.edu
Cc: greg@kroah.com, david-b@pacbell.net, linux-kernel@vger.kernel.org,
       linux-usb-users@lists.sourceforge.net
Subject: Re: [Linux-usb-users] OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.44L0.0710091440130.4783-100000@iolanthe.rowland.org>
References: <20071009173925.GA6062@kroah.com>
	<Pine.LNX.4.44L0.0710091440130.4783-100000@iolanthe.rowland.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 9 Oct 2007 14:42:34 -0400 (EDT)

> On Tue, 9 Oct 2007, Greg KH wrote:
> 
> > > Anyway, it certainly would be easy enough to make port resets mutually
> > > exclusive with EHCI initialization.  That would work on any platform,
> > > PCI or not.
> > 
> > That's a good idea, any thoughts as to how to do this?  I think I can
> > find some Intel and Dell people who would be glad to test this out if
> > you have a proposed patch.
> 
> Here is a proposed patch.  I haven't tried running it, but it compiles 
> okay.

Are we sure that this is the only event that causes the conflicts between
the EHCI and it's companion virtual OHCI/UHCI host(s)?

Is there a chip reset done to the EHCI controller early during device
probe that could cause problems too?

I know it's grotty, but I definitely feel more comfortable with the
fix involving making sure EHCI loads and fully probes first.
