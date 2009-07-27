Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZG0Pe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZG0Pe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZG0Pe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:34:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55220 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752706AbZG0Pez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:34:55 -0400
Date: Mon, 27 Jul 2009 11:34:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Carlos R. Mafra" <crmafra2@gmail.com>
cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Ferenc Wagner <wferi@niif.hu>,
       Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bisected] [Bug #13821] Replugging USB serial converter uses
 new device node
In-Reply-To: <20090727022623.GA6614@Pilar.aei.mpg.de>
Message-ID: <Pine.LNX.4.44L0.0907271131100.5217-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Carlos R. Mafra wrote:

> On Sun 26.Jul'09 at 22:28:27 +0200, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13821
> > Subject		: Replugging USB serial converter uses new device node
> > Submitter	: Ferenc Wagner <wferi@niif.hu>
> > Date		: 2009-07-18 20:04 (9 days old)
> > References	: http://marc.info/?l=linux-kernel&m=124794754015776&w=4
> 
> I was scanning the regressions list and noticed that I could reproduce
> this bug.
> 
> So I bisected it to commit 335f8514f200e63d689113d29cb7253a5c282967
> ("tty: Bring the usb tty port structure into more use"), from Alan
> Cox.
> 
> I did not double check if reverting it from -rc4 fixes the issue,
> but I noticed that this patch touches drivers/usb/serial/option.c, which
> is the driver I used to test this problem.
> 
> If there is anything else I can do (give more info, test patches etc),
> please let me know.

Are you certain this really is a regression?  Under 2.6.30 and 2.6.27
the same thing happened if I unplugged a USB serial device while it was
in use.

Can you check whether the device is still being used when you unplug 
it?  For instance, is there still a pppd process trying to communicate 
with the device?  If there is, what happens if you kill all the 
processes using the serial device before you unplug it?

In short, it seems likely that this is not new behavior but rather the 
way usb-serial has worked all along.

Alan Stern

