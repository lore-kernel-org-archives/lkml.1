Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbZEBR4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbZEBR4B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 13:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbZEBRzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 13:55:47 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54555 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753485AbZEBRzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 13:55:45 -0400
Date: Sat, 2 May 2009 13:55:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: David VomLehn <dvomlehn@cisco.com>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <linux-usb@vger.kernel.org>,
       <greg@kroah.com>, <linux-scsi@vger.kernel.org>,
       <netdev@vger.kernel.org>, <arjan@infradead.org>
Subject: Re: [PATCH 1/5] initdev:kernel: Asynchronously-discovered device
 synchronization, v5
In-Reply-To: <1241272876.3639.27.camel@mulgrave.int.hansenpartnership.com>
Message-ID: <Pine.LNX.4.44L0.0905021335150.26241-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 May 2009, James Bottomley wrote:

> OK, so in your scheme, I get why console devices: they need to be
> present early before we start dumping console output otherwise it can
> get lost.
> 
> However, I don't see the need for either network or block.
> 
> For network, the only early discovery use is net root (which can be done
> fully asynchronously)

Are you referring to the "rootwait" kernel parameter?  Is there a 
reason why this is a boot-time parameter instead of always being set?  
I mean, under what circumstances would you _not_ want to wait until the 
root device is present?

>  or net console (which I think can be supplied a
> raft of information and isn't usually expected to be up by early boot
> because of the TCP stack dependence) neither of which is a compelling
> use case.

Are you sure the real reason it isn't expected to be up isn't the lack
of a mechanism of the type being proposed?

> Block, likewise, is a udev type discovery:  We can specify the root by
> some type of ID and we can wait until that is found, rather than have an
> elaborate system to check when discovery is finished, which is the only
> benefit this code seems to provide.

The real benefit of knowing when discovery is complete is that it tells
you when to give up and stop waiting.  However I have to agree that in
the case of the root device, there really isn't much point in giving
up.

Perhaps with some enterprise systems, it is preferred to have the 
system fail with an explicit error message rather than wait 
indefinitely...

> What I'm getting at is that I don't see the benefit of this in the light
> of Arjan's async boot system, which can also tell us when all discovery
> is complete ... what added benefit am I missing here?

How does Arjan's async boot system tell use when all discovery is
complete?  AFAICS, it only tells you when all its async tasks are
finished.  But device discovery and registration sometimes use other
asynchronous techniques which Arjan's code is unaware of.  Examples:  
the USB khubd thread, the USB mass-storage scanning thread, and the
SCSI async-scanning thread.

Alan Stern

