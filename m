Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbXEIQm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbXEIQm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 12:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756017AbXEIQmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 12:42:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57957 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbXEIQmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 12:42:19 -0400
Date: Wed, 9 May 2007 09:42:07 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
	(PCI_MULTITHREAD_PROBE)
Message-ID: <20070509164207.GA28633@kroah.com>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com> <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org> <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com> <20070509095302.GA13053@kroah.com> <20070509153813.52a7c397@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509153813.52a7c397@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 03:38:13PM +0200, Cornelia Huck wrote:
> On Wed, 9 May 2007 02:53:02 -0700,
> Greg KH <greg@kroah.com> wrote:
> 
> > > 2. Sheer volume of devices on a bus. Even if the indivdual probing
> > > doesn't take long, having all devices probed one after the other may
> > > take a lot of time. Putting the actual probe on a thread makes it
> > > possible to run several probes in parallel, thereby cutting probing
> > > time.
> > 
> > Again, not for PCI, right?
> 
> It seems that everyone agrees now that moving PCI over to a new probing
> model without individual driver support was a bad idea. So generic
> multithreaded probing is dead.

Why is it dead?  Since when is PCI the only bus in the system?

> > If you want to implement this for your bus type, fine, I have no
> > objection to that at all, but not for PCI, it's just not worth it.
> 
> Infrastructure for async probing might not be such a bad idea, though.
> (Aren't there some huge PCI-based machines?) However, I don't really
> care whether PCI or SCSI or $HUGE_BUS use it, but serial synchronous
> probing on a bus looks like a killer on most large systems.

PCI probing is just reading stuff from memory.  The slowness happens
when storage devices need to spin up and/or discover attached drives.

So, the async stuff can be done in those buses if wanted/needed, PCI is
not the problem here.

thanks,

greg k-h
