Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZEDOn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZEDOn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZEDOnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:43:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:57374 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZEDOnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:43:13 -0400
Date: Mon, 4 May 2009 07:45:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       David VomLehn <dvomlehn@cisco.com>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
       <greg@kroah.com>, <linux-scsi@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/5] initdev:kernel: Asynchronously-discovered device
 synchronization, v5
Message-ID: <20090504074522.13f1ed77@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.0905041026560.2961-100000@iolanthe.rowland.org>
References: <20090503162115.2dff79bd@infradead.org>
	<Pine.LNX.4.44L0.0905041026560.2961-100000@iolanthe.rowland.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009 10:30:06 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Sun, 3 May 2009, Arjan van de Ven wrote:
> 
> > > Perhaps with some enterprise systems, it is preferred to have the 
> > > system fail with an explicit error message rather than wait 
> > > indefinitely...
> > 
> > actually, in an enterprise system, you want to reboot.
> > The bootloader might boot a different kernel the next time
> > that is known to work.
> > (for example, the current kernel might have been booted with the
> > "once" grub option)
> 
> Which makes it imperative that the system knows when all the block
> devices have been probed, so it can stop waiting.
> 
> > > How does Arjan's async boot system tell use when all discovery is
> > > complete?  AFAICS, it only tells you when all its async tasks are
> > > finished.  But device discovery and registration sometimes use
> > > other asynchronous techniques which Arjan's code is unaware of.
> > > Examples: the USB khubd thread, the USB mass-storage scanning
> > > thread, and the SCSI async-scanning thread.
> > 
> > for normal device probing we already have infrastructure though...
> > wait_for_device_probe, driver_probe_done and friends...
> > (the scsi scanning thread is being converted to the async
> > infrastructure btw)
> > 
> > do we need to invent more ?
> 
> I suppose the usb-storage scanning thread could also be converted to 
> the async infrastructure, although I haven't heard of anybody working 
> on it.
> 
> But the USB hub driver's thread (khubd) cannot be converted.  It is 
> central to the discovery of USB-based block devices.  How would you 
> handle that?

take a ref in the driver_probe_done() sense, and release it when you
know you're done probing....

at that point all existing infrastructure will just work.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
