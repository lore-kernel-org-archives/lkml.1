Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbXFJPnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbXFJPnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 11:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbXFJPnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 11:43:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4771 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752640AbXFJPnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 11:43:08 -0400
Date: Sun, 10 Jun 2007 11:43:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Robert de Rooy <robert.de.rooy@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, Greg KH <greg@kroah.com>,
       <Joel.Becker@oracle.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] ThinkPad T41 - Strange USB 2.0 behaviour
In-Reply-To: <466B3B20.5040003@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0706101129070.29131-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007, Robert de Rooy wrote:

> Alan Stern wrote:
> > Unfortunately you posted the system log file instead of the dmesg log, 
> > and your syslogd was configured not to retain debug-level messages.
> >   
> Ok, I did not realize my syslog was filtering the debug-level messages, 
> here is the output from dmesg

> *** plugging device (leaving it in slightly to long, hence the long 
> log); removing the device; rmmod ehci-hcd; plug back in
> usb usb4: usb resume
> usb usb4: finish resume
> hub 4-0:1.0: hub_resume
> ehci_hcd 0000:00:1d.7: resume root hub
> hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0000
> ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
> CONNECT
> hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
> hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
> ehci_hcd 0000:00:1d.7: port 4 high speed
> ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE 
> CONNECT
> usb 4-4: new high speed USB device using ehci_hcd and address 2
> ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
> ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
> ehci_hcd 0000:00:1d.7: devpath 4 ep0in 3strikes
> ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
> hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
> hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
> ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
> CONNECT
> hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
> hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
> ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
> hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
> hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
> ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
> CONNECT
> hub 4-0:1.0: port 4, status 0501, change 0001, 480 Mb/s
> hub 4-0:1.0: debounce: port 4: total 100ms stable 100ms status 0x501
> ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001002 POWER sig=se0 CSC
> hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
> hub 4-0:1.0: state 7 ports 6 chg 0000 evt 0010
> ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC 
> CONNECT

Okay.  It's clear that you've got a hardware problem of some sort.  
Hard to say what it is, but evidently the EHCI controller thinks that 
the device is repeatedly being unplugged and replugged.

Anyway, this isn't a problem of recognizing that a single device is
having problems.  In fact the computer has no way of knowing that a
single device is involved; all it knows is that _something_ gets
plugged into the port and then removed.  There's no way to tell if it's 
the same _something_ from one iteration to the next.

You can manually force the port to run at full speed instead of high 
speed as follows:

	echo '4' >/sys/class/usb_host/usb_host4/companion

The "companion" attribute file contains a list of ports which are 
permanently set to be handled by the EHCI's companion controller.  To 
return to high-speed operation, use '-4' instead of '4' above.  This 
might or might not solve your problem -- the hardware bug might cause 
the port to return automatically to high-speed regardless.

Let me know what happens.

Alan Stern

