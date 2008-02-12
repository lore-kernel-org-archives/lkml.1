Return-Path: <linux-kernel-owner+w=401wt.eu-S1761102AbYBLXKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102AbYBLXKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbYBLXJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:09:47 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35799 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760519AbYBLXJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:09:44 -0500
Date: Tue, 12 Feb 2008 22:59:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       torvalds@linux-foundation.org, James.Bottomley@HansenPartnership.com,
       jeff@garzik.org, davem@davemloft.net, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212225900.3cbe4938@core>
In-Reply-To: <20080212225531.GA7216@kroah.com>
References: <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org>
	<1202838082.3137.54.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org>
	<1202840682.3137.83.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org>
	<alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org>
	<20080212194100.GH27894@ZenIV.linux.org.uk>
	<20080212215152.1470fe7f@core>
	<20080212141726.1e214729.akpm@linux-foundation.org>
	<20080212222044.214ad821@core>
	<20080212225531.GA7216@kroah.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 14:55:31 -0800
Greg KH <greg@kroah.com> wrote:

> On Tue, Feb 12, 2008 at 10:20:44PM +0000, Alan Cox wrote:
> > > I think the best way to get the serial drivers maintained would be to cat
> > > them all onto the end of synclink.c and hope that Paul thinks he did it.
> > 
> > Well I've already broken the buffering so he'd fix it ;)
> > 
> > We have a pile of old ISA drivers that are going to break soon with the
> > locking changes and a pile of USB drivers that when I looked at the
> > locking were so terminally broken I couldn't be bothered to fix them.
> 
> Let me know which USB ones are broken, I'll work to fix them.

That I noticed doing an audit for unlocking the mctrl functions:

ir-usb: global variables without locking used in per port operations
iuu_phoenix: no locking on internal data structures
mos7840: ditto
option: ditto
kobil_sct: ditto

These drivers do interesting things (where interesting is probably not too
evil on a PC - except ir-usb) involving playing with data structures
without locks. It seems there was some kind of evolution along the way as
some drivers do have a carefully used port private data structure lock
(or two) but many do not.
