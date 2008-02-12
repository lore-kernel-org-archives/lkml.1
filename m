Return-Path: <linux-kernel-owner+w=401wt.eu-S1764391AbYBLSao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764391AbYBLSao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 13:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763043AbYBLSaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 13:30:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58356 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763457AbYBLSaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 13:30:18 -0500
Date: Tue, 12 Feb 2008 10:30:04 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: multiple drivers, single device (was Re: Announce: Linux-next
 (Or Andrew's dream  :-)))
In-Reply-To: <47B1DDD3.2000402@garzik.org>
Message-ID: <alpine.LFD.1.00.0802121027190.2920@woody.linux-foundation.org>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <47B1C829.8020800@garzik.org> <20080212164232.GA326@kroah.com> <47B1DDD3.2000402@garzik.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 Feb 2008, Jeff Garzik wrote:

> Greg KH wrote:
> > The work I'm doing here is for stupid PCI firmware engineers, who have
> > created devices that are different things, all bound up under the same
> > PCI device.  I'm thinking of watchdog timers and random number
> > generator and i2c controller on the same PCI device, or even the more
> > basic, frame buffer and DRM access to the same PCI video device.
> 
> Yes, that has a known solution:  have your driver register i2c, rng, watchdog,
> etc. functions.
> 
> Works just fine inside today's infrastructure, no changes needed.

Indeed. If you have a multi-function device that shows up as a single PCI 
function, just make it have its own "private bus", and make it show up as 
a "devices within a device".

Create the fake PCI subdevices that have no "real" counterpart, except as 
parts of the stupid device that couldn't be bothered to be seen as 
multiple _real_ functions.

That not only solves the infrastructure issues, it's actually The Truth 
with capital letters. It is, after all, how the device actually works 
internally.

			Linus
