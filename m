Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbZG0QuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbZG0QuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZG0QuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:50:04 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:54972 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZG0QuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:50:03 -0400
X-Greylist: delayed 1692 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jul 2009 12:50:03 EDT
Date: Mon, 27 Jul 2009 18:48:57 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ferenc Wagner <wferi@niif.hu>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bisected] [Bug #13821] Replugging USB serial converter uses
	new device node
Message-ID: <20090727164857.GA8908@Pilar.aei.mpg.de>
References: <87zlaqcec1.fsf@tac.ki.iif.hu> <Pine.LNX.4.44L0.0907271217441.5217-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0907271217441.5217-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 27.Jul'09 at 12:18:36 -0400, Alan Stern wrote:
> On Mon, 27 Jul 2009, Ferenc Wagner wrote:
> 
> > > Are you certain this really is a regression?  Under 2.6.30 and 2.6.27
> > > the same thing happened if I unplugged a USB serial device while it was
> > > in use.
> > 
> > My original report is about unplugging the USB servial device *after*
> > using it.
> > 
> > > Can you check whether the device is still being used when you unplug 
> > > it?  For instance, is there still a pppd process trying to communicate 
> > > with the device?
> > 
> > I checked and rechecked that the pppd process is already dead by the
> > time I unplug the device.  However, the minor number did not increase
> > if I unplugged the device without using it beforehand, as expected.
> > 
> > > In short, it seems likely that this is not new behavior but rather the 
> > > way usb-serial has worked all along.
> > 
> > I didn't experience this problem with 2.6.30: my ppp script was
> > hardwired to use ttyUSB0 and it always worked.  Now with 2.6.31-rc3 it
> > does not, as the device node keeps changing.
> > 
> > I'll test this with opening ttyUSB directly from the shell, instead of
> > via pppd, and report back whether it makes a difference.
> 
> Another thing to check is whether this patch (not yet merged) fixes it:
> 
> 	http://marc.info/?l=linux-usb&m=124825571403844&w=2

No, unfortunately it does not fix it. I've just tested it.
