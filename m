Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbYH2Pgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbYH2Pgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYH2Pgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:36:43 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:51161 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbYH2Pgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:36:42 -0400
Date: Fri, 29 Aug 2008 09:36:25 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net, linux-kernel@vger.kernel.org,
       usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080829153625.GF1968@parisc-linux.org>
References: <20080829140224.GC1968@parisc-linux.org> <20080829143017.GB18086@kroah.com> <20080829144354.GD1968@parisc-linux.org> <20080829145407.GB18423@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829145407.GB18423@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 07:54:07AM -0700, Greg KH wrote:
> On Fri, Aug 29, 2008 at 08:43:54AM -0600, Matthew Wilcox wrote:
> > On Fri, Aug 29, 2008 at 07:30:17AM -0700, Greg KH wrote:
> > > On Fri, Aug 29, 2008 at 08:02:24AM -0600, Matthew Wilcox wrote:
> > > > 
> > > > I'm in the middle of implementing a userspace client for usbip and I
> > > > strongly feel that the protocol needs to be changed before it is merged.
> > > > 
> > > >  - I'm unconvinced that TCP is the correct protocol to be running this over.
> > > >    I understand the reluctance to use UDP, but the protocol is fundamentally
> > > >    packet-based.  If TCP is used, the delimitation of packets within the
> > > >    stream needs to be much more robust.  I've managed to wedge the VHCI driver
> > > >    a number of times in ways that just wouldn't be possible if we were using
> > > >    a packet protocol instead of a stream protocol.
> > > 
> > > USB is fundamentally packet-based, so it kind of fits very well.
> > 
> > Erm, did you not read what I wrote?  USB is packet based.  TCP isn't.
> > We shouldn't be using TCP here.
> 
> Sorry, early morning, no coffee yet...
> 
> I think in the end, we should still use TCP otherwise you just end up
> reinventing it with UDP :)

Which brings us to the alternate -- that we need better framing in the
protocol.

> Ok, switch it all to be little endian, not a bit deal.

No, but it does need agreement ;-)

> > > >  - There are actually two completely different protocols in use.  First,
> > > >    the usbipd daemon listens on port 3240, and handles device discovery.
> > > >    When usbip successfully attaches to usbipd, both sides of the connection
> > > >    pass the socket fd into the kernel and the protocol changes.
> > > >  - The protocol sends a 48-byte packet header for every command (and every
> > > >    response).  It's cunningly hidden as a union.
> > > 
> > > Is that a real problem?
> > 
> > Yes, it really is.  It complicates the protocol, complicates the
> > implementation, introduces unnecessary state, and makes it impossible to
> > renegotiate on the same connection.
> 
> Fair enough, patches welcome :)

Patches don't seem appropriate for a design discussion.  I'm more than
happy to make suggestions about how to unify the two protocols.  I'll
send a followup to this with some ideas.

> > Even if we don't go through the RFC process, just writing down the
> > on-wire protocol should be mandatory for taking this kind of thing into
> > the kernel.
> 
> Why, isn't the actual implementation better than a document?  :)

Surely you know that writing things down forces you to understand it
better?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
