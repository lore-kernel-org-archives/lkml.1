Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbYH0VbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbYH0VbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYH0Van
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:30:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42947 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753199AbYH0Val (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:30:41 -0400
Date: Wed, 27 Aug 2008 17:30:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc2 USB suspend regression
In-Reply-To: <48AC8FB2.2040301@goop.org>
Message-ID: <Pine.LNX.4.44L0.0808271729380.2137-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008, Jeremy Fitzhardinge wrote:

> Alan Stern wrote:
> > On Wed, 20 Aug 2008, Jeremy Fitzhardinge wrote:
> >
> >   
> >> Using the Fedora Rawhide kernel RPM "2.6.27-0.238.rc2.fc10.i686"
> >> (kernel-2.6.27-0.238.rc2.fc10.i686), I'm seeing suspend to ram
> >> failures.  The suspend seems to go OK, but then I just get endless:
> >>
> >> usb 5-1: uhci_result_common: failed with status 440000
> >>
> >> messages, with occasional flickers of something else being printed
> >> (perhaps).  The machine is otherwise unresponsive.
> >>     
> >
> > You could comment out that error message in order to see what else is 
> > in the log.  It is located in drivers/usb/host/uhci-q.c in the 
> > uhci_result_common() function.
> >
> > You could try running -rc3 instead of -rc2, although that probably 
> > won't make much difference.
> >
> > What USB devices do you have on the failing system?  In particular,
> > what is 5-1?  If you unplug it before suspending, does the problem go
> > away?  (It certainly should!)
> >
> >   
> 
> No external usb devices.  There are three internal USB devices:
> Bluetooth, a Sierra CDMA modem thingy and a fingerprint reader.
> 
> $ lsusb
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 005 Device 003: ID 0483:2016 SGS Thomson Microelectronics
> Fingerprint Reader
> Bus 005 Device 002: ID 0a5c:2110 Broadcom Corp. Bluetooth Controller
> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> Bus 003 Device 003: ID 1199:0218 Sierra Wireless, Inc. MC5720 Wireless Modem
> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
> 
> The rfkill switch "unplugs" the two wireless devices, so I'll try that
> before suspending next time (if I remember).

Is this still a problem?

Is this related to other Bluetooth suspend/resume regressions in 
2.6.27?

Alan Stern

