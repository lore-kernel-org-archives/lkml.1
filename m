Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYBLXX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYBLXX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYBLXXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:23:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40522 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbYBLXXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:23:16 -0500
Date: Tue, 12 Feb 2008 15:26:23 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       torvalds@linux-foundation.org, James.Bottomley@HansenPartnership.com,
       jeff@garzik.org, davem@davemloft.net, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212232623.GB8295@kroah.com>
References: <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org> <1202840682.3137.83.camel@localhost.localdomain> <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org> <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org> <20080212194100.GH27894@ZenIV.linux.org.uk> <20080212215152.1470fe7f@core> <20080212141726.1e214729.akpm@linux-foundation.org> <20080212222044.214ad821@core> <20080212225531.GA7216@kroah.com> <20080212225900.3cbe4938@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212225900.3cbe4938@core>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:59:00PM +0000, Alan Cox wrote:
> On Tue, 12 Feb 2008 14:55:31 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > On Tue, Feb 12, 2008 at 10:20:44PM +0000, Alan Cox wrote:
> > > > I think the best way to get the serial drivers maintained would be to cat
> > > > them all onto the end of synclink.c and hope that Paul thinks he did it.
> > > 
> > > Well I've already broken the buffering so he'd fix it ;)
> > > 
> > > We have a pile of old ISA drivers that are going to break soon with the
> > > locking changes and a pile of USB drivers that when I looked at the
> > > locking were so terminally broken I couldn't be bothered to fix them.
> > 
> > Let me know which USB ones are broken, I'll work to fix them.
> 
> That I noticed doing an audit for unlocking the mctrl functions:
> 
> ir-usb: global variables without locking used in per port operations
> iuu_phoenix: no locking on internal data structures
> mos7840: ditto
> option: ditto
> kobil_sct: ditto
> 
> These drivers do interesting things (where interesting is probably not too
> evil on a PC - except ir-usb) involving playing with data structures
> without locks. It seems there was some kind of evolution along the way as
> some drivers do have a carefully used port private data structure lock
> (or two) but many do not.

Ok, I'll look into them this week.  I'm currently working on revamping
the option driver as it had the mistake of being based on the keyspan
drivers, which weren't the nicest to start with...

thanks,

greg k-h
