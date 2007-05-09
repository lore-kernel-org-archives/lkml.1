Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbXEIJ5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbXEIJ5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbXEIJyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:54:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57449 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836AbXEIJyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:54:45 -0400
Date: Wed, 9 May 2007 02:55:32 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, cornelia.huck@de.ibm.com, bunk@stusta.de,
       linux-kernel@vger.kernel.org
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
	(PCI_MULTITHREAD_PROBE)
Message-ID: <20070509095532.GB13053@kroah.com>
References: <20070508212117.0be9dfe5@gondolin.boeblingen.de.ibm.com> <alpine.LFD.0.98.0705081227230.3882@woody.linux-foundation.org> <alpine.LFD.0.98.0705081249540.3882@woody.linux-foundation.org> <20070508.144154.31643026.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508.144154.31643026.davem@davemloft.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 02:41:54PM -0700, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 8 May 2007 13:01:21 -0700 (PDT)
> 
> > In fact, there is nothing wrong with having *both* a synchronous part, and 
> > an async part:
> > 
> > 	.probe = mydriver_setup,
> > 	.probe_async = mydriver_spin_up_and_probe_devices,
>  ...
> > Hmm? Would something like this work? I dunno, but it seems a hell of a lot 
> > safer and more capable than the aborted PCI multithreaded probing that was 
> > an "all or nothing" approach.
> 
> I definitely agree that we need a transitonary approach to this.
> 
> Although I kind of preferred the idea you mentioned where the
> device could launch the asynchronous probe and just return from
> the normal ->probe() immediately.

Yes, let this be a decision the individual PCI driver does, I don't want
to put this two-stage thing in the driver core, but any individual bus
can implement it if they really want to.

> This might get tricky if the callers do some kind of reference
> counting or other resource management based upon the ->probe()
> return value since it wouldn't know what happened to the
> launched asynchronous probe when it returns from ->probe().

As long as the ->probe() call returns that the driver has clamed the
device, and the ->remove() call can be handled properly while the driver
is off doing whatever it wants to in the initialization, the driver core
should work just fine, no changes needed.

thanks,

greg k-h
