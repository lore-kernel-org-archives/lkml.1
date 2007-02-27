Return-Path: <linux-kernel-owner+w=401wt.eu-S1751618AbXB0ORL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbXB0ORL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXB0ORL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:17:11 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.189]:53149 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbXB0ORK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:17:10 -0500
From: Oliver Neukum <oliver@neukum.org>
To: ebuddington@wesleyan.edu
Subject: Re: USB misbehavior causes system hang
Date: Tue, 27 Feb 2007 15:15:58 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <20070227140610.GC6850@pool-71-123-99-133.spfdma.east.verizon.net>
In-Reply-To: <20070227140610.GC6850@pool-71-123-99-133.spfdma.east.verizon.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702271515.58270.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH61GhaNeys
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 27. Februar 2007 15:06 schrieb Eric Buddington:

Exactly this portion of the log would hold the reason for the reset.
 
> usb 1-6.2: reset high speed USB device using ehci_hcd and address 36
> usb 1-6.2: device descriptor read/64, error -110
> usb 1-6.2: device descriptor read/64, error -110
[..]
> end_request: I/O error, dev sda, sector 919931828
> sd 1:0:0:0: rejecting I/O to offline device
> sd 1:0:0:0: rejecting I/O to offline device
> sd 1:0:0:0: rejecting I/O to offline device

By that point USB is no longer involved. These requests error out
in the SCSI layer.

> My softdog script loops 'date >/tmp/$logfile;echo 1 > /dev/watchdog; sleep
> 30'. Nothing in it accesses the USB disk. /tmp is tmpfs.

If you've written to the USB disk a lot, you are likely to cause writes
to it as soon as you are under memory pressure.
 
> Should the USB failure cause this problem?

No.

	Regards
		Oliver
