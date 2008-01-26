Return-Path: <linux-kernel-owner+w=401wt.eu-S1757411AbYAZDD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411AbYAZDD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 22:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYAZDDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 22:03:49 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:9732 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbYAZDDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 22:03:47 -0500
Date: Fri, 25 Jan 2008 21:03:02 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Hot (un)plugging of a SATA drive with sata_nv (CK8S) ?
In-reply-to: <fa.PdKzY9gi8w+fleyC/mVql2UDhtc@ifi.uio.no>
To: lkml@qult.net
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <479AA2E6.8070307@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.PdKzY9gi8w+fleyC/mVql2UDhtc@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignacy Gawedzki wrote:
> Hi everyone,
> 
> I'm having trouble to determine the cause of the following behavior.  I'm not
> even sure that I'm supposed to hot plug and unplug a SATA drive from a nForce3
> Ultra (apparently CK8S, on a Gigabyte K8NS Ultra 939 mobo) SATA interface, to
> begin with.  The information is hard to find given that the sata_nv driver
> supports a range of different hardware.
> 
> I've recently acquired an external drive with (among others) an eSATA
> interface, so I also bought a eSATA->SATA bracket and intend to use that drive
> (Lacie d2 quadra 500G) through eSATA.

BTW, eSATA cannot technically be converted properly to SATA with a 
simple connector adapter. eSATA is supposed to use higher signalling 
voltages and so using such an adapter is not guaranteed to work.

> 
> The thing is that if I boot the machine with the drive plugged and turned on,
> it is properly detected and usable.  If, at some point, I want to remove the
> drive, I unmount any partitions on it and issue the proper scsiadd -r command
> (usually scsiadd -r 1 0 0 0, since this is the second SATA drive) and
> everything is fine (I turn the drive off and unplug it), so far.  Next, when
> I want to use the drive again, it's still detected alright (although appears
> as sdc and not sdb anymore), but the SCSI layer issues "scsi 1:0:0:0:
> rejecting I/O to dead device" from time to time.  Then any scsiadd -r 1 0 0 0
> command fails with "No such device or address", although it appears in the
> output of scsiadd -p or even scsiadd -s (always as 1 0 0 0).  If I ignore that
> detail and switch the drive off, then the kernel eventually notices that the
> drive is gone and the SCSI layer attempts to stop the device and fails ([sdc]
> START_STOP FAILED).  From that moment on, any attempt to plug the drive again
> fails.  The kernel issues "ata2: hard resetting port" and "ata2: port is slow
> to respond, please be patient (Status 0x80)" periodically, until I switch the
> drive off.
> 
> If the drive is not present at boot, then hot plugging it fails.  The kernel
> first soft resets the port, then issues the "please be patient (Status 0x80)"
> message, complains that SRST failed (errno=-16) and goes on hard resetting the
> port, issuing "please be patient (Status 0x80)" and complaining that COMRESET
> failed (errno=-16), periodically, until the drive is switched off.

Full dmesg output would be useful..

> 
> If somebody could tell me whether hot-plugging is supposed to work with my
> SATA interface, it would be nice. =)  The motherboard happens to offer another
> SATA interface (Sil3512A) which is well supported and appears to support
> hot-plugging as well, but it conflicts nastily with my PCTV Pro (bttv) card
> (which are apparently known to conflict with the Sil SATA interfaces).
> 
> Thanks for any help.
> 
> Ignacy
> 

