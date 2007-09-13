Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbXIMPJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbXIMPJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbXIMPJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:09:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58103 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751452AbXIMPJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:09:21 -0400
Date: Thu, 13 Sep 2007 11:09:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Lord <lkml@rtr.ca>
cc: Chuck Ebbert <cebbert@redhat.com>, Niels <zorglub_olsen@hotmail.com>,
       <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] Problems with USB disk [solved]
In-Reply-To: <46E94AC2.3030607@rtr.ca>
Message-ID: <Pine.LNX.4.44L0.0709131105250.3619-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Mark Lord wrote:

> Alan Stern wrote:
> > On Wed, 12 Sep 2007, Mark Lord wrote:
> > 
> >> Chuck Ebbert wrote:
> ..
> >>> Oh, nice. The usb-storage (SCSI) disk spins itself down and we can't handle that.
> >>> Should we be disabling auto-spindown when we connect the device, or be able to
> >>> handle this by sending the start command when needed?
> >> There's more to this.
> >>
> >> My Sandisk Cruzer Micro 1GB USB sticks suffer from this regression.
> > 
> > I seriously doubt that.  Are you claiming that your USB stick spins 
> > itself down during a suspend?  And then requires to be spun back up 
> > before it will resume proper operation?
> 
> No, the machine is not being suspended at all.
> 
> What happens is, there's a nice little LED on the Cruzer stick,
> that is "lit" when the stick itself is not in a "power suspend" state
> (or whatever you USB folks call it).

We call it "suspended".  (Wasn't there an episode of Classic Trek where 
Mr. Spock explained to somebody, "I call them `ears'."?)

> On 2.6.22, that little LED stays "on" normally, and flickers off/on
> when data is being transfered.
> 
> The new "USB autosuspend" logic in 2.6.23 now causes that little LED
> to turn off after a few seconds of inactivity.
> 
> Once that happens, the USB stick is not accessible until after a longish
> timeout (~30s I think), followed by a USB reset.  Then it is usable again
> until the next inactivity timeout and autosuspend (a few seconds).

So this _isn't_ the regression described above -- to wit, that the 
drive gets spun down and then won't work without first being spun back 
up.  You wrote:

> >> My Sandisk Cruzer Micro 1GB USB sticks suffer from this regression.

But it doesn't.  It suffers from a different regression.

Alan Stern

