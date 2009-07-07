Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbZGGVYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbZGGVYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbZGGVYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:24:42 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:37942 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbZGGVYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:24:41 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Tue, 7 Jul 2009 16:24:34 -0500
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0907071559410.8221-100000@iolanthe.rowland.org> <200907071552.09196.lkml@morethan.org>
In-Reply-To: <200907071552.09196.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071624.37176.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue July 7 2009, Michael S. Zick wrote:
> On Tue July 7 2009, Alan Stern wrote:
> > On Tue, 7 Jul 2009, Michael S. Zick wrote:
> > 
> > > Will add that to my list - -
> > > I need to do that to find/fix that error path message flood loop in ehci anyway.
> > 
> > What EHCI message flood?
> > 
> 

Here is an example of the message paths taken - I have another 27Mbytes of the same
if this snippet isn't enough.

Jun 30 10:25:48 cb01 kernel: usb 1-1: new high speed USB device using ehci_hcd and a
ddress 5
Jun 30 10:25:48 cb01 kernel: usb 1-1: New USB device found, idVendor=0930, idProduct
=6545
Jun 30 10:25:48 cb01 kernel: usb 1-1: New USB device strings: Mfr=1, Product=2, Seri
alNumber=3
Jun 30 10:25:48 cb01 kernel: usb 1-1: Product: USB Flash Memory
Jun 30 10:25:48 cb01 kernel: usb 1-1: Manufacturer:
Jun 30 10:25:48 cb01 kernel: usb 1-1: SerialNumber: 5B8204000008
Jun 30 10:25:48 cb01 kernel: usb 1-1: configuration #1 chosen from 1 choice
Jun 30 10:25:48 cb01 kernel: scsi3 : SCSI emulation for USB Mass Storage devices
Jun 30 10:25:48 cb01 kernel: usb-storage: device found at 5
Jun 30 10:25:48 cb01 kernel: usb-storage: waiting for device to settle before scanni
ng
Jun 30 10:25:50 cb01 kernel: usb 1-1: USB disconnect, address 5
Jun 30 10:38:00 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:02 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:02 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:02 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:04 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:04 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:04 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:06 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:06 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:06 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:08 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:08 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:08 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:10 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:10 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:10 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:12 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:12 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:12 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:14 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:14 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:14 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:16 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:16 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:16 cb01 kernel: hub 2-0:1.0: over-current change on port 1

Jun 30 10:38:16 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:18 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:18 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:18 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:20 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:20 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:20 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:22 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:22 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:22 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:24 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:24 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:24 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:26 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:26 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:26 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:28 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:28 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:28 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:30 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:30 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:30 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:31 cb01 kernel: sd 2:0:0:0: Device offlined - not ready after error recovery
Jun 30 10:38:32 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:32 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:32 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:34 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:34 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: over-current change on port 1
Jun 30 10:38:34 cb01 kernel: ehci_hcd 0000:00:10.4: port 1 resume error -19
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: over-current change on port 2
Jun 30 10:38:34 cb01 kernel: ehci_hcd 0000:00:10.4: port 2 resume error -19
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: connect-debounce failed, port 2 disabled
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: over-current change on port 3
Jun 30 10:38:34 cb01 kernel: ehci_hcd 0000:00:10.4: port 3 resume error -19
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: connect-debounce failed, port 3 disabled
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: over-current change on port 4
Jun 30 10:38:34 cb01 kernel: ehci_hcd 0000:00:10.4: port 4 resume error -19
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: connect-debounce failed, port 4 disabled
Jun 30 10:38:34 cb01 kernel: hub 1-0:1.0: over-current change on port 5
Jun 30 10:38:35 cb01 kernel: ehci_hcd 0000:00:10.4: port 6 resume error -19
Jun 30 10:38:35 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jun 30 10:38:35 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:36 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:36 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: over-current change on port 1
Jun 30 10:38:37 cb01 kernel: ehci_hcd 0000:00:10.4: port 1 resume error -19
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: over-current change on port 2
Jun 30 10:38:37 cb01 kernel: ehci_hcd 0000:00:10.4: port 2 resume error -19
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: connect-debounce failed, port 2 disabled
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: over-current change on port 3
Jun 30 10:38:37 cb01 kernel: ehci_hcd 0000:00:10.4: port 3 resume error -19
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: connect-debounce failed, port 3 disabled
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: over-current change on port 4
Jun 30 10:38:37 cb01 kernel: ehci_hcd 0000:00:10.4: port 4 resume error -19
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jun 30 10:38:37 cb01 kernel: ehci_hcd 0000:00:10.4: port 5 resume error -19
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: over-current change on port 6
Jun 30 10:38:37 cb01 kernel: usb 1-6: USB disconnect, address 4
Jun 30 10:38:37 cb01 kernel: ehci_hcd 0000:00:10.4: port 6 resume error -19
Jun 30 10:38:37 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jun 30 10:38:37 cb01 kernel: hub 2-0:1.0: over-current change on port 1
Jun 30 10:38:39 cb01 kernel: __ratelimit: 2 callbacks suppressed
Jun 30 10:38:39 cb01 kernel: hub 2-0:1.0: connect-debounce failed, port 1 disabled
Jun 30 10:38:39 cb01 kernel: hub 2-0:1.0: over-current change on port 2
Jun 30 10:38:39 cb01 kernel: hub 1-0:1.0: over-current change on port 1
Jun 30 10:38:39 cb01 kernel: ehci_hcd 0000:00:10.4: port 1 resume error -19
Jun 30 10:38:39 cb01 kernel: hub 1-0:1.0: hub_port_status failed (err = -32)
Jun 30 10:38:39 cb01 kernel: hub 1-0:1.0: connect-debounce failed, port 1 disabled


> Give me a chance to test what you have already put on my plate.
>

Mike
> It isn't very interesting - when the driver shuts down a hub
> for "problems found" (I can't be more specific at the moment)
> It will try to immediately after resume the hub;
> Which leads to it taking the hub out of service;
> Which leads to it trying to resume the hub;
> etc. etc. etc.
> That message flood in the error recovery path.
> 
> Set: ignore_oc=1 on the command line and that will stop the flood
> at the first message - but only because it hard-locks the kernel with irq's disabled.
> 
> On this machine, the "over current" sense is a false indication -
> something is not within the expected range.
> 
> Thank goodness, no one has asked me to get this kernel certified
> for life-support use (not possible, the VIA silicon isn't certified either).  ;)
> 
> Mike
> > Alan Stern
> > 
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


