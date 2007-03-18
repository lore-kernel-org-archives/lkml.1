Return-Path: <linux-kernel-owner+w=401wt.eu-S1752923AbXCRCjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbXCRCjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 22:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXCRCjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 22:39:52 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3568 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752921AbXCRCjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 22:39:51 -0400
Date: Sat, 17 Mar 2007 22:39:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Keyboard stops working after *lock [Was: 2.6.21-rc2-mm1]
In-Reply-To: <45FC70A3.7060705@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703172226330.16306-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Mar 2007, Jiri Slaby wrote:

> Alan Stern napsal(a):
> > On Tue, 13 Mar 2007, Jiri Slaby wrote:
> > 
> >> So, do you mean rmmod uhci_hcd, unplug the keyboard, modprobe
> >> uhci_hcd, start usbmon, plug the keyboard, press numlock, stop usbmon,
> >> post it?
> 
> Here you are:

...

> (Remind: there is a hub inside the keyboard)

Yes.  It shows up very clearly in the log.

> >  static void uhci_free_td(struct uhci_hcd *uhci, struct uhci_td *td)
> >  {
> > -	if (!list_empty(&td->list))
> > +	if (!list_empty(&td->list)) {
> >  		dev_warn(uhci_dev(uhci), "td %p still in list!\n", td);
> > +		WARN_ON(1);
> 
> Nothing new in dmesg.

Oh well, I didn't really expect there to be.

Nothing in the log stands out.  Can you collect an equivalent log using a
version of uhci-hcd with the "eliminate skeleton QHs" patch reverted?  
Perhaps there will be a significant difference.  Although I doubt it...

I'm running out of ideas.  I tried doing exactly the same thing with a USB
keyboard+hub on my system, and it worked perfectly.  This suggests that
you might be seeing some weird hardware flaw that is somehow exposed by
the patch.

Can you borrow a different USB keyboard and see if it behaves the same 
way?  Or can you try using your keyboard on a different computer (one with 
UHCI)?

Alan Stern

