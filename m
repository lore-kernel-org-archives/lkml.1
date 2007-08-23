Return-Path: <linux-kernel-owner+w=401wt.eu-S1762651AbXHWKKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762651AbXHWKKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 06:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbXHWKKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 06:10:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40763 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759517AbXHWKKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 06:10:11 -0400
Date: Thu, 23 Aug 2007 03:04:02 -0700
From: Greg KH <greg@kroah.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Console events and accessibility
Message-ID: <20070823100402.GB6742@kroah.com>
References: <20070821212939.GD3658@interface.famille.thibault.fr> <20070822054855.GB23336@kroah.com> <20070822085355.GB3359@implementation.labri.fr> <20070822130520.GE3359@implementation.labri.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822130520.GE3359@implementation.labri.fr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 03:05:20PM +0200, Samuel Thibault wrote:
> Samuel Thibault, le Wed 22 Aug 2007 10:53:55 +0200, a ?crit :
> > Greg KH, le Tue 21 Aug 2007 22:48:55 -0700, a ?crit :
> > > On Tue, Aug 21, 2007 at 11:29:39PM +0200, Samuel Thibault wrote:
> > > > Some external modules like Speakup need to monitor console output.
> > > > 
> > > > This adds a VT notifier that such modules can use to get console output events:
> > > > allocation, deallocation, writes, other updates (cursor position, switch, etc.)
> > > > 
> > > > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> > > 
> > > Will speakup work with this kind of change?
> > 
> > Here are the last needed bits.
> 
> I mean: yes, with these three patches, speakup will work fine.

3 patches?  I only saw 2.  Or do you mean the modifications of the 3
files?

The patches look sane but you should change the global symbols to play
nicer in the namespace.  Care to respin them together with this change?

> The biggest change we'll have to do in speakup is the way it accesses
> the serial port, which is really dirty for now, but that's an internal
> matter.

Yeah, that shouldn't be that tough to do.

It doesn't look like these changes handle scrolling of the console, do
they?  If so, don't you need to do more?  I had some old patches around
here that had devices that wanted to know cursor positioning, which I
don't think this hook can handle :(

thanks,

greg k-h
