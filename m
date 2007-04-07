Return-Path: <linux-kernel-owner+w=401wt.eu-S965211AbXDGEH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbXDGEH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 00:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965233AbXDGEH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 00:07:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965211AbXDGEH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 00:07:28 -0400
Date: Fri, 6 Apr 2007 17:43:03 -0700
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove the broken PCI_MULTITHREAD_PROBE option
Message-ID: <20070407004303.GF23230@suse.de>
References: <20070327010251.GX16477@stusta.de> <20070327130351.51aff00e@gondolin.boeblingen.de.ibm.com> <20070327225006.GC4478@kroah.com> <20070328103625.23910f1e@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328103625.23910f1e@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2007 at 10:36:25AM +0200, Cornelia Huck wrote:
> On Tue, 27 Mar 2007 15:50:06 -0700,
> Greg KH <greg@kroah.com> wrote:
> 
> > > Greg, what about driver-core-per-subsystem-multithreaded-probing.patch?
> > > PCI_MULTITHREAD_PROBE shoudn't be broken with that, only in mainline?
> > 
> > Do you want to enable PCI multithreaded probing using your patch?  I
> > don't think the world is ready for pci multithreaded probing as was
> > determined by the zillion of bug reports from people who like to enable
> > config options that state in big letters, "THIS WILL BREAK YOUR BOX"...
> 
> But IIRC, that was without my patch?

Oh yes, your patch had nothing to do with it.

It was a more general, "do we want to allow multithreaded probing at
all" type question.  Some suggested that we allow it only by letting the
individual busses handle it (like we prototyped in the USB core),
instead of having the driver core do it.

> Wouldn't per-subsystem multithreaded probing just expose bugs that
> could also be exposed on SMP systems?

Yes, it would be the same.

> > And I'm still questioning if we should add your patch at all, as I don't
> > think any other subsystems need it.  Do you?
> 
> The css/ccw busses may profit from it, since we tend to have thousands
> of devices there. OTOH, we've already tried to make probing as
> asynchronous as possible, so maybe there isn't that much gain. I'd need
> to do some measurements (when I find some time...)

Ok, I'll keep the patch then and send it to Linus for 2.6.22, I didn't
realize your stuff would work well with it.

thanks,

greg k-h
