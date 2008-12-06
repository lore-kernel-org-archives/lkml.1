Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbYLFCxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbYLFCxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 21:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbYLFCxD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 21:53:03 -0500
Received: from kroah.org ([198.145.64.141]:50237 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754971AbYLFCxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 21:53:00 -0500
Date: Fri, 5 Dec 2008 18:45:08 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Frans Pop <elendil@planet.nl>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
	on Toshiba R500 (bisected)
Message-ID: <20081206024508.GA5099@kroah.com>
References: <200812020320.31876.rjw@sisk.pl> <200812060104.50050.rjw@sisk.pl> <alpine.LFD.2.00.0812051647130.3425@nehalem.linux-foundation.org> <200812060218.13030.rjw@sisk.pl> <alpine.LFD.2.00.0812051750450.3425@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812051750450.3425@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 05:55:16PM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 6 Dec 2008, Rafael J. Wysocki wrote:
> >
> > It only affects the legacy handling, but the non-legacy handling was left
> > untouched.  IOW, the old "default" functions are still there and are being
> > called by the "non-legacy" code (it's only used by USB at the moment, AFAICS).
> 
> Ok.
> 
> > Anyway, I did the test doing it only to the devices which don't have any
> > non-default suspend-resume handling at all and _that_ apparently fixed the
> > problem on my box. :-)
> 
> Which makes sense, btw. Because if you do the pci_save_state() on a device 
> that _does_ have a suspend function, you'll be saving the post-suspend 
> state - ie the device turned off.

I think that is why we did not do it for every device, we didn't want to
touch drivers that already had working suspend calls.

> So yeah, we really can only do the default suspend if the device has no 
> pre-existing suspend function - or we'd need to make sure that all PCI 
> drivers that do have suspend functions would only do the higher-level 
> functionality.

Agreed.

thanks,

greg k-h
