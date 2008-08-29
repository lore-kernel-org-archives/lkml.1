Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYH2ObS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYH2ObS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbYH2ObD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:31:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656AbYH2ObA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:31:00 -0400
Date: Fri, 29 Aug 2008 07:30:17 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>, linux-usb@vger.kernel.org
Cc: bgmerrell@novell.com, hirofuchi@users.sourceforge.net,
       linux-kernel@vger.kernel.org, usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080829143017.GB18086@kroah.com>
References: <20080829140224.GC1968@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829140224.GC1968@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 08:02:24AM -0600, Matthew Wilcox wrote:
> 
> I'm in the middle of implementing a userspace client for usbip and I
> strongly feel that the protocol needs to be changed before it is merged.
> 
>  - I'm unconvinced that TCP is the correct protocol to be running this over.
>    I understand the reluctance to use UDP, but the protocol is fundamentally
>    packet-based.  If TCP is used, the delimitation of packets within the
>    stream needs to be much more robust.  I've managed to wedge the VHCI driver
>    a number of times in ways that just wouldn't be possible if we were using
>    a packet protocol instead of a stream protocol.

USB is fundamentally packet-based, so it kind of fits very well.

>  - Endianness.  This is a mess.  The usbip protocol is big-endian, but the
>    encapsulated usb protocol is little-endian.  This doesn't matter to the
>    people who are just tunnelling usb from one computer to another, but for
>    someone implementing a usbip client, it's very confusing.

Then just document it, no big deal.
Yeah, the current code isn't the cleanest here (sparse throws up some
warnings), but it's not that much work to fix it up, it's on my todo
list.

>  - The protocol needs an officially assigned port number.  Port 3240 is 
>    already assigned to Tony Matthews <tmatthews&triomotion.com> February
>    2002 (see http://www.iana.org/assignments/port-numbers)

Great, let's get a real number.

>  - There are actually two completely different protocols in use.  First,
>    the usbipd daemon listens on port 3240, and handles device discovery.
>    When usbip successfully attaches to usbipd, both sides of the connection
>    pass the socket fd into the kernel and the protocol changes.
>  - The protocol sends a 48-byte packet header for every command (and every
>    response).  It's cunningly hidden as a union.

Is that a real problem?

> I think the protocol would be immeasurably improved by going through the
> IETF RFC process and getting feedback from networking experts.  Failing
> that, I have some suggestions about how to improve it.  I was hoping to
> get my client finished before I started mucking with the protocol though.

Why mess with the RFC process, is that really necessary for something
like this?

Windows has had this for years, no need for a RFC there, and if we just
document this well, no need for one here either.

thanks,

greg k-h
