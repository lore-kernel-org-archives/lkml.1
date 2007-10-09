Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbXJIErg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbXJIErg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 00:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXJIEr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 00:47:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51784
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751463AbXJIEr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 00:47:28 -0400
Date: Mon, 08 Oct 2007 21:47:27 -0700 (PDT)
Message-Id: <20071008.214727.48799757.davem@davemloft.net>
To: greg@kroah.com
Cc: david-b@pacbell.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071009043909.GA4940@kroah.com>
References: <20071009033412.E37E323700C@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20071008.204236.92016616.davem@davemloft.net>
	<20071009043909.GA4940@kroah.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Mon, 8 Oct 2007 21:39:09 -0700

> No, nothing cute in udev itself, but it seems that all distros that I
> know of have a "load these modules now" type setting in their init
> scripts that can be used here.
> 
> I can't think of a way to enforce this load order on the modules
> themselves due to the fact that OHCI might not even be needed for EHCI
> devices on UHCI (Intel) based chipsets :(
> 
> Can anyone else?

The three modules perhaps should be a bundle of whatever ones you have
enabled, and internally we can dispatch the initialization to occur in
the correct order from a top-level module_init().

If the devices need to be initialized in a certain order in a
situation like this, it really seems like it is the kernel's job to
enforce it.
