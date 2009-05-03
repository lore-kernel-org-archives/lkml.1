Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZECXT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZECXT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZECXTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:19:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:46414 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZECXTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:19:45 -0400
Date: Sun, 3 May 2009 16:21:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       David VomLehn <dvomlehn@cisco.com>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
       <greg@kroah.com>, <linux-scsi@vger.kernel.org>,
       <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/5] initdev:kernel: Asynchronously-discovered device
 synchronization, v5
Message-ID: <20090503162115.2dff79bd@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.0905021335150.26241-100000@netrider.rowland.org>
References: <1241272876.3639.27.camel@mulgrave.int.hansenpartnership.com>
	<Pine.LNX.4.44L0.0905021335150.26241-100000@netrider.rowland.org>
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

On Sat, 2 May 2009 13:55:45 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Sat, 2 May 2009, James Bottomley wrote:
> 
> > OK, so in your scheme, I get why console devices: they need to be
> > present early before we start dumping console output otherwise it
> > can get lost.
> > 
> > However, I don't see the need for either network or block.
> > 
> > For network, the only early discovery use is net root (which can be
> > done fully asynchronously)
> 
> Are you referring to the "rootwait" kernel parameter?  Is there a 
> reason why this is a boot-time parameter instead of always being
> set? I mean, under what circumstances would you _not_ want to wait
> until the root device is present?

if you have an initrd ;-)
> 
> Perhaps with some enterprise systems, it is preferred to have the 
> system fail with an explicit error message rather than wait 
> indefinitely...

actually, in an enterprise system, you want to reboot.
The bootloader might boot a different kernel the next time
that is known to work.
(for example, the current kernel might have been booted with the "once"
grub option)
> 
> > What I'm getting at is that I don't see the benefit of this in the
> > light of Arjan's async boot system, which can also tell us when all
> > discovery is complete ... what added benefit am I missing here?
> 
> How does Arjan's async boot system tell use when all discovery is
> complete?  AFAICS, it only tells you when all its async tasks are
> finished.  But device discovery and registration sometimes use other
> asynchronous techniques which Arjan's code is unaware of.
> Examples: the USB khubd thread, the USB mass-storage scanning thread,
> and the SCSI async-scanning thread.

for normal device probing we already have infrastructure though...
wait_for_device_probe, driver_probe_done and friends...
(the scsi scanning thread is being converted to the async
infrastructure btw)

do we need to invent more ?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
