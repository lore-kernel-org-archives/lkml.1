Return-Path: <linux-kernel-owner+w=401wt.eu-S934658AbZJJAdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934658AbZJJAdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 20:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761541AbZJJAdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 20:33:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:51832 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758903AbZJJAda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 20:33:30 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 (and 2.6.32-rc3)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Hugh Blemings <hugh@blemings.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1255134684.2219.2.camel@pasglop>
References: <1255134315.2139.8.camel@pasglop>
	 <1255134684.2219.2.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Oct 2009 11:32:33 +1100
Message-Id: <1255134753.2219.3.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Rafael)

On Sat, 2009-10-10 at 11:31 +1100, Benjamin Herrenschmidt wrote:
> On Sat, 2009-10-10 at 11:25 +1100, Benjamin Herrenschmidt wrote:
> > Hi folks !
> > 
> > My USB GSM modem (Huawei 169, pretty common stuff) stopped working in
> > the latest ubuntu karmic update. So far, I tracked it down to a
> > regression that happened in the stable releases between 2.6.31.1 and
> > 2.6.31.2 (still present in .3). I haven't tested 2.6.32-rc* yet and
> > haven't had a chance to bisect (need to make myself a trimmed
> > down .config first).
> 
> 2.6.32-rc3 is also busted with a different log output:
> 
> Oct 10 11:27:36 pasglop kernel: [   34.480060] usb 4-1: new full speed USB device using uhci_hcd and address 2
> Oct 10 11:27:36 pasglop kernel: [   34.645057] usb 4-1: configuration #1 chosen from 1 choice
> Oct 10 11:27:36 pasglop kernel: [   34.658115] Initializing USB Mass Storage driver...
> Oct 10 11:27:36 pasglop kernel: [   34.660006] scsi2 : SCSI emulation for USB Mass Storage devices
> Oct 10 11:27:36 pasglop kernel: [   34.660290] usbcore: registered new interface driver usb-storage
> Oct 10 11:27:36 pasglop kernel: [   34.660294] USB Mass Storage support registered.
> Oct 10 11:27:36 pasglop kernel: [   34.661566] usb-storage: device found at 2
> Oct 10 11:27:36 pasglop kernel: [   34.661568] usb-storage: waiting for device to settle before scanning
> Oct 10 11:27:36 pasglop kernel: [   35.100131] usb 4-1: USB disconnect, address 2
> Oct 10 11:27:36 pasglop kernel: [   35.345076] usb 4-1: new full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:41 pasglop kernel: [   35.503633] usb 4-1: configuration #1 chosen from 1 choice
> Oct 10 11:27:41 pasglop kernel: [   35.515533] scsi6 : SCSI emulation for USB Mass Storage devices
> Oct 10 11:27:41 pasglop kernel: [   35.516567] usb-storage: device found at 3
> Oct 10 11:27:41 pasglop kernel: [   35.516569] usb-storage: waiting for device to settle before scanning
> Oct 10 11:27:41 pasglop kernel: [   40.518055] usb-storage: device scan complete
> Oct 10 11:27:41 pasglop kernel: [   40.521051] scsi 6:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
> Oct 10 11:27:41 pasglop kernel: [   40.524065] scsi 6:0:0:1: Direct-Access     HUAWEI   SD Storage       2.31 PQ: 0 ANSI: 2
> Oct 10 11:27:41 pasglop kernel: [   40.546018] sr1: scsi-1 drive
> Oct 10 11:27:43 pasglop kernel: [   40.547167] sr 6:0:0:0: Attached scsi CD-ROM sr1
> Oct 10 11:27:43 pasglop kernel: [   40.548872] sr 6:0:0:0: Attached scsi generic sg2 type 5
> Oct 10 11:27:43 pasglop kernel: [   40.549178] sd 6:0:0:1: Attached scsi generic sg3 type 0
> Oct 10 11:27:43 pasglop kernel: [   40.681084] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:43 pasglop kernel: [   40.960039] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:43 pasglop kernel: [   41.233071] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:43 pasglop kernel: [   41.509066] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:44 pasglop kernel: [   41.784064] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:44 pasglop kernel: [   42.057066] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:44 pasglop kernel: [   42.329066] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:44 pasglop kernel: [   42.613070] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:44 pasglop kernel: [   42.888112] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:44 pasglop kernel: [   43.160070] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:46 pasglop kernel: [   43.433054] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:46 pasglop kernel: [   43.705212] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:46 pasglop kernel: [   43.981068] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:46 pasglop kernel: [   44.257074] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:46 pasglop kernel: [   44.536063] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:46 pasglop kernel: [   44.813088] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:48 pasglop kernel: [   45.085065] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:48 pasglop kernel: [   45.357085] usb 4-1: reset full speed USB device using uhci_hcd and address 3
>    .../... (more of these)
> Oct 10 11:27:51 pasglop kernel: [   48.779909] sd 6:0:0:1: [sdb] Attached SCSI removable disk
> Oct 10 11:27:51 pasglop kernel: [   48.904062] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:51 pasglop kernel: [   49.174068] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:51 pasglop kernel: [   49.445548] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:52 pasglop kernel: [   49.717290] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:52 pasglop kernel: [   49.985098] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:52 pasglop kernel: [   50.268061] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:52 pasglop kernel: [   50.544107] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:52 pasglop kernel: [   50.817073] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:52 pasglop kernel: [   51.088083] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:52 pasglop kernel: [   51.356079] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:54 pasglop kernel: [   51.625086] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:54 pasglop kernel: [   51.893071] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:54 pasglop kernel: [   52.161084] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:54 pasglop kernel: [   52.429060] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:54 pasglop kernel: [   52.701104] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:27:54 pasglop kernel: [   52.969058] usb 4-1: reset full speed USB device using uhci_hcd and address 3
>    .../... (more of these)
> Oct 10 11:28:21 pasglop kernel: [   79.889107] usb 4-1: reset full speed USB device using uhci_hcd and address 3
> Oct 10 11:28:21 pasglop kernel: [   79.945827] usb 4-1: USB disconnect, address 3
> Oct 10 11:28:21 pasglop kernel: [   79.950827] sr 6:0:0:0: [sr1] Unhandled error code
> Oct 10 11:28:21 pasglop kernel: [   79.950836] sr 6:0:0:0: [sr1] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Oct 10 11:28:21 pasglop kernel: [   79.950846] sr 6:0:0:0: [sr1] CDB: Read(10): 28 00 00 00 00 c6 00 00 20 00
> Oct 10 11:28:21 pasglop kernel: [   79.950872] end_request: I/O error, dev sr1, sector 792
> Oct 10 11:28:21 pasglop kernel: [   79.950883] Buffer I/O error on device sr1, logical block 792
> Oct 10 11:28:21 pasglop kernel: [   79.950892] Buffer I/O error on device sr1, logical block 793
> Oct 10 11:28:21 pasglop kernel: [   79.950899] Buffer I/O error on device sr1, logical block 794
> Oct 10 11:28:21 pasglop kernel: [   79.950906] Buffer I/O error on device sr1, logical block 795
> Oct 10 11:28:21 pasglop kernel: [   79.950913] Buffer I/O error on device sr1, logical block 796
> Oct 10 11:28:21 pasglop kernel: [   79.950921] Buffer I/O error on device sr1, logical block 797
> Oct 10 11:28:21 pasglop kernel: [   79.950927] Buffer I/O error on device sr1, logical block 798
> 
> At the end, I think I yanked it out.
> 
> Cheers,
> Ben.
> 


