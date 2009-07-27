Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZG0QSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZG0QSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZG0QSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:18:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55582 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751535AbZG0QSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:18:35 -0400
Date: Mon, 27 Jul 2009 12:18:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ferenc Wagner <wferi@niif.hu>
cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bisected] [Bug #13821] Replugging USB serial converter uses
 new device node
In-Reply-To: <87zlaqcec1.fsf@tac.ki.iif.hu>
Message-ID: <Pine.LNX.4.44L0.0907271217441.5217-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Ferenc Wagner wrote:

> > Are you certain this really is a regression?  Under 2.6.30 and 2.6.27
> > the same thing happened if I unplugged a USB serial device while it was
> > in use.
> 
> My original report is about unplugging the USB servial device *after*
> using it.
> 
> > Can you check whether the device is still being used when you unplug 
> > it?  For instance, is there still a pppd process trying to communicate 
> > with the device?
> 
> I checked and rechecked that the pppd process is already dead by the
> time I unplug the device.  However, the minor number did not increase
> if I unplugged the device without using it beforehand, as expected.
> 
> > In short, it seems likely that this is not new behavior but rather the 
> > way usb-serial has worked all along.
> 
> I didn't experience this problem with 2.6.30: my ppp script was
> hardwired to use ttyUSB0 and it always worked.  Now with 2.6.31-rc3 it
> does not, as the device node keeps changing.
> 
> I'll test this with opening ttyUSB directly from the shell, instead of
> via pppd, and report back whether it makes a difference.

Another thing to check is whether this patch (not yet merged) fixes it:

	http://marc.info/?l=linux-usb&m=124825571403844&w=2

Alan Stern

