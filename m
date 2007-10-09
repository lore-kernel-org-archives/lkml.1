Return-Path: <linux-kernel-owner+w=401wt.eu-S1754931AbXJIEnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbXJIEnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 00:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbXJIEnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 00:43:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40135 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbXJIEng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 00:43:36 -0400
Date: Mon, 8 Oct 2007 21:39:09 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: david-b@pacbell.net, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: OHCI root_port_reset() deadly loop...
Message-ID: <20071009043909.GA4940@kroah.com>
References: <20071009031049.GD14127@kroah.com> <20071008.201653.43030513.davem@davemloft.net> <20071009033412.E37E323700C@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20071008.204236.92016616.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008.204236.92016616.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 08:42:36PM -0700, David Miller wrote:
> From: David Brownell <david-b@pacbell.net>
> Date: Mon, 08 Oct 2007 20:34:12 -0700
> 
> > > However, when both OHCI and EHCI are built as modules (or, similarly
> > > I guess, OHCI is built-in and EHCI is modular) there appears to be
> > > nothing in userspace which makes sure EHCI gets loaded first.
> > 
> > The old /etc/hotplug/usb.rc script made sure to load those modules
> > in the correct order:  EHCI first.
> 
> I expected to find something cute attempting to handle this under
> /etc/udev, I have failed so far :-)

No, nothing cute in udev itself, but it seems that all distros that I
know of have a "load these modules now" type setting in their init
scripts that can be used here.

I can't think of a way to enforce this load order on the modules
themselves due to the fact that OHCI might not even be needed for EHCI
devices on UHCI (Intel) based chipsets :(

Can anyone else?

thanks,

greg k-h
