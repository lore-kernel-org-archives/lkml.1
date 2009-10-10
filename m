Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbZJJB4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbZJJB4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 21:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbZJJB4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 21:56:50 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35315 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757951AbZJJB4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 21:56:49 -0400
Date: Fri, 9 Oct 2009 21:56:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Hugh Blemings <hugh@blemings.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 (and 2.6.32-rc3)
In-Reply-To: <1255134753.2219.3.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0910092153300.25597-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Oct 2009, Benjamin Herrenschmidt wrote:

> (Adding Rafael)
> 
> On Sat, 2009-10-10 at 11:31 +1100, Benjamin Herrenschmidt wrote:
> > On Sat, 2009-10-10 at 11:25 +1100, Benjamin Herrenschmidt wrote:
> > > Hi folks !
> > > 
> > > My USB GSM modem (Huawei 169, pretty common stuff) stopped working in
> > > the latest ubuntu karmic update. So far, I tracked it down to a
> > > regression that happened in the stable releases between 2.6.31.1 and
> > > 2.6.31.2 (still present in .3). I haven't tested 2.6.32-rc* yet and
> > > haven't had a chance to bisect (need to make myself a trimmed
> > > down .config first).
> > 
> > 2.6.32-rc3 is also busted with a different log output:
> > 
> > Oct 10 11:27:36 pasglop kernel: [   34.480060] usb 4-1: new full speed USB device using uhci_hcd and address 2
> > Oct 10 11:27:36 pasglop kernel: [   34.645057] usb 4-1: configuration #1 chosen from 1 choice
> > Oct 10 11:27:36 pasglop kernel: [   34.658115] Initializing USB Mass Storage driver...
> > Oct 10 11:27:36 pasglop kernel: [   34.660006] scsi2 : SCSI emulation for USB Mass Storage devices
> > Oct 10 11:27:36 pasglop kernel: [   34.660290] usbcore: registered new interface driver usb-storage
> > Oct 10 11:27:36 pasglop kernel: [   34.660294] USB Mass Storage support registered.
> > Oct 10 11:27:36 pasglop kernel: [   34.661566] usb-storage: device found at 2
> > Oct 10 11:27:36 pasglop kernel: [   34.661568] usb-storage: waiting for device to settle before scanning
> > Oct 10 11:27:36 pasglop kernel: [   35.100131] usb 4-1: USB disconnect, address 2
> > Oct 10 11:27:36 pasglop kernel: [   35.345076] usb 4-1: new full speed USB device using uhci_hcd and address 3
> > Oct 10 11:27:41 pasglop kernel: [   35.503633] usb 4-1: configuration #1 chosen from 1 choice
> > Oct 10 11:27:41 pasglop kernel: [   35.515533] scsi6 : SCSI emulation for USB Mass Storage devices
> > Oct 10 11:27:41 pasglop kernel: [   35.516567] usb-storage: device found at 3
> > Oct 10 11:27:41 pasglop kernel: [   35.516569] usb-storage: waiting for device to settle before scanning
> > Oct 10 11:27:41 pasglop kernel: [   40.518055] usb-storage: device scan complete
> > Oct 10 11:27:41 pasglop kernel: [   40.521051] scsi 6:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
> > Oct 10 11:27:41 pasglop kernel: [   40.524065] scsi 6:0:0:1: Direct-Access     HUAWEI   SD Storage       2.31 PQ: 0 ANSI: 2
> > Oct 10 11:27:41 pasglop kernel: [   40.546018] sr1: scsi-1 drive
> > Oct 10 11:27:43 pasglop kernel: [   40.547167] sr 6:0:0:0: Attached scsi CD-ROM sr1
> > Oct 10 11:27:43 pasglop kernel: [   40.548872] sr 6:0:0:0: Attached scsi generic sg2 type 5
> > Oct 10 11:27:43 pasglop kernel: [   40.549178] sd 6:0:0:1: Attached scsi generic sg3 type 0
> > Oct 10 11:27:43 pasglop kernel: [   40.681084] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> > Oct 10 11:27:43 pasglop kernel: [   40.960039] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> > Oct 10 11:27:43 pasglop kernel: [   41.233071] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> > Oct 10 11:27:43 pasglop kernel: [   41.509066] usb 4-1: reset full speed USB device using uhci_hcd and address 3
...
> > At the end, I think I yanked it out.

This looks a lot like a hardware problem, such as bad USB cables.  
Could you collect a usbmon trace for bus 4?  It ought to show whether
this is the case or whether software is at fault.

Alan Stern

