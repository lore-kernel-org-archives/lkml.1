Return-Path: <linux-kernel-owner+w=401wt.eu-S1760936AbXHELJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936AbXHELJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 07:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXHELJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 07:09:44 -0400
Received: from eazy.amigager.de ([213.239.192.238]:59683 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbXHELJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 07:09:44 -0400
Date: Sun, 5 Aug 2007 13:09:42 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: USB hard disk broken
Message-ID: <20070805110942.GA26278@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20070725072343.GA3483@dose.home.local> <200707251024.37112.oliver@neukum.org> <20070725181312.GA5612@dose.home.local> <200707261006.41368.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707261006.41368.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 10:06:40 +0200, Oliver Neukum wrote:
> Am Mittwoch 25 Juli 2007 schrieb Tino Keitel:
> > On Wed, Jul 25, 2007 at 10:24:36 +0200, Oliver Neukum wrote:
> > > Am Mittwoch 25 Juli 2007 schrieb Tino Keitel:
> > > > Hi,
> > > > 
> > > > I just tried 2.6.23-rc1 and shortly after the boot my external USB hard
> > > > disk went mad.
> > 
> > [...]
> > 
> > > Please recompile with CONFIG_USB_DEBUG set.
> > > 
> > > 	Regards
> > > 		Oliver
> > 
> > I tried, but it didn't happen again.
> 
> Did you try with the old kernel again? This bug may be related to timing.

I tried again -rc1 without USB_DEBUG, and was able to reproduce the
bug 2 times. At the second time, the kernel log shows this:

2007-08-05_10:30:27.75572 kern.err: ehci_hcd 0000:00:1d.7: dev 6 ep1in scatterli
st error 0/-121
2007-08-05_10:30:27.86576 kern.info: usb 1-6: reset high speed USB device using ehci_hcd and address 5
2007-08-05_10:30:55.95293 kern.info: usb 1-6: USB disconnect, address 5
2007-08-05_10:30:55.95300 kern.err: ehci_hcd 0000:00:1d.7: dev 6 ep1in scatterlist error -108/-108
2007-08-05_10:30:55.95310 kern.info: sd 4:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
2007-08-05_10:30:55.95314 kern.warn: end_request: I/O error, dev sdb, sector 594818327
2007-08-05_10:30:55.95321 kern.info: sd 4:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
2007-08-05_10:30:55.95325 kern.warn: end_request: I/O error, dev sdb, sector 594818567
2007-08-05_10:30:55.95331 kern.info: sd 4:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
2007-08-05_10:30:55.95335 kern.warn: end_request: I/O error, dev sdb, sector 594818583
2007-08-05_10:30:55.95342 kern.info: sd 4:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
2007-08-05_10:30:55.95352 kern.warn: end_request: I/O error, dev sdb, sector 594818823
2007-08-05_10:30:55.95356 kern.info: sd 4:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
2007-08-05_10:30:55.95360 kern.warn: end_request: I/O error, dev sdb, sector 594818327
2007-08-05_10:30:55.95455 kern.info: sd 4:0:0:0: [sdb] Result: hostbyte=0x07 driverbyte=0x00
2007-08-05_10:30:55.95461 kern.warn: end_request: I/O error, dev sdb, sector 594818327
2007-08-05_10:30:55.96972 kern.err: scsi 4:0:0:0: rejecting I/O to dead device
2007-08-05_10:30:55.96977 kern.err: scsi 4:0:0:0: rejecting I/O to dead device

The "scatterlist" line wasn't there in the other cases. I'll try again
with the latest git.

Regards,
Tino
