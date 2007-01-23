Return-Path: <linux-kernel-owner+w=401wt.eu-S932289AbXAWJ57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbXAWJ57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 04:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932931AbXAWJ57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 04:57:59 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:30472 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbXAWJ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 04:57:58 -0500
Date: Tue, 23 Jan 2007 10:58:48 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [GIT PATCH] USB fixes for 2.6.20-rc5
Message-ID: <20070123105848.6649ea69@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1169497704.27023.13.camel@violet>
References: <20070122200746.GA9936@kroah.com>
	<1169496904.27023.11.camel@violet>
	<20070122202344.GA10579@suse.de>
	<1169497704.27023.13.camel@violet>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jan 2007 21:28:24 +0100,
Marcel Holtmann <marcel@holtmann.org> wrote:

> > I don't feel comfortable adding them to the 2.6.20 kernel at this late
> > period, for a variety of reasons.  I really want them to be tested out
> > in the -mm tree and then in the full -rc series due to the fact that
> > they are non-trivial, and touch the driver core code that everyone uses,
> > not just that function.

I agree that the patch allowing device_move(dev, NULL) is non-trivial,
but the one removing the useless device_is_registered() check should be
straightforward enough.

> 
> fair enough.
> 
> > Also, it's a new feature (reparent back to the original parent), not
> > necessarily a bugfix.
> >
> > And yes, I realize that the functions don't work fully right now, but as
> > long as you don't want to re-parent the devices, they should work,
> > right?
> 
> Actually even that was broken for me.

If removing the device_is_registered() check helps you, I'd lobby for
the inclusion of that part (and leave device_move(dev, NULL) for
post-2.6.20). (It should help for devices with no bus; for my use case,
everything worked fine.)

-- 
Cornelia Huck
Linux for zSeries Developer
Tel.: +49-7031-16-4837, Mail: cornelia.huck@de.ibm.com
