Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0BVUKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:10:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39901 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753049Ab0BVUKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:10:42 -0500
Date: Mon, 22 Feb 2010 15:10:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Anssi Hannula <anssi.hannula@iki.fi>
cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       <dvomlehn@cisco.com>, <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes"
 causes gobi_loader to hang
In-Reply-To: <201002222124.27777.anssi.hannula@iki.fi>
Message-ID: <Pine.LNX.4.44L0.1002221507590.1328-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Anssi Hannula wrote:

> On maanantai 22 helmikuu 2010 21:10:33 Alan Stern wrote:
> > On Mon, 22 Feb 2010, Anssi Hannula wrote:
> > > I guess that would suggest that the device doesn't allow the
> > > initialization data to be broken into packets arbitrarily (though some
> > > differences seem allowed, as the windows driver transmits them
> > > differently).
> > > 
> > > Does this mean a tty interface is ill-suited for the microcode upload,
> > > and instead qcserial should use the kernel's generic microcode upload
> > > mechanism or the userspace should use libusb to do it?
> > 
> > I don't know.  Didn't the old successful code use a tty interface?
> 
> Yes, but does the tty interface guarantee that the data of one write call is 
> sent as one packet to the device?

Not as far as I know.

> If I understood this correctly, it seems the changes have caused it to now 
> concatenate short writes into one packet, which the device doesn't seem to 
> like.

That seems to be the most likely explanation.  You might be able to
test it by adding some delays to the driver between those short writes,
so they don't get concatenated.

Alan Stern

