Return-Path: <linux-kernel-owner+w=401wt.eu-S932713AbXCZWV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbXCZWV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXCZWV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 18:21:27 -0400
Received: from eazy.amigager.de ([213.239.192.238]:40856 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713AbXCZWV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 18:21:26 -0400
Date: Tue, 27 Mar 2007 00:21:24 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod doesn't work
Message-ID: <20070326222124.GA2873@dose.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oneukum@suse.de>,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070326204744.GA24762@dose.home.local> <Pine.LNX.4.44L0.0703261712340.7079-100000@iolanthe.rowland.org> <20070326212614.GA15856@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326212614.GA15856@dose.home.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 23:26:14 +0200, Tino Keitel wrote:
> On Mon, Mar 26, 2007 at 17:15:53 -0400, Alan Stern wrote:
> 
> [...]
> 
> > The lack of messages from the iPod seems to indicate that the hub isn't
> > working right.  You could try plugging the iPod into a different hub or
> > directly into the computer.  Or maybe into a different port of that hub.
> 
> I already tried all of the above options, with the same result. Note
> that all other USB devices (keyboard, mouse, hard disk with /home,
> DVB-T box etc.) work fine.
> 
> I'm currently bisecting.

Hi,

this is the bisect result:

$ git bisect good
1d619f128ba911cd3e6d6ad3475f146eb92f5c27 is first bad commit
commit 1d619f128ba911cd3e6d6ad3475f146eb92f5c27
Author: Marcelo Tosatti <marcelo@kvack.org>
Date:   Sun Jan 21 19:45:59 2007 -0200

    USB: switch ehci-hcd to new polling scheme

    Switch ehci-hcd to use the new polling scheme, which reports root
    hub status changes via the interrupt handler, in an asynchronous
    fashion. Doing so disables polling for status changes (whose
    handler is
    rh_timer_func).

    Tested on a Geode GX machine, which is now capable of running at =~
5
    timer interrupts per second (in the -rt tree), resulting in
significant
    power savings.

    Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
    Cc: David Brownell <david-b@pacbell.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 f8b11b3fe3cec62063d8da0f7be807341106f494
78c5a156897b3ad7aef27823d48a546fdda2c0d2 M      drivers

Regards,
Tino
