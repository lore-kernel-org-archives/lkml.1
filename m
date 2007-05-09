Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbXEIJwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbXEIJwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbXEIJvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:51:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57422 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbXEIJvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:51:50 -0400
Date: Wed, 9 May 2007 02:53:02 -0700
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 5adc55da4a7758021bcc374904b0f8b076508a11
	(PCI_MULTITHREAD_PROBE)
Message-ID: <20070509095302.GA13053@kroah.com>
References: <20070508153713.344cc881@gondolin.boeblingen.de.ibm.com> <20070508141149.GJ4226@stusta.de> <alpine.LFD.0.98.0705080819350.3974@woody.linux-foundation.org> <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508183846.28a94797@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 06:38:46PM +0200, Cornelia Huck wrote:
> On Tue, 8 May 2007 08:27:34 -0700 (PDT),
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > And no, we should not do it at the device core level. In fact, I don't 
> > think we should do it at that level at all. 
> > 
> > I'm pretty sure that the performance problems are at individual device 
> > drivers, and that the right solution is to thread at *that* level. Not 
> > higher up.
> 
> These are two different problems:
> 
> 1. Probing taking long for individual device drivers. I agree, this
> should be solved at the driver level.

For your bus perhaps, but not for PCI.

> 2. Sheer volume of devices on a bus. Even if the indivdual probing
> doesn't take long, having all devices probed one after the other may
> take a lot of time. Putting the actual probe on a thread makes it
> possible to run several probes in parallel, thereby cutting probing
> time.

Again, not for PCI, right?

If you want to implement this for your bus type, fine, I have no
objection to that at all, but not for PCI, it's just not worth it.

thanks,

greg k-h
