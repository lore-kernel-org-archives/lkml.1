Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZG2Opu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZG2Opu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbZG2Opt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:45:49 -0400
Received: from cantor.suse.de ([195.135.220.2]:45404 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbZG2Opt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:45:49 -0400
Date: Wed, 29 Jul 2009 07:44:51 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 14/71] USB: EHCI: use the new clear_tt_buffer interface
Message-ID: <20090729144451.GA563@suse.de>
References: <20090729140308.GA15088@suse.de>
 <Pine.LNX.4.44L0.0907291022520.3087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0907291022520.3087-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 10:24:55AM -0400, Alan Stern wrote:
> On Wed, 29 Jul 2009, Greg KH wrote:
> 
> > On Wed, Jul 29, 2009 at 09:56:31AM -0400, Alan Stern wrote:
> > > On Tue, 28 Jul 2009, Greg KH wrote:
> > > 
> > > > 2.6.30-stable review patch.  If anyone has any objections, please let us know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Alan Stern <stern@rowland.harvard.edu>
> > > > 
> > > > commit 914b701280a76f96890ad63eb0fa99bf204b961c upstream.
> > > > 
> > > > This patch (as1256) changes ehci-hcd and all the other drivers in the
> > > > EHCI family to make use of the new clear_tt_buffer callbacks.  When a
> > > > Clear-TT-Buffer request is in progress for a QH, the QH is not allowed
> > > > to be linked into the async schedule until the request is finished.
> > > > At that time, if there are any URBs queued for the QH, it is linked
> > > > into the async schedule.
> > > 
> > > Greg, can we hold off on applying this patch to the stable tree?
> > > 
> > > It turns out that this change causes a WARN_ON to trigger in some 
> > > circumstances, and the proposed patch to fix _that_ hasn't yet been 
> > > submitted to the mainline because a few people have reported that it 
> > > leaks DMA pool memory.  So far there hasn't been much progress in 
> > > tracking this down.
> > 
> > Sure, I'll drop it.  Should I also drop the patch before this one as
> > well, which was there only because this patch needed it?
> 
> In terms of functionality, it doesn't matter.  I guess you might as 
> well.

Ok, I've now dropped them both.

thanks,

greg k-h
