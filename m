Return-Path: <linux-kernel-owner+w=401wt.eu-S1762216AbYDBUzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762216AbYDBUzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761945AbYDBUzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:55:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56435 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761417AbYDBUzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:55:21 -0400
Date: Wed, 2 Apr 2008 16:55:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Mark Lord <lkml@rtr.ca>, <pavel@suse.cz>, <oliver@neukum.org>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <jikos@suse.cz>, <gregkh@suse.de>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb ehci_iaa_watchdog fix
In-Reply-To: <200804021331.09991.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0804021639290.2107-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, David Brownell wrote:

> Those hcd->state tests have been getting more and more
> dodgey as time goes by.  At this point I hardly trust
> any of them.  There *IS* no clear state machine which
> governs the usbcore/HCD interaction.

ISTR trying to make that same point a few times over the past two or 
three years...  :-)

It would make more sense for each HCD to keep its own private "state" 
variable.  The interaction with usbcore can be broken down into a few 
simple tests, such as:

	Is the HC dead?
	Is the HC (i.e., the PCI or platform device) suspended?
	Is the HC running?
	Is it okay to submit an URB?

There's plenty of redundancy in this list, and some of the information
may already be available in hcd->self.root_hub->state.  In many or most
cases, these questions can't be answered in a race-free manner anyhow, 
which limits their usefulness.

Alan Stern

